require 'rails_helper'

RSpec.describe Survivor, type: :model do
  let(:survivor) { build(:survivor) }

  it { is_expected.to have_many(:inventories) }
  it { is_expected.to validate_presence_of(:age) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:gender) }
  it { is_expected.to validate_presence_of(:latitude) }
  it { is_expected.to validate_presence_of(:longitude) }
  it { is_expected.to accept_nested_attributes_for(:inventories) }

  describe '.infected?' do
    it{ expect(survivor.infected?).to be_in([true, false]) }
  end
end
