class Report
  class << self
    def generate_percentage(num, total)
      ((100 * num).to_f / total).round(2)
    end

    def generate_report_infected
      count_infected = Survivor.infected.count
      total = Survivor.count
      points_lost = Survivor.infected.sum(:points)
      percent = generate_percentage(count_infected, total)
      {
        infected: count_infected,
        percent: percent,
        points_lost: points_lost
      }
    end

    def generate_report_non_infected
      count_survivors = Survivor.non_infected.count
      total = Survivor.count
      percent = generate_percentage(count_survivors, total)
      resource_by_survivor = {
        water:  Queries::AverageResourceBySurvivor.avg_resource('water'),
        food: Queries::AverageResourceBySurvivor.avg_resource('food'),
        medication: Queries::AverageResourceBySurvivor.avg_resource('medication'),
        amunition: Queries::AverageResourceBySurvivor.avg_resource('ammunition')
      }
      {
        non_infected: count_survivors,
        percent: percent,
        avg_resource_by_survivor: resource_by_survivor
      }
    end
  end
end
