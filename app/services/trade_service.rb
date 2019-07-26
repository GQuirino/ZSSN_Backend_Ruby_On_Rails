module TradeService
  class << self
    def trade(offer, request)
      @survivor_offer = Survivor.find(offer[:id_survivor])
      @survivor_request = Survivor.find(request[:id_survivor])

      validation = validate_trade(offer, request)
      return validation unless validation.nil?

      Inventory.transaction do
        {
          from: trade_items(@survivor_offer, offer[:inventory], request[:inventory]),
          to: trade_items(@survivor_request, request[:inventory], offer[:inventory])
        }
      end
    end

    private

    def validate_trade(offer, request)
      return Errors.render_survivor_infected(@survivor_offer.id) if @survivor_offer.infected?
      return Errors.render_survivor_infected(@survivor_request.id) if @survivor_request.infected?

      return Errors.render_trade_invalid('Trade not respect table of prices') unless respect_price_table?(offer[:inventory], request[:inventory])

      return Errors.render_trade_invalid("Survivor #{@survivor_offer[:id]} doesn't have enough resources") unless enough_resources?(@survivor_offer,  offer[:inventory])
      return Errors.render_trade_invalid("Survivor #{@survivor_request[:id]} doesn't have enough resources") unless enough_resources?(@survivor_request,  request[:inventory])
    end

    def trade_items(survivor, items_to_remove, items_to_add)
      exchange_items(items_to_remove, items_to_add, survivor)
      survivor.as_json(methods: [:inventories])
    end

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
      items_to_trade.each do |key, val|
        resource = survivor.inventories.find do |r|
          r[:resource_type] == key
        end
        return resource['resource_amount'] >= val.to_i
      end
    end

    def respect_price_table?(resources_offer, resources_request)
      points_offer = InventoryService.generate_points(resources_offer)
      points_request = InventoryService.generate_points(resources_request)
      points_offer == points_request
    end
  end
end
