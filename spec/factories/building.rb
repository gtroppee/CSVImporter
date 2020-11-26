FactoryBot.define do
  factory :building do
    reference    { Faker::Internet.uuid }
    address      { Faker::Address.street_address }
    zip_code     { Faker::Address.zip_code }
    city         { Faker::Address.city }
    country      { Faker::Address.country }
    manager_name { Faker::Name.name }
  end
end
