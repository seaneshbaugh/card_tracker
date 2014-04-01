# These tasks are all throw away tasks meant to fix various issues with the database. They are included because the code
# may be useful someday.
namespace :fix do
  # This task adds card numbers to cards from older sets. While not technically correct, it is much easier to have card
  # numbers for all cards for sorting purposes. The set itself is able to control whether or not the card numbers
  # actually show up. The intended order is meant to approximate the order Wizards of the Coast uses for its card
  # #numbers and is as follows:
  # White cards in alphabetical then Multiverse ID order
  # Blue cards in alphabetical then Multiverse ID order
  # Black cards in alphabetical then Multiverse ID order
  # Red cards in alphabetical then Multiverse ID order
  # Green cards in alphabetical then Multiverse ID order
  # Multi-colored cards in alphabetical then Multiverse ID order
  # Colorless (in the case of these sets, artifacts) cards in alphabetical then Multiverse ID order
  # Non-basic land cards in alphabetical then Multiverse ID order
  # Basic Plains with additional supertypes in alphabetical then Multiverse ID order
  # Basic Islands with additional supertypes in alphabetical then Multiverse ID order
  # Basic Swamps with additional supertypes in alphabetical then Multiverse ID order
  # Basic Mountains with additional supertypes in alphabetical then Multiverse ID order
  # Basic Forests with additional supertypes in alphabetical then Multiverse ID order
  # Basic Plains in Multiverse ID order
  # Basic Islands in Multiverse ID order
  # Basic Swamps in Multiverse ID order
  # Basic Mountains in Multiverse ID order
  # Basic Forests in Multiverse ID order
  desc 'Add card numbers to older sets for sorting purposes.'
  task :old_set_card_numbers => :environment do
    %w(LEA LEB 2ED 3ED 4ED 5ED ARN ATQ LEG DRK FEM HML ICE ALL MIR VIS WTH TMP STH CHR POR PO2).each do |set_code|
      card_set = CardSet.where(:code => set_code).includes(:cards).first

      number = 1

      %w(White Blue Black Red Green).each do |color|
        card_set.cards.select { |card| card.colors == color }.sort_by { |card| [card.name, card.multiverse_id.to_i] }.each do |card|
          card.card_number = number.to_s

          number += 1

          card.save
        end
      end

      card_set.cards.select { |card| card.colors.include?(';') }.sort_by { |card| [card.name, card.multiverse_id.to_i] }.each do |card|
        card.card_number = number.to_s

        number += 1

        card.save
      end

      card_set.cards.select { |card| card.colors == '' && !card.card_types.include?('Land') }.sort_by { |card| [card.name, card.multiverse_id.to_i] }.each do |card|
        card.card_number = number.to_s

        number += 1

        card.save
      end

      card_set.cards.select { |card| card.card_types.include?('Land') && !card.card_supertypes.include?('Basic') }.sort_by { |card| [card.name, card.multiverse_id.to_i] }.each do |card|
        card.card_number = number.to_s

        number += 1

        card.save
      end

      %w(Plains Island Swamp Mountain Forest).each do |land|
        card_set.cards.select { |card| card.card_types.include?('Land') && card.card_supertypes.include?('Basic') && card.card_supertypes != 'Basic' && card.card_subtypes == land }.sort_by { |card| [card.name, card.multiverse_id.to_i] }.each do |card|
          card.card_number = number.to_s

          number += 1

          card.save
        end
      end

      %w(Plains Island Swamp Mountain Forest).each do |land|
        card_set.cards.select { |card| card.card_types == 'Land' && card.card_supertypes == 'Basic' && card.card_subtypes == land }.sort_by { |card| card.multiverse_id.to_i }.each do |card|
          card.card_number = number.to_s

          number += 1

          card.save
        end
      end
    end
  end

  # This task assumes the cards for the Anthologies set are already in the database and have Multiverse IDs equal to the
  # earliest appearance of the artwork on the card and have card numbers based on the order in which they are shown on
  # http://www.wizards.com/magic/tcg/productarticle.aspx?x=mtg_tcg_anthologies_themedeck
  desc 'Fix Anthologies.'
  task :ant => :environment do
    card_set = CardSet.where(:code => 'ANT').first

    raise 'Expected 80 cards.' if card_set.cards.length != 80

    card_set.cards.each do |card|
      first_similar_card = Card.where('`cards`.`multiverse_id` = ? AND `cards`.`card_set_id` != ?', card.multiverse_id, card_set.id).sort { |a, b| a.card_set.release_date <=> b.card_set.release_date }.first

      if first_similar_card.present?
        if card.update_attributes({
                                    :name => first_similar_card.name,
                                    :layout => first_similar_card.layout,
                                    :mana_cost => first_similar_card.mana_cost,
                                    :converted_mana_cost => first_similar_card.converted_mana_cost,
                                    :colors => first_similar_card.colors,
                                    :card_type => first_similar_card.card_type,
                                    :card_supertypes => first_similar_card.card_supertypes,
                                    :card_types => first_similar_card.card_types,
                                    :card_subtypes => first_similar_card.card_subtypes,
                                    :card_text => first_similar_card.card_text,
                                    :flavor_text => first_similar_card.flavor_text,
                                    :power => first_similar_card.power,
                                    :toughness => first_similar_card.toughness,
                                    :loyalty => first_similar_card.loyalty,
                                    :rarity => first_similar_card.rarity,
                                    :artist => first_similar_card.artist
                                  })
          puts "Updated existing card #{card.id} #{card.name}(#{card.multiverse_id})."
        else
          puts "Failed to update existing card #{card.name}(#{card.multiverse_id}). #{card.errors.full_messages.join('. ')}."
        end
      else
        raise "Could not find similar card to #{card.name}(#{card.multiverse_id})."
      end
    end
  end

  # This task assumes the cards for the Deckmasters: Garfield vs. Finkel set are already in the database and have
  # Multiverse IDs equal to the earliest appearance of the artwork on the card and have card numbers based on the order
  # in which they are shown on http://www.wizards.com/magic/tcg/productarticle.aspx?x=mtg_tcg_deckmasters2001_themedeck
  desc 'Fix Deckmasters: Garfield vs. Finkel.'
  task :dkm => :environment do
    card_set = CardSet.where(:code => 'DKM').first

    raise 'Expected 52 cards.' if card_set.cards.length != 52

    card_set.cards.each do |card|
      first_similar_card = Card.where('`cards`.`multiverse_id` = ? AND `cards`.`card_set_id` != ?', card.multiverse_id, card_set.id).sort { |a, b| a.card_set.release_date <=> b.card_set.release_date }.first

      if first_similar_card.present?
        if card.update_attributes({
                                    :name => first_similar_card.name,
                                    :layout => first_similar_card.layout,
                                    :mana_cost => first_similar_card.mana_cost,
                                    :converted_mana_cost => first_similar_card.converted_mana_cost,
                                    :colors => first_similar_card.colors,
                                    :card_type => first_similar_card.card_type,
                                    :card_supertypes => first_similar_card.card_supertypes,
                                    :card_types => first_similar_card.card_types,
                                    :card_subtypes => first_similar_card.card_subtypes,
                                    :card_text => first_similar_card.card_text,
                                    :flavor_text => first_similar_card.flavor_text,
                                    :power => first_similar_card.power,
                                    :toughness => first_similar_card.toughness,
                                    :loyalty => first_similar_card.loyalty,
                                    :rarity => first_similar_card.rarity,
                                    :artist => first_similar_card.artist
                                  })
          puts "Updated existing card #{card.id} #{card.name}(#{card.multiverse_id})."
        else
          puts "Failed to update existing card #{card.name}(#{card.multiverse_id}). #{card.errors.full_messages.join('. ')}."
        end
      else
        raise "Could not find similar card to #{card.name}(#{card.multiverse_id})."
      end
    end
  end
end
