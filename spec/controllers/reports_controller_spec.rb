require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  describe 'GET #infected' do
    let(:survivor) { create(:survivor, flag_as_infected: 3, points: 30) }

    let!(:water) { create(:inventory, :water, survivor: survivor) }
    let!(:food) { create(:inventory, :food, survivor: survivor) }
    let!(:medication) { create(:inventory, :medication, survivor: survivor) }
    let!(:ammunition) { create(:inventory, :ammunition, survivor: survivor) }

    before { get :infected }

    it 'returns payload' do
      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eq(3)
    end

    it 'responds correct payload' do
      body = JSON.parse(response.body)

      expect(body['infected']).to eq 1
      expect(body['percent']).to eq 100.0
      expect(body['points_lost']).to eq 30
    end
  end

  describe 'GET #non-infected' do
    let(:survivor) { create(:survivor, flag_as_infected: 0, points: 30) }
    let!(:water) do
      create(:inventory, :water, resource_amount: 1, survivor: survivor)
    end
    let!(:food) do
      create(:inventory, :food, resource_amount: 2, survivor: survivor)
    end
    let!(:medication) do
      create(:inventory, :medication, resource_amount: 3, survivor: survivor)
    end
    let!(:ammunition) do
      create(:inventory, :ammunition, resource_amount: 4, survivor: survivor)
    end

    before { get :non_infected }

    it 'returns payload' do
      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eq(3)
    end

    it 'responds correct payload' do
      body = JSON.parse(response.body)

      expect(body['non_infected']).to eq 1
      expect(body['percent']).to eq 100.0
      expect(body['avg_resource_by_survivor']).to eq(
        'water' => 1.0,
        'food' => 2.0,
        'medication' => 3.0,
        'amunition' => 4.0
      )
    end
  end
end
