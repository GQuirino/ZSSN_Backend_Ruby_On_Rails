class InfectionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |exception|
    error = Errors.resource_not_found(exception)
    render json: error, status: error[:status_code]
  end

  def update
    @survivor = Survivor.find(params[:id])
    if @survivor.update(flag_as_infected: SurvivorService.increment_infection(@survivor))
      render json: @survivor, status: :ok
    else
      if @survivor.errors.key?('infected')
        err = @survivor.errors.messages[:infected][0]
        return render json: err, status: err[:status_code]
      end

      render json: @survivor.errors.messages, status: :internal_error
    end
  end
end
