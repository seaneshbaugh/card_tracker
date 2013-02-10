FactoryGirl.define do
  factory :card_set do
    sequence :name do |n|
      "Card Set #{n}"
    end

    card_block

    sequence :code do |n|
      "CODE{#n}"
    end

    release_date Date.today

    prerelease_date Date.today - 7.days
  end
end
