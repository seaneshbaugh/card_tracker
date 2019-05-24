# frozen_string_literal: true

module Importers
  class CardsImporter < Base
    attr_reader :card_set

    def initialize(card_set_code, options = {})
      super(options)

      @card_set = CardSet.includes(:cards).find_by!(code: card_set_code)
    end

    def import!
      card_set_file_contents = download_file("#{card_set.code}.json")

      card_set_data = JSON.parse(card_set_file_contents)

      card_set_data['cards'].each do |card_data|
        card_importer = Cards::CardImporterFactory.new(@card_set, card_data)

        card = card_importer.import!

        if card.persisted?
          puts "Card #{card.name} created."
        else
          puts "Failed to save Card #{card.name}: #{card.errors.full_messages.inspect}."
        end
      end
    end
  end
end

=begin
      imported_cards.select { |imported_card| imported_card['layout'] == 'flip' }.group_by { |imported_card| imported_card['multiverseid'] }.each do |_, imported_card_parts|
        card_name = imported_card_parts.first['names'].first

        colors = ((imported_card_parts.first['colors'] || []) + (imported_card_parts.last['colors'] || [])).uniq

        card_supertypes = ((imported_card_parts.first['supertypes'] || []) + (imported_card_parts.last['supertypes'] || [])).uniq

        card_types = ((imported_card_parts.first['types'] || []) + (imported_card_parts.last['types'] || [])).uniq

        card_subtypes = ((imported_card_parts.first['subtypes'] || []) + (imported_card_parts.last['subtypes'] || [])).uniq

        card_number = imported_card_parts.first['number'].gsub(/\D/, '')

        card = cards.select { |card| card.name == card_name }.first

        imported_card = {
          'multiverseid' => imported_card_parts.first['multiverseid'],
          'name' => card_name,
          'layout' => imported_card_parts.first['layout'],
          'manaCost' => '',
          'cmc' => '',
          'colors' => colors,
          'card_type' => '',
          'supertypes' => card_supertypes,
          'types' => card_types,
          'subtypes' => card_subtypes,
          'text' => '',
          'flavor' => '',
          'power' => '',
          'toughness' => '',
          'loyalty' => '',
          'rarity' => imported_card_parts.first['rarity'],
          'number' => card_number,
          'artist' => ''
        }

        card = create_or_update_card(imported_card, card, card_set)

        imported_card_parts.each do |imported_card_part|
          card_part = card.card_parts.select { |card_part| imported_card_part['name'] == card_part.name }.first

          colors = (imported_card_part['colors'] || []).join(';')

          card_supertypes = (imported_card_part['supertypes'] || []).join(';')

          card_types = (imported_card_part['types'] || []).join(';')

          card_subtypes = (imported_card_part['subtypes'] || []).join(';')

          if card_part.present?
            if card_part.update_attributes({
                                             :name => imported_card_part['name'].to_s,
                                             :layout => imported_card_part['layout'].to_s,
                                             :mana_cost => imported_card_part['manaCost'].to_s,
                                             :converted_mana_cost => imported_card_part['cmc'].to_s,
                                             :colors => colors,
                                             :card_type => imported_card_part['type'].to_s,
                                             :card_supertypes => card_supertypes,
                                             :card_types => card_types,
                                             :card_subtypes => card_subtypes,
                                             :card_text => imported_card_part['text'].to_s.gsub("\n", '<br>'),
                                             :flavor_text => imported_card_part['flavor'].to_s.gsub("\n", '<br>'),
                                             :power => imported_card_part['power'].to_s,
                                             :toughness => imported_card_part['toughness'].to_s,
                                             :loyalty => imported_card_part['loyalty'].to_s,
                                             :rarity => imported_card_part['rarity'].to_s,
                                             :card_number => imported_card_part['number'].to_s,
                                             :artist => imported_card_part['artist'].to_s
                                           })
              puts "Updated existing card part #{card_part.id} #{card_part.name}(#{card_part.multiverse_id})."
            else
              puts "Failed to update existing card part #{card_part.name}(#{card_part.multiverse_id}). #{card_part.errors.full_messages.join('. ')}."
            end
          else
            card_part = CardPart.new({
                                       :multiverse_id => imported_card_part['multiverseid'].to_s,
                                       :name => imported_card_part['name'].to_s,
                                       :card_id => card.id,
                                       :layout => imported_card_part['layout'].to_s,
                                       :mana_cost => imported_card_part['manaCost'].to_s,
                                       :converted_mana_cost => imported_card_part['cmc'].to_s,
                                       :colors => colors,
                                       :card_type => imported_card_part['type'].to_s,
                                       :card_supertypes => card_supertypes,
                                       :card_types => card_types,
                                       :card_subtypes => card_subtypes,
                                       :card_text => imported_card_part['text'].to_s.gsub("\n", '<br>'),
                                       :flavor_text => imported_card_part['flavor'].to_s.gsub("\n", '<br>'),
                                       :power => imported_card_part['power'].to_s,
                                       :toughness => imported_card_part['toughness'].to_s,
                                       :loyalty => imported_card_part['loyalty'].to_s,
                                       :rarity => imported_card_part['rarity'].to_s,
                                       :card_number => imported_card_part['number'].to_s,
                                       :artist => imported_card_part['artist'].to_s
                                     })

            if card_part.save
              puts "Created new card part #{card_part.name}(#{card_part.multiverse_id})."
            else
              puts "Failed to create new card part #{card_part.name}(#{card_part.multiverse_id}). #{card_part.errors.full_messages.join('. ')}."
            end
          end
        end
      end

      imported_cards.select { |imported_card| imported_card['layout'] == 'double-faced' }.group_by { |imported_card| imported_card['names'] }.each do |_, imported_card_parts|
        card_name = imported_card_parts.first['names'].first

        colors = ((imported_card_parts.first['colors'] || []) + (imported_card_parts.last['colors'] || [])).uniq

        card_supertypes = ((imported_card_parts.first['supertypes'] || []) + (imported_card_parts.last['supertypes'] || [])).uniq

        card_types = ((imported_card_parts.first['types'] || []) + (imported_card_parts.last['types'] || [])).uniq

        card_subtypes = ((imported_card_parts.first['subtypes'] || []) + (imported_card_parts.last['subtypes'] || [])).uniq

        card_number = imported_card_parts.first['number'].gsub(/\D/, '')

        card = cards.select { |card| card.name == card_name }.first

        imported_card = {
          'multiverseid' => imported_card_parts.first['multiverseid'],
          'name' => card_name,
          'layout' => imported_card_parts.first['layout'],
          'manaCost' => '',
          'cmc' => '',
          'colors' => colors,
          'card_type' => '',
          'supertypes' => card_supertypes,
          'types' => card_types,
          'subtypes' => card_subtypes,
          'text' => '',
          'flavor' => '',
          'power' => '',
          'toughness' => '',
          'loyalty' => '',
          'rarity' => imported_card_parts.first['rarity'],
          'number' => card_number,
          'artist' => ''
        }

        card = create_or_update_card(imported_card, card, card_set)

        imported_card_parts.each do |imported_card_part|
          card_part = card.card_parts.select { |card_part| imported_card_part['name'] == card_part.name }.first

          colors = (imported_card_part['colors'] || []).join(';')

          card_supertypes = (imported_card_part['supertypes'] || []).join(';')

          card_types = (imported_card_part['types'] || []).join(';')

          card_subtypes = (imported_card_part['subtypes'] || []).join(';')

          if card_part.present?
            if card_part.update_attributes({
                                             :name => imported_card_part['name'].to_s,
                                             :layout => imported_card_part['layout'].to_s,
                                             :mana_cost => imported_card_part['manaCost'].to_s,
                                             :converted_mana_cost => imported_card_part['cmc'].to_s,
                                             :colors => colors,
                                             :card_type => imported_card_part['type'].to_s,
                                             :card_supertypes => card_supertypes,
                                             :card_types => card_types,
                                             :card_subtypes => card_subtypes,
                                             :card_text => imported_card_part['text'].to_s.gsub("\n", '<br>'),
                                             :flavor_text => imported_card_part['flavor'].to_s.gsub("\n", '<br>'),
                                             :power => imported_card_part['power'].to_s,
                                             :toughness => imported_card_part['toughness'].to_s,
                                             :loyalty => imported_card_part['loyalty'].to_s,
                                             :rarity => imported_card_part['rarity'].to_s,
                                             :card_number => imported_card_part['number'].to_s,
                                             :artist => imported_card_part['artist'].to_s
                                           })
              puts "Updated existing card part #{card_part.id} #{card_part.name}(#{card_part.multiverse_id})."
            else
              puts "Failed to update existing card part #{card_part.name}(#{card_part.multiverse_id}). #{card_part.errors.full_messages.join('. ')}."
            end
          else
            card_part = CardPart.new({
                                       :multiverse_id => imported_card_part['multiverseid'].to_s,
                                       :name => imported_card_part['name'].to_s,
                                       :card_id => card.id,
                                       :layout => imported_card_part['layout'].to_s,
                                       :mana_cost => imported_card_part['manaCost'].to_s,
                                       :converted_mana_cost => imported_card_part['cmc'].to_s,
                                       :colors => colors,
                                       :card_type => imported_card_part['type'].to_s,
                                       :card_supertypes => card_supertypes,
                                       :card_types => card_types,
                                       :card_subtypes => card_subtypes,
                                       :card_text => imported_card_part['text'].to_s.gsub("\n", '<br>'),
                                       :flavor_text => imported_card_part['flavor'].to_s.gsub("\n", '<br>'),
                                       :power => imported_card_part['power'].to_s,
                                       :toughness => imported_card_part['toughness'].to_s,
                                       :loyalty => imported_card_part['loyalty'].to_s,
                                       :rarity => imported_card_part['rarity'].to_s,
                                       :card_number => imported_card_part['number'].to_s,
                                       :artist => imported_card_part['artist'].to_s
                                     })

            if card_part.save
              puts "Created new card part #{card_part.name}(#{card_part.multiverse_id})."
            else
              puts "Failed to create new card part #{card_part.name}(#{card_part.multiverse_id}). #{card_part.errors.full_messages.join('. ')}."
            end
          end
        end
      end

      imported_cards.select { |imported_card| imported_card['layout'] == 'token' }.each do |imported_card|
        puts "Warning: Ignoring token card #{imported_card['name']}(#{imported_card['multiverseid']})."
      end
    end

=end

require_relative './cards/card_importer_factory'
