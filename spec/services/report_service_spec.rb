require 'rails_helper'

RSpec.describe ReportService do
  let(:survivor1) { create(:survivor_with_inventory) }
  let(:survivor2) { create(:survivor_with_inventory) }
  let(:survivor3) { create(:survivor_with_inventory) }

  it 'sum points lost' do
    list_infected = [survivor1, survivor2, survivor3]
    expect(
      ReportService.points_lost(list_infected)
    ).to eql(
      list_infected.reduce(0) { |sum, survivor| sum + survivor.points }
    )
  end

  it 'generate percentage' do
    expect(
      ReportService.generate_percentage(50, 100)
    ).to eql(
      50.00
    )
  end

  it 'get average resource by survivor' do
    list_survivor = [survivor1, survivor2, survivor3]

    expect(
      ReportService.avg_resource(list_survivor, 'water')
    ).to eql(
      20.0
    )

    expect(
      ReportService.avg_resource(list_survivor, 'food')
    ).to eql(
      30.0
    )

    expect(
      ReportService.avg_resource(list_survivor, 'medication')
    ).to eql(
      40.0
    )

    expect(
      ReportService.avg_resource(list_survivor, 'ammunition')
    ).to eql(
      50.0
    )
  end
end
