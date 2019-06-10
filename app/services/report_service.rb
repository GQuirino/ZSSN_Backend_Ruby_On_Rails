module ReportService
  class << self
    def points_lost(list_infected)
      list_infected.reduce(0) { |sum, survivor| sum + survivor.points }
    end

    def generate_percentage(num, total)
      ((100 * num).to_f / total).round(2)
    end

    def avg_resource_by_survivor(list_survivor, item)
      sum = 0
      list_survivor.each do |survivor|
        survivor.inventories.each do |resource|
          if resource.resource_type == item
            sum += resource.resource_amount
          end
        end
      end
      (sum.to_f / list_survivor.length).round(2)
    end
  end
end
