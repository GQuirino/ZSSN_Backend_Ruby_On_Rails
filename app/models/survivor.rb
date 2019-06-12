class Survivor < ApplicationRecord
  has_many :inventories
  accepts_nested_attributes_for :inventories

  scope :infected, -> { where('flag_as_infected >= ?', 3) }
  scope :non_infected, -> { where('flag_as_infected < ?', 3) }

  validates(
    :age,
    :name,
    :flag_as_infected,
    :gender, :latitude,
    :longitude,
    presence: true
  )

  def new_infection
    self.flag_as_infected += 1
  end

  def infected?
    raise SurvivorInfectedError if self.flag_as_infected >= 3
  end

  class SurvivorInfectedError < StandardError; end
end
