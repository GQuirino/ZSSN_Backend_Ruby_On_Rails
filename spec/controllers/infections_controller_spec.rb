require 'rails_helper'

RSpec.describe InfectionsController, type: :controller do
  describe 'PUT #new' do
    let(:survivor) { create(:survivor, flag_as_infected: 0) }

    it 'report new infection two times' do
      (1..3).each  do |n|
        put :update, params: { id: survivor.id }
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body).not_to be_empty
        expect(body.length).to eq 10

        expect(body['id']).to eq survivor.id
        expect(body['flag_as_infected']).to eq(n)
      end

      # SURVIVOR INFECTED
      put :update, params: { id: survivor.id }
      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eq 4

      expect(body['status_code']).to eq 400
      expect(body['title']).to eq 'SURVIVOR INFECTED'
      expect(body['details']).to eq 'Survivor is infected'
      expect(body['source']).to eq(
        'survivor' => survivor.id
      )
    end
  end
end
