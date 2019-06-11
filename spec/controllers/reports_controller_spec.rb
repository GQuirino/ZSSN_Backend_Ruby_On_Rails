require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:survivor1) do
    create!(:survivor1)
    create!(:inventory, :water, survivor: survivor1)
    create!(:inventory, :food, survivor: survivor1)
    create!(:inventory, :medication, survivor: survivor1)
    create!(:inventory, :ammunition, survivor: survivor1)
  end

  let(:survivor2) do
    create!(:survivor2)
    create!(:inventory, :water, survivor: survivor2)
    create!(:inventory, :food, survivor: survivor2)
    create!(:inventory, :medication, survivor: survivor2)
    create!(:inventory, :ammunition, survivor: survivor2)
  end
  let(:survivor3) do
    create!(:survivor3, flag_as_infected: 3)
    create!(:inventory, :water, resource_amount: 1, survivor: survivor3)
    create!(:inventory, :food, resource_amount: 2, survivor: survivor3)
    create!(:inventory, :medication, resource_amount: 3, survivor: survivor3)
    create!(:inventory, :ammunition, resource_amount: 4, survivor: survivor3)
  end

  describe 'GET #infected' do
    before { get :infected }
    it 'responds correct payload' do
      p response.body
      body = JSON.parse(response.body)

      expect(body).to have_http_status(:ok)
      expect(body['infected']).to eq 1
      expect(body['percent']).to eq 33.33
      expect(body['points_lost']).to eq 30
    end
  end
end
