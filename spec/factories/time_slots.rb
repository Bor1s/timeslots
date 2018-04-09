FactoryBot.define do
  factory :time_slot do
    trait :for_candidate do
      association :user, factory: :candidate
    end

    trait :for_employee do
      association :employee, factory: :employee
    end
  end
end
