module TradeService
  def trade(offer, request)
    validation = TradeValidator.validate_trade(offer, request)
    return Errors.trade_invalid(validation.errors) unless validation.errors?

    survivor_offer = offer[:survivor]
    survivor_request = request[:survivor]

    Inventory.transaction do
      {
        from: trade_items(survivor_offer, offer[:resources], request[:resources]),
        to: trade_items(survivor_request, request[:resources], offer[:resources])
      }
    end
  end

  module_function :trade

  def self.trade_items(survivor, items_to_remove, items_to_add)
    exchange_items(items_to_remove, items_to_add, survivor)
    survivor.as_json(methods: [:inventories])
  end

  def self.exchange_items(to_remove, to_add, survivor)
    remove_lambda = ->(resource, val) { resource.resource_amount -= val.to_i }
    add_lambda = ->(resource, val) { resource.resource_amount += val.to_i }

    update_inventory(to_remove, survivor, remove_lambda)
    update_inventory(to_add, survivor, add_lambda)
  end

  def self.update_inventory(items, survivor, func)
    inventories = survivor.inventories
    items.each do |key, val|
      idx = inventories.index { |i| i[:resource_type] == key.to_s }
      resource = inventories[idx]
      func.call(resource, val)
      Inventory.update(
        resource.id,
        resource_amount: resource.resource_amount
      )
    end
  end
end
