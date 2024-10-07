module Trade
  class PriceTable
    PRICE_TABLE = { water: 4, food: 3, medication: 2, ammunition: 1 }.freeze
    # param resources can receive:
    # array of iventories = [ <Inventory>, <Inventory>, ... ]
    # hash { water: 1, food: 2 }
    def self.generate_points(resources)
      total_points = 0

      resources.each do |key, value|
        type = key.try(:resource_type) || key
        ammount = key.try(:resource_amount) || value
        total_points += ammount.to_i * PRICE_TABLE.fetch(type.to_sym, 0)
      end
      total_points
    end
  end
end
