module InventoryService
  class << self
    # resources can receive:
    # array of iventories = [ <Inventory>, <Inventory>, ... ]
    # hash { water: 1, food: 2 }
    def generate_points(resources)
      points = { water: 4, food: 3, medication: 2, ammunition: 1 }
      total_points = 0

      resources.each do |key, v|
        type = key.is_a?(Inventory) ? key.resource_type.to_sym : key.to_sym
        value = key.is_a?(Inventory) ? key.resource_amount : v
        total_points += points.key?(type) ? value * points[type] : 0
      end
      total_points
    end
  end
end
