module TradeService
  class << self
    def trade_items(
      survivor_from, survivor_to,
      resources_offer, resources_request
    )
      enough_resources?(survivor_from, resources_offer)
      enough_resources?(survivor_to, resources_request)
      respect_price_table?(resources_offer, resources_request)
      exchange_items(resources_offer, resources_request, survivor_from)
      exchange_items(resources_request, resources_offer, survivor_to)
      from = survivor_from.to_json(methods: [:inventories])
      to = survivor_to.to_json(methods: [:inventories])
      { from: JSON.parse(from), to: JSON.parse(to) }
    end

    private

    def exchange_items(to_remove, to_add, survivor)
      inventories = survivor.inventories
      to_remove.each do |key, val|
        idx = inventories.index { |i| i[:resource_type] == key }
        resource = inventories[idx]
        resource.resource_amount -= val
      end

      to_add.each do |key, val|
        idx = inventories.index { |i| i[:resource_type] == key }
        resource = inventories[idx]
        resource.resource_amount += val
      end
      inventories
      # Inventory.update_all(inventories)
    end

    def enough_resources?(survivor, items_to_trade)
      reason = "Survivor #{survivor[:id]} doesn't have enough resources"
      items_to_trade.each do |key, val|
        resource = survivor.inventories.find do |r|
          r[:resource_type] == key
        end
        raise Errors::TradeInvalid, reason if resource['resource_amount'] < val
      end
    end

    def respect_price_table?(resources_offer, resources_request)
      reason = 'Trade not respect table of prices'
      points_offer = InventoryService.generate_points(resources_offer)
      points_request = InventoryService.generate_points(resources_request)
      raise Errors::TradeInvalid, reason unless points_offer == points_request
    end
  end
end
