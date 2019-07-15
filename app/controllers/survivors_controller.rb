class SurvivorsController < ApplicationController
  include Errors
  before_action :set_survivor, only: %i[show update destroy]

  rescue_from SurvivorInfectedError, with: :render_survivor_infected

  # GET /survivors
  def index
    @survivors = Survivor.all
    render json: @survivors.to_json(methods: [:inventories]), status: :ok
  end

  # GET /survivors/1
  def show
    render json: @survivor.to_json(methods: [:inventories]), status: :ok
  end

  # POST /survivors
  def create
    @survivor = Survivor.new(survivor_params)
    @survivor.initialize_points
    @survivor.initialize_infection

    if @survivor.save
      render json: @survivor.to_json(methods: [:inventories]), status: :created
    else
      raise InternalError, @survivor.errors || 'create method'
    end
  end

  # PATCH/PUT /survivors/1
  def update
    raise SurvivorInfectedError, @survivor.id if @survivor.infected?

    if @survivor.update(survivor_edit_params)
      render json: @survivor, status: :ok
    else
      raise InternalError, @survivor.errors || 'update method'
    end

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_survivor
    @survivor = Survivor.find(params[:id])
  end

  def survivor_params
    params.require(:survivor).permit(
      :age, :gender, :latitude, :longitude, :name,
      inventories_attributes: %i[resource_type resource_amount]
    )
  end

  def survivor_edit_params
    params.require(:survivor).permit(
      :latitude, :longitude
    )
  end
end
