require 'rails_helper'

RSpec.describe InventoryService do
  let(:survivor) { create(:survivor) }
  before do
    create(:inventory, :water, resource_amount: 1, survivor: survivor)
    create(:inventory, :food, resource_amount: 2, survivor: survivor)
    create(:inventory, :medication, resource_amount: 3, survivor: survivor)
    create(:inventory, :ammunition, resource_amount: 4, survivor: survivor)
  end

  describe '.generate_points' do
    it { expect(InventoryService.generate_points(survivor.inventories.to_a)).to eql 20 }
  end
end
