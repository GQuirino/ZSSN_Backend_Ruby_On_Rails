class InfectionsController < ApplicationController
  include Errors

  def new
    @survivor = Survivor.find(params[:id])
    raise SurvivorInfectedError, params[:id] if @survivor.infected?

    if @survivor.update(flag_as_infected: @survivor.increment_infection)
      render json: @survivor
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end
end
