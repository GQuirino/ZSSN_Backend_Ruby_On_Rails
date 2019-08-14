module TradeValidator
  Result = Struct.new(:errors) do
    def errors?
      errors.blank?
    end
  end

  def validate_trade(offer, request)
    unless respect_price_table?(offer[:resources], request[:resources])
      return Result.new('Trade not respect table of prices')
    end

    unless enough_resources?(offer[:survivor], offer[:resources])
      return Result.new("Survivor #{offer[:survivor][:id]} doesn't have enough resources")
    end

    unless enough_resources?(request[:survivor], request[:resources])
      return Result.new("Survivor #{request[:survivor][:id]} doesn't have enough resources")
    end

    Result.new
  end

  def self.respect_price_table?(resources_offer, resources_request)
    points_offer = InventoryService.generate_points(resources_offer)
    points_request = InventoryService.generate_points(resources_request)
    points_offer == points_request
  end

  def self.enough_resources?(survivor, items_to_trade)
    items_to_trade.each do |key, val|
      resource = survivor.inventories.find do |r|
        r[:resource_type] == key
      end
      return resource['resource_amount'] >= val.to_i
    end
  end

  module_function :validate_trade
end
