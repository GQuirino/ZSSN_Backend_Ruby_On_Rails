class SurvivorsController < ApplicationController
  before_action :set_survivor, only: [:show, :update, :destroy]

  # GET /survivors
  def index
    render json: Survivor.all_survivors_data
  end

  # GET /survivors/1
  def show
    render json: @survivor
  end

  # POST /survivors
  def create
    @survivor = Survivor.new(survivor_params)

    if @survivor.save
      resp = @survivor.to_json(methods: [:inventories])
      render json: resp, status: :created
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /survivors/1
  def update
    if @survivor.update(survivor_params)
      render json: @survivor
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /survivors/1
  def destroy
    @survivor.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_survivor
    @survivor = Survivor.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def survivor_params
    params.require(:survivor).permit(
      :age, :flag_as_infected, :gender, :latitude, :longitude, :name,
      inventories_attributes: [:resource_type, :resource_amount]
    )
  end
end
