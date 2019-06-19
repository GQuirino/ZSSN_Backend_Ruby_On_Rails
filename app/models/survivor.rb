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
    is_infected = self.flag_as_infected >= 3
    raise Errors::SurvivorInfectedError, self.id if is_infected

    is_infected
  end

  private

  def before_create
    self.flag_as_infected = self.flag_as_infected || 0
    self.points = self.points || InventoryService.generate_points(self.inventories)
  end
end
