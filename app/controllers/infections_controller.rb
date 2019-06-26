class InfectionsController < ApplicationController
  include Errors
  rescue_from SurvivorInfectedError, with: :raise_survivor_infected

  def update
    @survivor = Survivor.find(params[:id])

    raise SurvivorInfectedError, @survivor.id if @survivor.infected?

    if @survivor.update(flag_as_infected: @survivor.increment_infection!)
      render json: @survivor, status: :ok
    else
      raise InternalError, @survivor.errors || 'update method'
    end
  end
end
