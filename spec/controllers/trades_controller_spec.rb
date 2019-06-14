require 'rails_helper'

RSpec.describe TradesController, type: :controller do
  describe 'PUT #update' do
    let!(:survivor1) { create(:survivor_with_inventory, flag_as_infected: 0) }
    let!(:survivor2) { create(:survivor_with_inventory, flag_as_infected: 0) }
    let!(:survivor3) { create(:survivor_with_inventory, flag_as_infected: 3) }

    it 'returns error not Found' do
      id_from = '999'
      put :update, params: {
        idSurvivorFrom: id_from,
        idSurvivorTo: survivor2.id,
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
        idSurvivorFrom: survivor3.id,
        idSurvivorTo: survivor2.id,
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
      expect(body['source']['survivor']).to eq survivor3.id.to_s
    end

    it 'returns edited survivors inventories' do
      AMMUNITION = 4
      WATER = 1
      put :update, params: {
        idSurvivorFrom: survivor1.id,
        idSurvivorTo: survivor2.id,
        inventory_offer: { ammunition: AMMUNITION },
        inventory_request: { water: WATER }
      }

      def ammount_resource(iventory, resource)
        idx = iventory.index { |i| i['resource_type'] == resource }
        iventory[idx]['resource_amount']
      end

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eq 2

      inventories_from = body['from']['inventories']
      inventories_to = body['to']['inventories']

      from_ammunition_value_new = ammount_resource(inventories_from, 'ammunition')
      from_ammunition_value_old = ammount_resource(survivor1.inventories, 'ammunition')

      from_water_value_new = ammount_resource(inventories_from, 'water')
      from_water_value_old = ammount_resource(survivor1.inventories, 'water')

      expect(from_ammunition_value_new).to eq from_ammunition_value_old - AMMUNITION
      expect(from_water_value_new).to eq from_water_value_old + WATER

      to_ammunition_value_new = ammount_resource(inventories_to, 'ammunition')
      to_ammunition_value_old = ammount_resource(survivor2.inventories, 'ammunition')

      to_water_value_new = ammount_resource(inventories_to, 'water')
      to_water_value_old = ammount_resource(survivor2.inventories, 'water')

      expect(to_ammunition_value_new).to eq to_ammunition_value_old + AMMUNITION
      expect(to_water_value_new).to eq to_water_value_old - WATER
    end
  end
end
