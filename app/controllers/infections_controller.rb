class InfectionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Survivor::SurvivorInfectedError, with: :survivor_infected

  include Errors

  # Error NOT_FOUND
  def not_found
    source = { survivor: params[:id] }
    error = new_error(:NOT_FOUND, 'Survivor not found', source)
    render json: error, status: error[:status]
  end

  # Error SURVIVOR_INFECTED
  def survivor_infected
    source = { survivor: params[:id] }
    error = new_error(:SURVIVOR_INFECTED, 'Survivor already infected', source)
    render json: error, status: error[:status]
  end

  def new
    @survivor = Survivor.find(params[:id])

    @survivor.infected?

    if @survivor.update(flag_as_infected: @survivor.new_infection)
      resp = @survivor
      render json: resp
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end
end
