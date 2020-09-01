require 'rails_helper'

RSpec.describe InfectionsController, type: :controller do
  describe 'PUT #new' do
    let(:survivor) { create(:survivor, flag_as_infected: 0) }

    it 'report new infection two times' do
      (1..2).each  do |n|
        put :update, params: { id: survivor.id }
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body).not_to be_empty
        expect(body.length).to eql 10

        expect(body['id']).to eql survivor.id
        expect(body['flag_as_infected']).to eql(n)
      end

      # SURVIVOR INFECTED
      put :update, params: { id: survivor.id }
      body = JSON.parse(response.body)
      expect(body).not_to be_empty
      expect(body.length).to eql 4

      expect(body['status_code']).to eql 400
      expect(body['title']).to eql 'SURVIVOR INFECTED'
      expect(body['details']).to eql 'Survivor is infected'
      expect(body['source']).to eql(
        'survivor' => survivor.id
      )
    end
  end
end
