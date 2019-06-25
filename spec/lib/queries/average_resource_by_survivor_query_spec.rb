require 'rails_helper'

RSpec.describe AverageResourceBySurvivorQuery do
  let(:survivor1) { create(:survivor, flag_as_infected: 0) }
  let(:survivor2) { create(:survivor, flag_as_infected: 0) }

  before do
    create(:inventory, :water, resource_amount: 2, survivor: survivor1)
    create(:inventory, :food, resource_amount: 2, survivor: survivor1)
    create(:inventory, :medication, resource_amount: 2, survivor: survivor1)
    create(:inventory, :ammunition, resource_amount: 2, survivor: survivor1)

    create(:inventory, :water, resource_amount: 3, survivor: survivor2)
    create(:inventory, :food, resource_amount: 3, survivor: survivor2)
    create(:inventory, :medication, resource_amount: 3, survivor: survivor2)
    create(:inventory, :ammunition, resource_amount: 3, survivor: survivor2)
  end

  subject { Class.new.include(AverageResourceBySurvivorQuery).new }

  describe '.avg_resource' do
    it { expect(subject.avg_resource('water')).to eq 2.50 }
    it { expect(subject.avg_resource('food')).to eq 2.50 }
    it { expect(subject.avg_resource('medication')).to eq 2.50 }
    it { expect(subject.avg_resource('ammunition')).to eq 2.50 }
  end
end
