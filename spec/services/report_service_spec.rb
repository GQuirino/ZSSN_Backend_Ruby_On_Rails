require 'rails_helper'

RSpec.describe ReportService do
  let(:survivor) { create(:survivor, flag_as_infected: 0) }
  before do
    create(:inventory, :water, resource_amount: 1, survivor: survivor)
    create(:inventory, :food, resource_amount: 2, survivor: survivor)
    create(:inventory, :medication, resource_amount: 3, survivor: survivor)
    create(:inventory, :ammunition, resource_amount: 4, survivor: survivor)
    create(:survivor, flag_as_infected: 3, points: 30)
  end

  describe '.generate_report_non_infected' do
    expected_return = {
      non_infected: 1,
      percent: 50.0,
      avg_resource_by_survivor: {
        water: 1.0,
        food: 2.0,
        medication: 3.0,
        amunition: 4.0
      }
    }
    it { expect(ReportService.generate_report_non_infected).to eql expected_return }
  end

  describe '.generate_report_infected' do
    expected_return = {
      infected: 1,
      percent: 50.0,
      points_lost: 30
    }
    it { expect(ReportService.generate_report_infected).to eql expected_return }
  end

  describe '.generate_percentage' do
    it { expect(ReportService.generate_percentage(50, 100)).to eql(50.00) }
  end
end
