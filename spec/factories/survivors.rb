FactoryBot.define do
  factory :survivor do
    name { FFaker::Name.name }
    age { FFaker::Random.rand(20..30) }
    flag_as_infected { 0 }
    latitude { FFaker::Geolocation.lat }
    longitude { FFaker::Geolocation.lng }
    gender { FFaker::GenderBR.random }
    points { 0 }

    factory :survivor_with_inventory do
      before :create do |survivor|
        create(:inventory, :water, resource_amount: 20, survivor: survivor)
        create(:inventory, :food, resource_amount: 30, survivor: survivor)
        create(:inventory, :medication, resource_amount: 40, survivor: survivor)
        create(:inventory, :ammunition, resource_amount: 50, survivor: survivor)
        survivor.points = InventoryService.generate_points(survivor.inventories)
      end
    end
  end
end
