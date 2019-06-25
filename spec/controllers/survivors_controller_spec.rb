require 'rails_helper'

RSpec.describe SurvivorsController, type: :controller do
  let!(:survivor) { create(:survivor) }
  before do
    create(:survivor)
  end

  describe 'GET #index' do
    it 'returns list of survivors' do
      get :index

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eq(2)
      expect(body[0].length).to eq(11)
    end
  end

  describe 'GET #show' do
    it 'returns one survivor' do
      get :show, params: { id: survivor.id }

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eq(11)
    end

    it 'returns an error' do
      id = '999999'
      get :show, params: { id: id }
      expect(response).to have_http_status(404)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body['status_code']).to eq(404)
      expect(body['title']).to eq('NOT FOUND')
      expect(body['source']).to eq(
        'survivor' => id
      )
    end
  end

  describe 'PUT #update' do
    it 'returns survivor updated' do
      latitude = '999.666'
      longitude = '888.444'
      put :update, params: {
        id: survivor.id,
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

    it 'returns an error' do
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
      expect(body['status_code']).to eq(404)
      expect(body['title']).to eq('NOT FOUND')
      expect(body['source']).to eq(
        'survivor' => id
      )
    end
  end

  describe 'POST #create' do

    def resource_created?(inventory, type)
      inventory.any? do |hash|
        hash['resource_type'] == type[:resource_type] &&
          hash['resource_ammount'] == type[:resource_ammount]
      end
    end

    before do
      Timecop.freeze(Time.local(2019, 10, 1, 10, 5, 0)) # 2019/10/01 13:05:00
    end

    after do
      Timecop.return
    end

    it 'returns survivor created' do
      water = {
        resource_type: 'water',
        resource_amount: 1
      }
      food = {
        resource_type: 'food',
        resource_amount: 2
      }
      medication = {
        resource_type: 'medication',
        resource_amount: 3
      }
      ammunition = {
        resource_type: 'ammunition',
        resource_amount: 4
      }
      params = {
        name: FFaker::Name.name,
        age: FFaker::Random.rand(20..30),
        latitude: FFaker::Geolocation.lat,
        longitude: FFaker::Geolocation.lng,
        gender: FFaker::GenderBR.random,
        inventories_attributes: [
          water,
          food,
          medication,
          ammunition
        ]
      }

      post :create, params: { survivor: params }

      expect(response).to have_http_status(:created)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eq 11
      expect(body['inventories'].length).to eq 4
      expect(body['name']).to eq params[:name]
      expect(body['gender']).to eq params[:gender]
      expect(body['age']).to eq params[:age]
      expect(body['flag_as_infected']).to eq 0
      expect(body['points']).to eq 20
      expect(body['latitude']).to eq params[:latitude].to_s
      expect(body['longitude']).to eq params[:longitude].to_s
      expect(body['created_at']).to eq '2019-10-01T13:05:00.000Z'
      expect(body['updated_at']).to eq '2019-10-01T13:05:00.000Z'
      expect(resource_created?(body['inventories'], water)).to eq(true)
      expect(resource_created?(body['inventories'], food)).to eq(true)
      expect(resource_created?(body['inventories'], medication)).to eq(true)
      expect(resource_created?(body['inventories'], ammunition)).to eq(true)
    end
  end
end
