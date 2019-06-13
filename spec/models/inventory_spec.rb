require 'rails_helper'

RSpec.describe Inventory, type: :model do
  it { is_expected.to belong_to(:survivor) }
  it { is_expected.to validate_presence_of(:resource_type) }
  it { is_expected.to validate_presence_of(:resource_amount) }
end
