FactoryGirl.define do
  factory :card do
    sequence :multiverse_id do |n|
      "#{n}"
    end

    sequence :name do |n|
      "Card #{n}"
    end

    association :card_set

    mana_cost ''

    converted_mana_cost ''

    card_type 'Land'

    sequence :card_text do |n|
      "Card Text #{n}"
    end

    sequence :flavor_text do |n|
      "Flavor Text #{n}"
    end

    power ''

    toughness ''

    loyalty ''

    rarity 'Land'

    sequence :card_number do |n|
      "#{n}"
    end

    sequence :artist do |n|
      "Artist #{n}"
    end
  end
end
