class InfectionsController < ApplicationController
  include Errors

  before_action :set_survivor, only: %i[show update destroy]

  rescue_from SurvivorInfectedError, with: :render_survivor_infected
  rescue_from ActiveRecord::RecordNotFound, with: :render_resource_not_found

  def update
    if @survivor.update(flag_as_infected: @survivor.increment_infection!)
      render json: @survivor, status: :ok
    else
      render json: @survivor.errors.messages, status: :internal_error
    end
  end

  private

  def set_survivor
    @survivor = Survivor.find(params[:id])
    raise SurvivorInfectedError, @survivor.id if @survivor.infected?
  end
end
