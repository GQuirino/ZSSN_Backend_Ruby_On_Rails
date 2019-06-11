require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe 'Association' do
    it { is_expected.to belong_to(:survivor) }
  end

  describe 'Validade presence of' do
    it { is_expected.to validate_presence_of(:resource_type) }
    it { is_expected.to validate_presence_of(:resource_amount) }
  end
end
