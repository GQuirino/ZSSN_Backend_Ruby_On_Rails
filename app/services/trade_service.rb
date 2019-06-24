require './lib/exceptions/trade_invalid_error'
module TradeService
  class << self
    def trade(offer, request)
      Inventory.transaction do
        {
          from: trade_items(offer[:id_survivor], offer[:inventory], request[:inventory]),
          to: trade_items(request[:id_survivor], request[:inventory], offer[:inventory])
        }
      end
    end

    def trade_items(id_survivor, items_to_remove, items_to_add)
      @survivor = Survivor.find(id_survivor)
      @survivor.infected?

      enough_resources?(@survivor, items_to_remove)
      respect_price_table?(items_to_remove, items_to_add)
      exchange_items(items_to_remove, items_to_add, @survivor)
      @survivor.as_json(methods: [:inventories])
    end

    private

    def exchange_items(to_remove, to_add, survivor)
      remove_lambda = ->(resource, val) { resource.resource_amount -= val.to_i }
      add_lambda = ->(resource, val) { resource.resource_amount += val.to_i }

      update_inventory(to_remove, survivor, remove_lambda)
      update_inventory(to_add, survivor, add_lambda)
    end

    def update_inventory(items, survivor, func)
      inventories = survivor.inventories
      items.each do |key, val|
        idx = inventories.index { |i| i[:resource_type] == key }
        resource = inventories[idx]
        func.call(resource, val)
        Inventory.update(
          resource.id,
          resource_amount: resource.resource_amount
        )
      end
    end

    def enough_resources?(survivor, items_to_trade)
      reason = "Survivor #{survivor[:id]} doesn't have enough resources"
      items_to_trade.each do |key, val|
        resource = survivor.inventories.find do |r|
          r[:resource_type] == key
        end
        raise TradeInvalidError, reason if resource['resource_amount'] < val.to_i
      end
    end

    def respect_price_table?(resources_offer, resources_request)
      reason = 'Trade not respect table of prices'
      points_offer = InventoryService.generate_points(resources_offer)
      points_request = InventoryService.generate_points(resources_request)
      raise TradeInvalidError, reason unless points_offer == points_request
    end
  end
end
