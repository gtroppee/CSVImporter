FactoryBot.define do
  factory :person do
    reference           { Faker::Internet.uuid }
    firstname           { Faker::Name.first_name }
    lastname            { Faker::Name.last_name }
    home_phone_number   { Faker::PhoneNumber.phone_number }
    mobile_phone_number { Faker::PhoneNumber.cell_phone }
    email               { Faker::Internet.email }
    address             { Faker::Address.street_address }
  end
end
