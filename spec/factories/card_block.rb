FactoryGirl.define do
  factory :card_block do
    sequence :name do |n|
      "Card Block #{n}"
    end

    card_block_type
  end
end
