module InventoryService
  class << self
    PRICE_TABLE = { water: 4, food: 3, medication: 2, ammunition: 1 }.with_indifferent_access.freeze
    # param resources can receive:
    # array of iventories = [ <Inventory>, <Inventory>, ... ]
    # hash { water: 1, food: 2 }
    def generate_points(resources)
      total_points = 0

      resources.each do |key, value|
        type = key.try(:resource_type) || key
        ammount = key.try(:resource_amount) || value.to_i
        total_points += ammount * PRICE_TABLE.fetch(type, 0)
      end
      total_points
    end
  end
end
