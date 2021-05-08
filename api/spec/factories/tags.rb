FactoryBot.define do
  factory :tag do
    name { Faker::Name.first_name }
  end
end
