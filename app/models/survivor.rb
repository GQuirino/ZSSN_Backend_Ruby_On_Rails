class Survivor < ApplicationRecord
  has_many :inventories
  accepts_nested_attributes_for :inventories

  attr_accessor :points

  def self.all_survivors_data
    @survivors = Survivor.all
    @survivors.to_json(methods: [:inventories])
  end
end
