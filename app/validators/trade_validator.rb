class TradeValidator
  attr_accessor :errors
  def initialize(offer, request)
    infected_msg = ->(id) { "Survivor #{id} is infected" }
    enough_resources_msg = ->(id) { "Survivor #{id} doesn't have enough resources" }
    err_msg = []
    @errors = nil

    if infected?(offer[:survivor])
      err_msg << error_message(offer[:survivor][:id], infected_msg)
    end

    if infected?(request[:survivor])
      err_msg << error_message(request[:survivor][:id], infected_msg)
    end

    unless respect_price_table?(offer[:resources], request[:resources])
      err_msg << error_message('Trade not respect table of prices')
    end

    unless enough_resources?(offer[:survivor], offer[:resources])
      err_msg << error_message(offer[:survivor][:id], enough_resources_msg)
    end

    unless enough_resources?(request[:survivor], request[:resources])
      err_msg << error_message(request[:survivor][:id], enough_resources_msg)
    end

    unless err_msg.empty?
      @errors = {
        status_code: 403,
        details: 'Invalid Trade',
        title: 'INVALID TRADE',
        source: err_msg
      }
    end
  end

  private

  def infected?(survivor)
    survivor.flag_as_infected >= 3
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
