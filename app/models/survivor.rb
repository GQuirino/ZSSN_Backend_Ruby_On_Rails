class Survivor < ApplicationRecord
  has_many :inventories, dependent: :destroy
  accepts_nested_attributes_for :inventories

  scope :infected, -> { where('flag_as_infected >= ?', 3) }
  scope :non_infected, -> { where('flag_as_infected < ?', 3) }

  before_create :before_create

  validates(
    :age,
    :name,
    :gender, :latitude,
    :longitude,
    presence: true
  )

  def increment_infection
    self.flag_as_infected += 1
  end

  def infected?
    raise SurvivorInfectedError, self.id if self.flag_as_infected >= 3
    false
  end

  private

  def before_create
    self.flag_as_infected = self.flag_as_infected || 0
    self.points = self.points || InventoryService.generate_points(self.inventories)
  end

  class SurvivorInfectedError < StandardError
    attr_accessor :id
    def initialize(id)
      @id = id
    end
  end
end
