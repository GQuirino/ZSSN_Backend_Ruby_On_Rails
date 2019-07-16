class InfectionsController < ApplicationController
  include Errors
  rescue_from SurvivorInfectedError, with: :render_survivor_infected
  rescue_from ActiveRecord::RecordNotFound, with: :render_resource_not_found

  def update
    @survivor = Survivor.find(params[:id])

    raise SurvivorInfectedError, @survivor.id if @survivor.infected?

    if @survivor.update(flag_as_infected: @survivor.increment_infection!)
      render json: @survivor, status: :ok
    else
      render json: @survivor.errors.messages, status: :internal_error
    end
  end
end
