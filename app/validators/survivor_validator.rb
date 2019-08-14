class SurvivorValidator < ActiveModel::Validator
  def validate(record)
    if record.flag_as_infected >= 3
      record.errors.add(:infected, Errors.survivor_infected(record.id))
    end
  end
end
