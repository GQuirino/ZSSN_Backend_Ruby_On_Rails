class ReportsController < ApplicationController
  def infected
    report = Report.generate_report_infected
    render json: report, status: :ok
  end

  def non_infected
    report = Report.generate_report_non_infected
    render json: report, status: :ok
  end
end
