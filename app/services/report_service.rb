module ReportService
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
      water: AverageResourceBySurvivorQuery.avg_resource('water'),
      food: AverageResourceBySurvivorQuery.avg_resource('food'),
      medication: AverageResourceBySurvivorQuery.avg_resource('medication'),
      amunition: AverageResourceBySurvivorQuery.avg_resource('ammunition')
    }
    {
      non_infected: count_survivors,
      percent: percent,
      avg_resource_by_survivor: resource_by_survivor
    }
  end

  module_function :generate_percentage, :generate_report_infected, :generate_report_non_infected
end
