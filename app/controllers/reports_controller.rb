class ReportsController < ApplicationController
  def infected
    @infected = Survivor.infected
    total = Survivor.count
    points_lost = ReportService.points_lost(@infected)
    percent = ReportService.generate_percentage(@infected.length, total)
    render json: {
      infected: @infected.length,
      percent: percent,
      points_lost: points_lost
    }, status: 200
  end

  def nonInfected
  end
end
