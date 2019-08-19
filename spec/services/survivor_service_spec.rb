require 'rails_helper'

RSpec.describe SurvivorService do
  let!(:survivor) { build(:survivor, flag_as_infected: 0) }

  describe '.increment_infection' do
    it 'increment value' do
      binding.pry
      expect(SurvivorService.increment_infection(survivor)).to eql 1
      expect(SurvivorService.increment_infection(survivor)).to eql 2
      expect(SurvivorService.increment_infection(survivor)).to eql 3
    end
  end
end
