module AverageResourceBySurvivorQuery
  def avg_resource(resource)
    sql = "SELECT AVG(t.resource_amount) FROM (
      #{resources_from_all_non_infected.to_sql}
    ) AS t
    WHERE t.resource_type = '#{resource}'"
    conn = ActiveRecord::Base.connection
    result = conn.select_values sql
    result[0].to_f.round(2)
  end

  private

  def resources_from_all_non_infected
    Inventory.select(:resource_type, :resource_amount)
      .joins(:survivor)
      .merge(Survivor.non_infected)
  end
end
