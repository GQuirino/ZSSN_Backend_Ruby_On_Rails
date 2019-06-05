module InventoryService
  class << self
    def generate_points(resources)
      points = { water: 1, food: 2, medication: 3, ammunition: 4 }
      total_points = 0

      resources.each do |r|
        type = r.resource_type.to_sym
        total_points += points.key?(type) ? r.resource_amount * points[type] : 0
      end
      total_points
    end
  end
end
