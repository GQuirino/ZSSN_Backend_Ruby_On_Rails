require 'rails_helper'

RSpec.describe TradesController, type: :controller do
  describe 'PUT #update' do
    let!(:survivor1) { create(:survivor, flag_as_infected: 0) }
    let!(:survivor2) { create(:survivor, flag_as_infected: 0) }
    let!(:survivor3) { create(:survivor, flag_as_infected: 3) }

    before do
      create(:inventory, :water, resource_amount: 1, survivor: survivor1)
      create(:inventory, :food, resource_amount: 2, survivor: survivor1)
      create(:inventory, :medication, resource_amount: 3, survivor: survivor1)
      create(:inventory, :ammunition, resource_amount: 4, survivor: survivor1)

      create(:inventory, :water, resource_amount: 1, survivor: survivor2)
      create(:inventory, :food, resource_amount: 2, survivor: survivor2)
      create(:inventory, :medication, resource_amount: 3, survivor: survivor2)
      create(:inventory, :ammunition, resource_amount: 4, survivor: survivor2)
    end

    it 'returns error not Found' do
      id_from = '999'
      put :update, params: {
        id_survivor_from: id_from,
        id_survivor_to: survivor2.id,
        survivor: {
          inventory_offer: { ammunition: 4 },
          inventory_request: { water: 1 }
        }
      }

      expect(response).to have_http_status(:not_found)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eq 4
      expect(body['details']).to eq 'Survivor not found'
      expect(body['source']['survivor']).to eq id_from
    end

    it 'returns error survivor infected' do
      put :update, params: {
        id_survivor_from: survivor3.id,
        id_survivor_to: survivor2.id,
        survivor: {
          inventory_offer: { ammunition: 4 },
          inventory_request: { water: 1 }
        }
      }

      expect(response).to have_http_status(:bad_request)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eq 4
      expect(body['details']).to eq 'Survivor is infected'
      expect(body['source']['survivor']).to eq survivor3.id
    end

    it 'returns edited survivors inventories' do
      put :update, params: {
        id_survivor_from: survivor1.id,
        id_survivor_to: survivor2.id,
        inventory_offer: { ammunition: 4 },
        inventory_request: { water: 1 }
      }

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eq 2
    end
  end
end
