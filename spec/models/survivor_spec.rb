require 'rails_helper'

RSpec.describe Survivor, type: :model do
  describe 'Association' do
    it { is_expected.to have_many(:inventories) }
  end

  describe 'Validade presence of' do
    it { is_expected.to validate_presence_of(:age) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:flag_as_infected) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
  end
end

# before do
#   Timecop.freeze(Time.local(2019, 10, 1, 10, 5, 0)) # 2019/10/01 13:05:00
# end

# after do
#   Timecop.return
# end
# describe '.generate_points' do
#   # Bang !
#   let(:survivor) { create(:survivor) }
#   let!(:water) { create(:inventory, :water, resource_amount: 1, survivor: survivor) }
#   let!(:food) { create(:inventory, :food, resource_amount: 2, survivor: survivor) }
#   let!(:medication) { create(:inventory, :medication, resource_amount: 3, survivor: survivor) }
#   let!(:ammunition) { create(:inventory, :ammunition, resource_amount: 4, survivor: survivor) }

#   subject(:response) { JSON.parse(Survivor.all_survivors_data) }

#   it 'generates points' do
#     is_expected.to eq 30
#   end
# end
# it 'all_survivors_data' do
# is_expected.to eq [
      #   {
      #     'id' => survivor.id,
      #     'name' => survivor.name,
      #     'gender' => survivor.gender,
      #     'age' => survivor.age,
      #     'flag_as_infected' => survivor.flag_as_infected,
      #     'points' => survivor.points,
      #     'latitude' => survivor.latitude,
      #     'longitude' => survivor.longitude,
      #     'created_at' => '2019-10-01T13:05:00.000Z',
      #     'updated_at' => '2019-10-01T13:05:00.000Z',
      #     'inventories' => [
      #       {
      #         'id' => water.id,
      #         'survivor_id' => survivor.id,
      #         'resource_type' => 'water',
      #         'resource_amount' => water.resource_amount,
      #         'created_at' => '2019-10-01T13:05:00.000Z',
      #         'updated_at' => '2019-10-01T13:05:00.000Z'
      #       }, {
      #         'id' => food.id,
      #         'survivor_id' => survivor.id,
      #         'resource_type' => 'food',
      #         'resource_amount' => food.resource_amount,
      #         'created_at' => '2019-10-01T13:05:00.000Z',
      #         'updated_at' => '2019-10-01T13:05:00.000Z'
      #       }, {
      #         'id' => medication.id,
      #         'survivor_id' => survivor.id,
      #         'resource_type' => 'medication',
      #         'resource_amount' => medication.resource_amount,
      #         'created_at' => '2019-10-01T13:05:00.000Z',
      #         'updated_at' => '2019-10-01T13:05:00.000Z'
      #       }, {
      #         'id' => ammunition.id,
      #         'survivor_id' => survivor.id,
      #         'resource_type' => 'ammunition',
      #         'resource_amount' => ammunition.resource_amount,
      #         'created_at' => '2019-10-01T13:05:00.000Z',
      #         'updated_at' => '2019-10-01T13:05:00.000Z'
      #       }
      #     ]
      #   }
      # ]
# end