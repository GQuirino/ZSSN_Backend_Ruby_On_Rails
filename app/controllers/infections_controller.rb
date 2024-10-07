class InfectionsController < ApplicationController
  def update
    @survivor = Survivor.find(params[:id])
    if @survivor.update(flag_as_infected: @survivor.flag_as_infected + 1)
      render json: @survivor, status: :ok
    else
      err = {
        status_code: 400,
        errors: @survivor.errors
      }
      return render json: err, status: err[:status_code]
    end
  end
end
