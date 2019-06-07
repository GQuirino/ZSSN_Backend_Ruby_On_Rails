class Survivor < ApplicationRecord
  has_many :inventories
  accepts_nested_attributes_for :inventories

  scope :infected, -> { where('flag_as_infected > ?', true) }
  scope :non_infected, -> { where('flag_as_infected < ?', false) }

  validates :age, :name, :flag_as_infected, :gender, :latitude, :longitude, presence: true
end
