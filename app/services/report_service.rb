module ReportService
  class << self
    def points_lost(list_infected)
      list_infected.reduce(0) { |sum, survivor| sum + survivor.points }
    end

    def generate_percentage(num, total)
      ((100 * num).to_f / total).round(2)
    end
  end
end
