FactoryBot.define do
  factory :survivor do
    name { FFaker::Name.name }
    age { FFaker::Random.rand(20..30) }
    flag_as_infected { FFaker::Random.rand(1..3) }
    latitude { FFaker::Geolocation.lat }
    longitude { FFaker::Geolocation.lng }
    gender { FFaker::GenderBR.random }
  end
end
