class SurvivorValidator < ActiveModel::Validator
  def validate(record)
    if record.flag_as_infected >= 3
      err = {
        status_code: 400,
        title: 'SURVIVOR INFECTED',
        details: 'Survivor is infected',
        source: { survivor: record.id }
      }
      record.errors.add(:infected, err)
    end
  end
end
