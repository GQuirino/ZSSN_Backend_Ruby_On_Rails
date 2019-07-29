class InfectionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |exception|
    error = Errors.resource_not_found(exception)
    render json: error, status: error[:status_code]
  end

  def update
    @survivor = Survivor.find(params[:id])

    if @survivor.infected?
      error = Errors.survivor_infected(@survivor.id)
      return render json: error, status: error[:status_code]
    end

    if @survivor.update(flag_as_infected: @survivor.increment_infection!)
      render json: @survivor, status: :ok
    else
      render json: @survivor.errors.messages, status: :internal_error
    end
  end
end
