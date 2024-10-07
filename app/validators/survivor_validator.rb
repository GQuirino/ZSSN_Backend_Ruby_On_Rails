class SurvivorValidator < ActiveModel::Validator
  def validate(record)
    if record.flag_as_infected >= Survivor::INFECTION_RATE
      record.errors.add(:infected, record.id)
    end
  end
end
