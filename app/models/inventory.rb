class Inventory < ApplicationRecord
  belongs_to :survivor, foreign_key: :survivor_id
end
