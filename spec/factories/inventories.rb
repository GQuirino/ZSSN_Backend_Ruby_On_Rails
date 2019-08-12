FactoryBot.define do
  factory :inventory do
    association :survivor
    resource_amount { FFaker::Random.rand(1..50) }

    trait :water do
      resource_type { 'water' }
    end

    trait :food do
      resource_type { 'food' }
    end

    trait :medication do
      resource_type { 'medication' }
    end

    trait :ammunition do
      resource_type { 'ammunition' }
    end
  end
end
