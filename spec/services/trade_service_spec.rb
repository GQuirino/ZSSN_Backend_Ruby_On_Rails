require 'rails_helper'

RSpec.describe TradeService do
  let(:survivor) { create(:survivor, flag_as_infected: 0, points: 30) }
  let!(:water) do
    create(:inventory, :water, resource_amount: 1, survivor: survivor)
  end
  let!(:food) do
    create(:inventory, :food, resource_amount: 2, survivor: survivor)
  end
  let!(:medication) do
    create(:inventory, :medication, resource_amount: 3, survivor: survivor)
  end
  let!(:ammunition) do
    create(:inventory, :ammunition, resource_amount: 4, survivor: survivor)
  end

  it 'return error TradeInvalid' do
    # NOT RESPECT PRICE TABLE
    expect{
      TradeService.trade_items(survivor.id, {'ammunition' => 1 }, { 'water' => 1 })
    }.to raise_error(TradesController::TradeInvalid)

    # SURVIVOR DOESNT HAVE ENOUGH RESOURCES
    expect{
      TradeService.trade_items(survivor.id, { 'ammunition' => 8 }, { 'water' => 2 })
    }.to raise_error(TradesController::TradeInvalid)
  end

  it 'return survivor updated' do
    AMMUNITION = 4
    WATER = 1
    def ammount_resource(iventory, resource)
      idx = iventory.index { |i| i['resource_type'] == resource }
      iventory[idx]['resource_amount']
    end

    ammunition_value_old = ammount_resource(survivor.inventories, 'ammunition')
    water_value_old = ammount_resource(survivor.inventories, 'water')

    survivor_updated = TradeService.trade_items(
      survivor.id,
      { 'ammunition' => AMMUNITION },
      { 'water' => WATER }
    )

    inventories = survivor_updated['inventories']

    ammunition_value_new = ammount_resource(inventories, 'ammunition')
    water_value_new = ammount_resource(inventories, 'water')

    expect(ammunition_value_new).to eq ammunition_value_old - AMMUNITION
    expect(water_value_new).to eq water_value_old + WATER
  end
end
