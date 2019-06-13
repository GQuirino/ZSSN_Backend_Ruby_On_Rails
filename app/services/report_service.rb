module ReportService
  class << self
    include SurvivorsQueries

    def generate_percentage(num, total)
      ((100 * num).to_f / total).round(2)
    end

    def generate_report_infected
      @infected = Survivor.infected
      total = count_all_survivors
      points_lost = sum_lost_points
      percent = ReportService.generate_percentage(@infected.length, total)
      {
        infected: @infected.length,
        percent: percent,
        points_lost: points_lost
      }
    end

    def generate_report_non_infected
      @survivors = Survivor.non_infected
      total = count_all_survivors
      percent = ReportService.generate_percentage(@survivors.length, total)
      resource_by_survivor = {
        water: avg_resource_by_survivor('water'),
        food: avg_resource_by_survivor('food'),
        medication: avg_resource_by_survivor('medication'),
        amunition: avg_resource_by_survivor('ammunition')
      }
      {
        non_infected: @survivors.length,
        percent: percent,
        avg_resource_by_survivor: resource_by_survivor
      }
    end
  end
end
