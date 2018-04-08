FactoryBot.define do
  factory :candidate do
    email { Faker::Internet.email }
  end
end
