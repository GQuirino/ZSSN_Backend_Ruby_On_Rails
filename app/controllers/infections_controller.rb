class InfectionsController < ApplicationController
  include Errors

  def new
    @survivor = Survivor.find(params[:id])

    @survivor.update(flag_as_infected: @survivor.increment_infection!)

    render json: @survivor, status: :ok unless @survivor.infected?
  end
end
