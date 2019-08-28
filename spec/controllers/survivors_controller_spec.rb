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
      expect(body.length).to eql(2)
      expect(body[0].length).to eql(11)
    end
  end

  describe 'GET #show' do
    it 'returns one survivor' do
      get :show, params: { id: survivor.id }

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eql(11)
    end
  end

  describe 'PUT #update' do
    it 'returns survivor updated' do
      latitude = '999.666'
      longitude = '888.444'
      put :update, params: {
        id: survivor.id,
        latitude: latitude,
        longitude: longitude
      }

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eql 10
      expect(body['latitude']).to eql latitude
      expect(body['longitude']).to eql longitude
    end
  end

  describe 'POST #create' do
    let(:new_time) { Time.local(2019, 10, 1, 10, 5, 0) } # 2019/10/01 10:05:00

    def resource_created?(inventory, type)
      inventory.any? do |hash|
        hash['resource_type'] == type[:resource_type] &&
          hash['resource_ammount'] == type[:resource_ammount]
      end
    end

    before do
      Timecop.freeze(new_time)
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

      expected_body = {
        'name' => params[:name],
        'gender' => params[:gender],
        'age' => params[:age],
        'flag_as_infected' => 0,
        'points' => 20,
        'latitude' => params[:latitude].to_s,
        'longitude' => params[:longitude].to_s,
        'created_at' => '2019-10-01T13:05:00.000Z',
        'updated_at' => '2019-10-01T13:05:00.000Z'
      }

      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eql 11
      expect(body.except('inventories', 'id')).to eql expected_body
      expect(resource_created?(body['inventories'], water)).to eql(true)
      expect(resource_created?(body['inventories'], food)).to eql(true)
      expect(resource_created?(body['inventories'], medication)).to eql(true)
      expect(resource_created?(body['inventories'], ammunition)).to eql(true)
    end
  end
end
