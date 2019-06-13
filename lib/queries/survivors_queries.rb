module SurvivorsQueries
  def sum_lost_points
    Survivor.infected.sum(:points)
  end

  def count_infected
    Survivor.infected.count
  end

  def count_non_infected
    Survivor.non_infected.count
  end

  def count_all_survivors
    Survivor.count
  end

  def avg_resource_by_survivor(resource)
    sql = "SELECT AVG(t.resource_amount) FROM (
      #{resources_from_all_non_infected.to_sql}
    ) AS t
    WHERE t.resource_type = '#{resource}'"
    conn = ActiveRecord::Base.connection
    result = conn.select_values sql
    result[0].to_f.round(2)
  end

  # SELECT "t"."resource_amount"  FROM (
  #   SELECT "inventories"."resource_type", "inventories"."resource_amount"
  #     FROM "inventories"
  #     JOIN "survivors" ON "survivors"."id" = "inventories"."survivor_id"
  #   WHERE "survivors"."flag_as_infected" < 3
  #   ) AS "t"
  # WHERE "t"."resource_type" = 'water'

  def resources_from_all_non_infected
    Survivor.select(
      'inventories.resource_type, inventories.resource_amount'
    ).joins(
      :inventories
    ).non_infected
  end
end
