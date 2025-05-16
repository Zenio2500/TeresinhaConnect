FactoryBot.define do
  factory :reader do
    association :user
    disponibility { ['Domingo 9h', 'Sábado 19h'] }
    read_types { ['Primeira Leitura', 'Salmo', 'Segunda Leitura', 'Preces da Assembleia'] }
  end
end