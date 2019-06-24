require 'rails_helper'

RSpec.describe Survivor, type: :model do
  let(:survivor) { build(:survivor, flag_as_infected: 0) }
  let(:survivor2) { build(:survivor, flag_as_infected: 3) }

  it { is_expected.to have_many(:inventories) }
  it { is_expected.to validate_presence_of(:age) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:gender) }
  it { is_expected.to validate_presence_of(:latitude) }
  it { is_expected.to validate_presence_of(:longitude) }
  it { is_expected.to accept_nested_attributes_for(:inventories) }

  describe '.infected?' do
    it{ expect(survivor.infected?).to eql(false) }
    it { expect { survivor2.infected? }.to raise_error(SurvivorInfectedError) }
  end
end
