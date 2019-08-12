require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  describe 'GET #infected' do
    let(:survivor) { create(:survivor, flag_as_infected: 3, points: 20) }
    let!(:water) { create(:inventory, :water, resource_amount: 1, survivor: survivor) }
    let!(:food) { create(:inventory, :food, resource_amount: 2, survivor: survivor) }
    let!(:medication) { create(:inventory, :medication, resource_amount: 3, survivor: survivor) }
    let!(:ammunition) { create(:inventory, :ammunition, resource_amount: 4, survivor: survivor) }

    before { get :infected }

    it 'returns payload' do
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eql(3)
    end

    it 'responds correct payload' do
      body = JSON.parse(response.body)

      expect(body['infected']).to eql 1
      expect(body['percent']).to eql 100.0
      expect(body['points_lost']).to eql survivor.points
    end
  end

  describe 'GET #non-infected' do
    let(:survivor) { create(:survivor, flag_as_infected: 0) }
    let!(:water) { create(:inventory, :water, resource_amount: 20, survivor: survivor) }
    let!(:food) { create(:inventory, :food, resource_amount: 30, survivor: survivor) }
    let!(:medication) { create(:inventory, :medication, resource_amount: 40, survivor: survivor) }
    let!(:ammunition) { create(:inventory, :ammunition, resource_amount: 50, survivor: survivor) }

    before { get :non_infected }

    it 'returns payload' do
      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eql(3)
    end

    it 'responds correct payload' do
      body = JSON.parse(response.body)

      expect(body['non_infected']).to eql 1
      expect(body['percent']).to eql 100.0
      expect(body['avg_resource_by_survivor']).to eql(
        'water' => "#{water.resource_amount}.0",
        'food' => "#{food.resource_amount}.0",
        'medication' => "#{medication.resource_amount}.0",
        'amunition' => "#{ammunition.resource_amount}.0"
      )
    end
  end
end
