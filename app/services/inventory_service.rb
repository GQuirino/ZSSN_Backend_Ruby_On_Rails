module InventoryService
  PRICE_TABLE = { water: 4, food: 3, medication: 2, ammunition: 1 }.with_indifferent_access.freeze
  # param resources can receive:
  # array of iventories = [ <Inventory>, <Inventory>, ... ]
  # hash { water: 1, food: 2 }
  def generate_points(resources)
    total_points = 0

    keys_to_sym(resources).each do |key, value|
      type = key.is_a?(Hash) ? key[:resource_type] : key
      amount = key.is_a?(Hash)? key[:resource_amount] : value

      total_points += amount.to_i * PRICE_TABLE.fetch(type, 0)
    end
    total_points
  end

  module_function :generate_points

  def self.inventory_resources_to_hash(inventory)
    inventory.map { |e| JSON.parse(e.to_json).symbolize_keys }
  end

  def self.keys_to_sym(resources)
    if resources.is_a? Array
      return inventory_resources_to_hash(resources) if resources[0].is_a? Inventory

      return resources.map { |e| e.to_h.symbolize_keys }
    end

    resources.to_h.symbolize_keys
  end

  module_function :generate_points
end
