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

  let(:offer) { { id_survivor: survivor_offer.id } }
  let(:request) { { id_survivor: survivor_request.id } }

  describe '.trade' do
    context 'when price table is not respected' do
      it 'raise TradeInvalidError' do
        offer[:inventory] = { 'ammunition' => 1 }
        request[:inventory] = { 'water' => 1 }
        expect { TradeService.trade(offer, request) }.to raise_error(TradeInvalidError)
      end
    end

    context 'when survivor doesnt have enough resources' do
      it 'raise TradeInvalidError' do
        offer[:inventory] = { 'ammunition' => 8 }
        request[:inventory] = { 'water' => 2 }
        expect { TradeService.trade(offer, request) }.to raise_error(TradeInvalidError)
      end
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

        offer[:inventory] = { 'ammunition' => AMMUNITION }
        request[:inventory] = { 'water' => WATER }

        trade = TradeService.trade(offer, request)

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
