require 'rails_helper'

RSpec.describe InfectionsController, type: :controller do
  describe 'PUT #new' do
    before do
      @survivor = create(:survivor_with_inventory, flag_as_infected: 0)
    end

    it 'report new infection three times' do
      (1..3).each  do |n|
        put :new, params: { id: @survivor.id }
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body).not_to be_empty
        expect(body.length).to eq 10

        expect(body['id']).to eq @survivor.id
        expect(body['flag_as_infected']).to eq(n)
      end

      # SURVIVOR INFECTED
      put :new, params: { id: @survivor.id }
      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eq 4

      expect(body['status_code']).to eq 400
      expect(body['title']).to eq 'SURVIVOR INFECTED'
      expect(body['details']).to eq 'Survivor is infected'
      expect(body['source']).to eq(
        'survivor' => @survivor.id.to_s
      )
    end
  end
end
