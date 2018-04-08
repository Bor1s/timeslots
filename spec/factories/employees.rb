FactoryBot.define do
  factory :employee do
    email { Faker::Internet.email }
  end
end
