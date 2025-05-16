FactoryBot.define do
  factory :grade do
    date { Faker::Date.forward(days: 30) }
    is_solemnity { [true, false].sample }
    liturgical_color { Faker::Color.hex_color }  # Já retorna no formato #RRGGBB
    liturgical_time { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
  end
end