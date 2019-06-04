class Survivor < ApplicationRecord
  has_many :inventories

  scope :get_all_survivors_data, -> {
    @survivors = Survivor.all
    @survivors.to_json(methods: [:inventories])
  }
end
