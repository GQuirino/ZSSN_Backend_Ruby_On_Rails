require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:survivor) { create(:survivor, flag_as_infected: 3, points: 30) }
  let!(:water) { create(:inventory, survivor: survivor) }
  let!(:food) { create(:inventory, survivor: survivor) }
  let!(:medication) { create(:inventory, survivor: survivor) }
  let!(:ammunition) { create(:inventory, survivor: survivor) }

  describe 'GET #infected' do
    before { get :infected }

    it 'returns payload' do
      p survivor.points
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
end
