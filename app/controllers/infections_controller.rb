class InfectionsController < ApplicationController
  include Errors
  rescue_from SurvivorInfectedError, with: :raise_survivor_infected

  def new
    @survivor = Survivor.find(params[:id])

    @survivor.update(flag_as_infected: @survivor.increment_infection!)

    render json: @survivor, status: :ok unless @survivor.infected?
  end
end
