class SurvivorValidator < ActiveModel::Validator
  def validate(record)
    survivor = record.try(:survivor) || record

    if survivor.flag_as_infected >= 3
      survivor.errors.add(:infected, Errors.survivor_infected(survivor.id))
    end
  end
end
