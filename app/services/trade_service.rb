class TradeService
  attr_accessor :errors

  def initialize(offer, request)
    @offer = offer
    @request = request
    @errors = nil
  end

  def trade
    @errors = TradeValidator.new(@offer, @request).errors
    return @errors unless @errors.nil?
    Inventory.transaction do
      {
        from: trade_items(@offer[:survivor], @offer[:resources], @request[:resources]),
        to: trade_items(@request[:survivor], @request[:resources], @offer[:resources])
      }
    end
  end

  private

  def trade_items(survivor, items_to_remove, items_to_add)
    exchange_items(items_to_remove, items_to_add, survivor)
    survivor.as_json(methods: [:inventories])
  end

  def exchange_items(to_remove, to_add, survivor)
    update_inventory(to_remove, survivor) do |amount, val|
      amount - val.to_i
    end

    update_inventory(to_add, survivor) do |amount, val|
      amount + val.to_i
    end
  end

  def update_inventory(items, survivor)
    inventories = survivor.inventories
    items.each do |key, val|
      idx = inventories.index { |i| i[:resource_type] == key.to_s }
      resource = inventories[idx]

      if block_given?
        resource.resource_amount = yield resource.resource_amount, val
      end

      Inventory.update(
        resource.id,
        resource_amount: resource.resource_amount
      )
    end
  end
end
