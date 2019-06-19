module InventoryService
  class << self
    PRICE_TABLE = { water: 4, food: 3, medication: 2, ammunition: 1 }.freeze
    # param resources can receive:
    # array of iventories = [ <Inventory>, <Inventory>, ... ]
    # hash { water: 1, food: 2 }
    def generate_points(resources)
      total_points = 0

      resources.each do |key, v|
        type = key.is_a?(Inventory) ? key.resource_type.to_sym : key.to_sym
        value = key.is_a?(Inventory) ? key.resource_amount : v.to_i
        total_points += PRICE_TABLE.key?(type) ? value * PRICE_TABLE[type] : 0
      end
      total_points
    end
  end
end
