class SurvivorFactory < Survivor
  def initialize(survivor_params)
    inventory = survivor_params[:inventories_attributes].map(&:to_h)

    survivor_params[:flag_as_infected] = 0
    survivor_params[:points] = InventoryService.generate_points(inventory)

    super(survivor_params)
  end
end
