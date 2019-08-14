require 'rails_helper'

RSpec.describe Survivor, type: :model do
  let(:survivor_infected) { build(:survivor, flag_as_infected: 3) }
  let(:survivor) { create(:survivor) }
  let!(:water) { create(:inventory, :water, resource_amount: 1, survivor: survivor) }
  let!(:food) { create(:inventory, :food, resource_amount: 2, survivor: survivor) }
  let!(:medication) { create(:inventory, :medication, resource_amount: 3, survivor: survivor) }
  let!(:ammunition) { create(:inventory, :ammunition, resource_amount: 4, survivor: survivor) }

  it { is_expected.to have_many(:inventories) }
  it { is_expected.to validate_presence_of(:age) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:gender) }
  it { is_expected.to validate_presence_of(:latitude) }
  it { is_expected.to validate_presence_of(:longitude) }
  it { is_expected.to accept_nested_attributes_for(:inventories) }

  describe 'initializers' do
    before do
      survivor.initialize_points
      survivor.initialize_infection
    end

    it { expect(survivor.points).to eql 20 }
    it { expect(survivor.flag_as_infected).to eql 0 }
  end
end
