require 'rails_helper'

RSpec.describe InventoryService do
  # build
  # build_stubbed
  let(:survivor) { create(:survivor) }
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

  it 'generate_points' do
    expect(InventoryService.generate_points(survivor.inventories)).to eq 20
  end
end
