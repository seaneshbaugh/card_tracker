FactoryGirl.define do
  factory :collection do
    association :user

    association :card

    quantity 0
  end
end
