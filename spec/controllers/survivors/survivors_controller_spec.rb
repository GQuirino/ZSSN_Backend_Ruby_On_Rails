require 'rails_helper'

RSpec.describe SurvivorsController, type: :controller do
  describe 'GET #index' do
    it 'returns payload' do
      create(:survivor_with_inventory)
      create(:survivor_with_inventory)

      get :index

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eq(2)
      expect(body[0].length).to eq(11)
    end
  end

  describe 'GET #show' do
    it 'returns payload' do
      @survivor = create(:survivor_with_inventory)

      get :show, params: { id: @survivor.id }

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eq(11)
    end

    it 'returns an error' do
      id = '999999'
      get :show, params: { id: id}
      expect(response).to have_http_status(404)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body['status']).to eq(404)
      expect(body['title']).to eq('NOT FOUND')
      expect(body['source']).to eq(
        'survivor' => id
      )
    end
  end

  describe 'PUT #update' do
    it 'returns payload' do
      @survivor = create(:survivor_with_inventory)

      latitude = '999.666'
      longitude = '888.444'
      put :update, params: {
        id: @survivor.id,
        survivor: {
          latitude: latitude,
          longitude: longitude
        }
      }

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eq 10
      expect(body['latitude']).to eq latitude
      expect(body['longitude']).to eq longitude
    end

    it 'returns error' do
      latitude = '999.666'
      longitude = '888.444'
      id = '999999'

      put :update, params: {
        id: id,
        survivor: {
          latitude: latitude,
          longitude: longitude
        }
      }

      expect(response).to have_http_status(404)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body['status']).to eq(404)
      expect(body['title']).to eq('NOT FOUND')
      expect(body['source']).to eq(
        'survivor' => id
      )
    end
  end
end
