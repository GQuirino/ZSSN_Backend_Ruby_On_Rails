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

  def non_infected
    @survivors = Survivor.non_infected
    total = Survivor.count
    percent = ReportService.generate_percentage(@survivors.length, total)
    resource_by_survivor = {
      water: ReportService.avg_resource(@survivors, 'water'),
      food: ReportService.avg_resource(@survivors, 'food'),
      medication: ReportService.avg_resource(@survivors, 'medication'),
      amunition: ReportService.avg_resource(@survivors, 'ammunition')
    }

    render json: {
      non_infected: @survivors.length,
      percent: percent,
      avg_resource_by_survivor: resource_by_survivor
    }, status: 200
  end
end
