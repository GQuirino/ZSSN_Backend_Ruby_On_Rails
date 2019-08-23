class Inventory < ApplicationRecord
  belongs_to :survivor

  validates :resource_type, :resource_amount, presence: true

  validates_with SurvivorValidator, on: :update
end
