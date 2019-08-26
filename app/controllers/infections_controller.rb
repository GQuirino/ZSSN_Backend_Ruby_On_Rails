class InfectionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |exception|
    error = {
      details: 'Resource not found',
      title: 'NOT FOUND',
      source: exception
    }
    render json: error, status: :not_found
  end

  def update
    @survivor = Survivor.find(params[:id])
    if @survivor.update(flag_as_infected: @survivor.flag_as_infected + 1)
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
