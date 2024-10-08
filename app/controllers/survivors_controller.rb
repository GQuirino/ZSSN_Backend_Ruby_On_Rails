class SurvivorsController < ApplicationController
  before_action :set_survivor, only: %i[show update]

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
    @survivor = SurvivorFactory.new(survivor_params)

    if @survivor.save
      render json: @survivor.to_json(methods: [:inventories]), status: :created
    else
      render json: @survivor.errors.messages, status: :internal_error
    end
  end

  # PATCH/PUT /survivors/1
  def update
    if @survivor.update(survivor_edit_params)
      render json: @survivor, status: :ok
    else
      if @survivor.errors.key?('infected')
        err = @survivor.errors.messages[:infected][0]
        return render json: err, status: err[:status_code]
      end

      render json: @survivor.errors.messages, status: :internal_error
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
    {
      latitude: params.require(:latitude),
      longitude: params.require(:longitude),
      id: params.require(:id)
    }
  end
end
