FactoryGirl.define do
  factory :contact do
    sequence :name do |n|
      "Name #{n}"
    end

    sequence :email do |n|
      "contact#{n}@test.com"
    end

    sequence :subject do |n|
      "Subject #{n}"
    end

    sequence :body do |n|
      "Hello! #{n}"
    end
  end
end
