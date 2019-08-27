module TradeValidator
  Validation = Struct.new(:validation_error) do
    def validation_error?
      !validation_error.empty?
    end
  end

  def validate_trade(offer, request)
    infected_msg = ->(id) { "Survivor #{id} is infected" }
    enough_resources_msg = ->(id) { "Survivor #{id} doesn't have enough resources" }
    messages = []

    if infected?(offer[:survivor])
      messages << error_message(offer[:survivor][:id], infected_msg)
    end

    if infected?(request[:survivor])
      messages << error_message(request[:survivor][:id], infected_msg)
    end

    unless respect_price_table?(offer[:resources], request[:resources])
      messages << error_message('Trade not respect table of prices')
    end

    unless enough_resources?(offer[:survivor], offer[:resources])
      messages << error_message(offer[:survivor][:id], enough_resources_msg)
    end

    unless enough_resources?(request[:survivor], request[:resources])
      messages << error_message(request[:survivor][:id], enough_resources_msg)
    end

    Validation.new(messages)
  end

  private

  def infected?(survivor)
    survivor.flag_as_infected >= Survivor::INFECTION_RATE
  end

  def respect_price_table?(resources_offer, resources_request)
    points_offer = InventoryService.generate_points(resources_offer)
    points_request = InventoryService.generate_points(resources_request)
    points_offer == points_request
  end

  def enough_resources?(survivor, items_to_trade)
    items_to_trade.each do |key, val|
      resource = survivor.inventories.find do |r|
        r[:resource_type] == key.to_s
      end
      return resource['resource_amount'] >= val.to_i
    end
  end

  def error_message(msg, func = nil)
    return func.call(msg) unless func.nil?

    msg
  end
end
