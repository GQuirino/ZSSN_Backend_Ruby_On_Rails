class Survivor < ApplicationRecord
  INFECTION_RATE = 3
  has_many :inventories, dependent: :destroy
  accepts_nested_attributes_for :inventories

  scope :infected, -> { where('flag_as_infected >= ?', INFECTION_RATE) }
  scope :non_infected, -> { where('flag_as_infected < ?', INFECTION_RATE) }

  validates :age,
            :name,
            :gender,
            :latitude,
            :longitude,
            presence: true

  def increment_infection!
    self.flag_as_infected += 1
  end

  def infected?
    self.flag_as_infected >= INFECTION_RATE
  end
end
