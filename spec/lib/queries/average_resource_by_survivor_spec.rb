require 'rails_helper'

RSpec.describe Queries::AverageResourceBySurvivor do
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

  describe '.avg_resource' do
    it { expect(Queries::AverageResourceBySurvivor.avg_resource('water')).to eql 2.50 }
    it { expect(Queries::AverageResourceBySurvivor.avg_resource('food')).to eql 2.50 }
    it { expect(Queries::AverageResourceBySurvivor.avg_resource('medication')).to eql 2.50 }
    it { expect(Queries::AverageResourceBySurvivor.avg_resource('ammunition')).to eql 2.50 }
  end
end
