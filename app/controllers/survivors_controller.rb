class SurvivorsController < ApplicationController
  before_action :set_survivor, only: %i[show update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  include Errors

  # Error NOT_FOUND
  def not_found
    source = { survivor: params[:id] }
    error = new_error(:NOT_FOUND, 'Survivor not found', source)
    render json: error, status: error[:status]
  end

  # GET /survivors
  def index
    @survivors = Survivor.all
    render json: @survivors.to_json(methods: [:inventories])
  end

  # GET /survivors/1
  def show
    render json: @survivor.to_json(methods: [:inventories])
  end

  # POST /survivors
  def create
    @survivor = Survivor.new(survivor_params)
    @survivor.points = InventoryService.generate_points(@survivor.inventories)
    if @survivor.save
      resp = @survivor.to_json(methods: [:inventories])
      render json: resp, status: :created
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /survivors/1
  def update
    if @survivor.update(survivor_edit_params)
      resp = @survivor
      render json: resp
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_survivor
    @survivor = Survivor.find(params[:id])
  end

  def survivor_params
    params.require(:survivor).permit(
      :age, :flag_as_infected, :gender, :latitude, :longitude, :name,
      inventories_attributes: %i[resource_type resource_amount]
    )
  end

  def survivor_edit_params
    params.require(:survivor).permit(
      :latitude, :longitude
    )
  end
end
