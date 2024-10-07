require 'rails_helper'

RSpec.describe TradesController, type: :controller do
  describe 'PUT #update' do
    let!(:survivor1) { create(:survivor, flag_as_infected: 0) }
    let!(:survivor2) { create(:survivor, flag_as_infected: 0) }
    let!(:survivor3) { create(:survivor, flag_as_infected: 3) }

    before do
      create(:inventory, :water, resource_amount: 1, survivor: survivor1)
      create(:inventory, :ammunition, resource_amount: 4, survivor: survivor1)

      create(:inventory, :water, resource_amount: 1, survivor: survivor2)
      create(:inventory, :ammunition, resource_amount: 4, survivor: survivor2)

      create(:inventory, :water, resource_amount: 1, survivor: survivor3)
      create(:inventory, :ammunition, resource_amount: 4, survivor: survivor3)
    end

    it 'returns error survivor infected' do
      put :update, params: {
        id_survivor_from: survivor3.id,
        id_survivor_to: survivor2.id,
        inventory_offer: { ammunition: 4 },
        inventory_request: { water: 1 }
      }

      expect(response).to have_http_status(403)

      body = JSON.parse(response.body)

      expect(body).not_to be_empty
      expect(body['validation_error']).to eql ["Survivor #{survivor3.id} is infected"]
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
      expect(body.length).to eql 3
    end
  end
end
