require 'rails_helper'

RSpec.describe TradeService do
  let(:survivor_offer) { create(:survivor, flag_as_infected: 0, points: 30) }
  let(:survivor_request) { create(:survivor, flag_as_infected: 0, points: 30) }

  let!(:water_offer) { create(:inventory, :water, resource_amount: 1, survivor: survivor_offer) }
  let!(:food_offer) { create(:inventory, :food, resource_amount: 2, survivor: survivor_offer) }
  let!(:medication_offer) { create(:inventory, :medication, resource_amount: 3, survivor: survivor_offer) }
  let!(:ammunition_offer) { create(:inventory, :ammunition, resource_amount: 4, survivor: survivor_offer) }

  let!(:water_request) { create(:inventory, :water, resource_amount: 1, survivor: survivor_request) }
  let!(:food_request) { create(:inventory, :food, resource_amount: 2, survivor: survivor_request) }
  let!(:medication_request) { create(:inventory, :medication, resource_amount: 3, survivor: survivor_request) }
  let!(:ammunition_request) { create(:inventory, :ammunition, resource_amount: 4, survivor: survivor_request) }

  let(:offer) { { survivor: survivor_offer } }
  let(:request) { { survivor: survivor_request } }

  describe '.trade' do
    subject do
      offer[:resources] = { ammunition: 4 }
      request[:resources] = { water: 1 }
      TradeService.new(offer, request)
    end

    it 'should not have errors' do
      expect(subject.errors.validation_error?).to eql false
    end

    context 'when survivor has resources and trade obey price table' do
      new_offer_ammunition = 0
      new_offer_water = 0
      new_request_ammunition = 0
      new_request_water = 0

      AMMUNITION = 4
      WATER = 1

      before do
        def ammount_resource(survivor, resource)
          inventory = survivor['inventories']
          idx = inventory.index { |i| i[:resource_type] == resource }
          inventory[idx]['resource_amount']
        end

        offer[:resources] = { ammunition: AMMUNITION }
        request[:resources] = { water: WATER }

        trade = TradeService.new(offer, request).trade
        new_offer_ammunition = ammount_resource(trade[:from], 'ammunition')
        new_offer_water = ammount_resource(trade[:from], 'water')
        new_request_ammunition = ammount_resource(trade[:to], 'ammunition')
        new_request_water = ammount_resource(trade[:to], 'water')
      end

      it 'exchange resources' do
        expect(new_offer_ammunition).to eql ammunition_offer.resource_amount - AMMUNITION
        expect(new_offer_water).to eql water_offer.resource_amount + WATER

        expect(new_request_ammunition).to eql ammunition_request.resource_amount + AMMUNITION
        expect(new_request_water).to eql water_request.resource_amount - WATER
      end
    end
  end
end
