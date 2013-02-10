FactoryGirl.define do
  factory :card_block_type do
    sequence :name do |n|
      "Card Block Type #{n}"
    end
  end
end
