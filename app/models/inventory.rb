class Inventory < ApplicationRecord
  belongs_to :survivor, foreign_key: :survivor_id, optional: true

  validates :resource_type, :resource_amount, presence: true
end
