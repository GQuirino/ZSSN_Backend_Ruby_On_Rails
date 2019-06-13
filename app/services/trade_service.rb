module TradeService
  class << self
    def trade_items(
      survivor_from, survivor_to,
      resources_offer, resources_request
    )
      enough_resources?(survivor_from, resources_offer)
      enough_resources?(survivor_to, resources_request)
      respect_price_table?(resources_offer, resources_request)

    end

    private

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
