require 'rails_helper'

RSpec.describe ReportService do
  let(:survivor1) { create(:survivor, flag_as_infected: 0) }
  let!(:water) { create(:inventory, :water, resource_amount: 1, survivor: survivor1) }
  let!(:food) { create(:inventory, :food, resource_amount: 2, survivor: survivor1) }
  let!(:medication) { create(:inventory, :medication, resource_amount: 3, survivor: survivor1) }
  let!(:ammunition) { create(:inventory, :ammunition, resource_amount: 4, survivor: survivor1) }
  let!(:survivor2) { create(:survivor, flag_as_infected: 3, points: 30) }

  context 'survivor non-infected' do
    it 'generate report of non-infected' do
      report = ReportService.generate_report_non_infected
      expect(report[:non_infected]).to eql 1
      expect(report[:percent]).to eql 50.0
      expect(report[:avg_resource_by_survivor]).to eql(
        water: 1.0,
        food: 2.0,
        medication: 3.0,
        amunition: 4.0
      )
    end
  end

  context 'survivor infected' do
    it 'generate report of infected survivors' do
      report = ReportService.generate_report_infected
      expect(report[:infected]).to eql 1
      expect(report[:percent]).to eql 50.0
      expect(report[:points_lost]).to eql survivor2.points
    end
  end

  describe '.generate_percentage' do
    it { expect(ReportService.generate_percentage(50, 100)).to eql(50.00) }
  end
end
