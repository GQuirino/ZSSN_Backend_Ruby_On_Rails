class Survivor < ApplicationRecord
  has_many :inventories

  def self.all_survivors_data
    @survivors = Survivor.all
    @survivors.to_json(methods: [:inventories])
  end
end
