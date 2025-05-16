FactoryBot.define do
  factory :pastoral do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    association :coordinator, factory: :user
    association :vice_coordinator, factory: :user
  end
end
