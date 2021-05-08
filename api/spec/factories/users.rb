FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Name.first_name }
    password { Faker::Internet.password(min_length: 10, max_length: 20) }
    balance { 100 }
    role { "public" }
  end
end
