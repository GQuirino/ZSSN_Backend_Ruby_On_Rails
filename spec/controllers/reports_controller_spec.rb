require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  describe 'GET #infected' do
    let!(:survivor) { create(:survivor_with_inventory, flag_as_infected: 3) }

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
      expect(body['points_lost']).to eq survivor.points
    end
  end

  describe 'GET #non-infected' do
    let!(:survivor) { create(:survivor_with_inventory, flag_as_infected: 0) }

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
        'water' => 20.0,
        'food' => 30.0,
        'medication' => 40.0,
        'amunition' => 50.0
      )
    end
  end
end
