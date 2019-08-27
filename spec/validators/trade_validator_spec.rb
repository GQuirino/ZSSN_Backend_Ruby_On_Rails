require 'rails_helper'

class HelperTestClass
  include TradeValidator
end

RSpec.describe TradeValidator do
  let(:module_test) { HelperTestClass.new }
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

  describe '.validate' do
    context 'when price table is not respected' do
      subject do
        offer[:resources] = { ammunition: 1 }
        request[:resources] = { water: 1 }
        module_test.validate_trade(offer, request)
      end

      it 'return Invalid Trade Error' do
        expected_response = ['Trade not respect table of prices']

        is_expected.to respond_to :validation_error?, :validation_error
        expect(subject.validation_error?).to eql true
        expect(subject.validation_error).to eql expected_response
      end
    end

    context 'When offer survivor doesnt have enough resources' do
      subject do
        offer[:resources] = { ammunition: 6 }
        request[:resources] = { medication: 3 }
        module_test.validate_trade(offer, request)
      end

      it 'return Invalid Trade Error' do
        expected_response = ["Survivor #{offer[:survivor][:id]} doesn't have enough resources"]
        expect(subject.validation_error).to eql expected_response
      end
    end

    context 'When request survivor doesnt have enough resources' do
      subject do
        offer[:resources] = { medication: 3 }
        request[:resources] = { ammunition: 6 }
        module_test.validate_trade(offer, request)
      end

      it 'return Invalid Trade Error' do
        expected_response = ["Survivor #{request[:survivor][:id]} doesn't have enough resources"]
        expect(subject.validation_error).to eql expected_response
      end
    end

    context 'When offer survivor is infected' do
      subject do
        offer[:survivor][:flag_as_infected] = 3
        request[:survivor][:flag_as_infected] = 0

        offer[:resources] = { ammunition: 4 }
        request[:resources] = { water: 1 }

        module_test.validate_trade(offer, request)
      end

      it 'return Invalid Trade Error' do
        expected_response = ["Survivor #{offer[:survivor][:id]} is infected"]
        expect(subject.validation_error).to eql expected_response
      end
    end

    context 'When request survivor is infected' do
      subject do
        offer[:survivor][:flag_as_infected] = 0
        request[:survivor][:flag_as_infected] = 3

        offer[:resources] = { ammunition: 4 }
        request[:resources] = { water: 1 }

        module_test.validate_trade(offer, request)
      end

      it 'return Invalid Trade Error' do
        expected_response = ["Survivor #{request[:survivor][:id]} is infected"]
        expect(subject.validation_error).to eql expected_response
      end
    end

    context 'When has more then one validation error' do
      subject do
        offer[:survivor][:flag_as_infected] = 3
        request[:survivor][:flag_as_infected] = 3

        offer[:resources] = { ammunition: 8 }
        request[:resources] = { water: 3 }

        module_test.validate_trade(offer, request)
      end

      it 'return Invalid Trade Error' do
        expected_response = ["Survivor #{offer[:survivor][:id]} is infected",
                             "Survivor #{request[:survivor][:id]} is infected",
                             'Trade not respect table of prices',
                             "Survivor #{offer[:survivor][:id]} doesn't have enough resources",
                             "Survivor #{request[:survivor][:id]} doesn't have enough resources"]

        expect(subject.validation_error).to match expected_response
      end
    end
  end
end
