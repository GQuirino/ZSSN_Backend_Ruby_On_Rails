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
    @survivor = Survivor.new(
      name: survivor_params[:name],
      age: survivor_params[:age],
      gender: survivor_params[:gender],
      latitude: survivor_params[:latitude],
      longitude: survivor_params[:longitude],
      flag_as_infected: survivor_params[:flag_as_infected],
      inventories: survivor_params[:inventory]
    )


    render json: {survivor: survivor, inventory: inventory}
    # @survivor.inventories.build()
    # if @survivor.save
    #   render json: @survivor, status: :created, location: @survivor
    # else
    #   render json: @survivor.errors, status: :unprocessable_entity
    # end
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
    params.require(:survivor)
    params.permit(
      :age, :flag_as_infected, :gender, :latitude, :longitude, :name,
      inventory: [ :water, :food, :medication, :ammunition ]
    )
  end
end
