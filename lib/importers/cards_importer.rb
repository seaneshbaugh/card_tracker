# frozen_string_literal: true

module Importers
  class CardsImporter < Base
    ATTRIBUTE_MAP = {
      'artist' => :artist,
      'colors' => {
        name: :colors,
        transformation: -> (color_codes) { Color.where(color_code: color_codes) }
      },
      'convertedManaCost' => :converted_mana_cost,
      'flavorText' => :flavor_text,
      'layout' => :layout,
      'loyalty' => :loyalty,
      'manaCost' => :mana_cost,
      'multiverseId' => :multiverse_id,
      'number' => :card_number,
      'name' => :name,
      'originalText' => :original_card_text,
      'originalType' => :original_card_type,
      'power' => :power,
      'rarity' => {
        name: :rarity_code,
        transformation: -> (rarity_code) { rarity_code.upcase }
      },
      'subtypes' => {
        name: :card_subtypes,
        # TODO: Fix this! This will silently drop unknown subtypes.
        transformation: -> (card_subtype_names) { CardSubType.where(name: card_subtype_names) }
      },
      'supertypes' => {
        name: :card_supertypes,
        # TODO: Fix this! This will silently drop unknown supertypes.
        transformation: -> (card_supertype_names) { CardSuperType.where(name: card_supertype_names) }
      },
      'text' => :card_text,
      'toughness' => :toughness,
      'type' => :type_text,
      'types' => {
        name: :card_types,
        # TODO: Fix this! This will silently drop unknown types.
        transformation: -> (card_type_names) { CardType.where(name: card_type_names) }
      }
    }.freeze

    attr_reader :card_set

    def initialize(card_set_code, options = {})
      super(options)

      @card_set = CardSet.find_by!(code: card_set_code)
    end

    def import!
      card_set_file_contents = download_file("#{card_set.code}.json")

      card_set_data = JSON.parse(card_set_file_contents)

      card_sets_data['cards'].each do |card_data|
        card = Card.find_or_create_by(card_set_id: card_set.id, name: card_data['name'])

        card.update(attribute_mapper.map_attributes(card_data))
      end
    end

    private

    def attribute_mapper
      @attribute_mapper ||= AttributeMapper.new(ATTRIBUTE_MAP)
    end
  end
end


=begin

    set_codes.each do |set_code|
      cached_file_path = Rails.root.join('tmp', 'set_data', "#{set_code}.json")

      unless File.exist?(cached_file_path)
        agent = Mechanize.new

        response = agent.get("http://mtgjson.com/json/#{set_code}.json")

        if response.code == '200'
          FileUtils.mkdir_p(File.dirname(cached_file_path))

          cached_file = File.new(cached_file_path, 'w')

          cached_file.puts response.body

          cached_file.close
        else
          puts raise "Could not retrieve http://mtgjson.com/json/#{set_code}.json. Got error code #{response.code}."
        end
      end

      imported_cards = JSON.parse(File.read(cached_file_path))['cards']

      card_set = CardSet.where(:code => set_code).includes(:cards).first

      raise "Card set with code #{set_code} not found." unless card_set.present?

      puts "Importing cards for #{card_set.name}(#{card_set.code})."

      cards = card_set.cards

      if imported_cards.length != cards.length
        puts "Warning: #{card_set.name} cards length does not match imported length."
      end

      def create_or_update_card(imported_card, card, card_set)
        colors = (imported_card['colors'] || []).join(';')

        card_supertypes = (imported_card['supertypes'] || []).join(';')

        card_types = (imported_card['types'] || []).join(';')

        card_subtypes = (imported_card['subtypes'] || []).join(';')

        if card.present?
          if card.update_attributes({
                                      :name => imported_card['name'].to_s,
                                      :layout => imported_card['layout'].to_s,
                                      :mana_cost => imported_card['manaCost'].to_s,
                                      :converted_mana_cost => imported_card['cmc'].to_s,
                                      :colors => colors,
                                      :card_type => imported_card['type'].to_s,
                                      :card_supertypes => card_supertypes,
                                      :card_types => card_types,
                                      :card_subtypes => card_subtypes,
                                      :card_text => imported_card['text'].to_s.gsub("\n", '<br>'),
                                      :flavor_text => imported_card['flavor'].to_s.gsub("\n", '<br>'),
                                      :power => imported_card['power'].to_s,
                                      :toughness => imported_card['toughness'].to_s,
                                      :loyalty => imported_card['loyalty'].to_s,
                                      :rarity => imported_card['rarity'].to_s,
                                      :card_number => imported_card['number'].to_s,
                                      :artist => imported_card['artist'].to_s
                                    })
            puts "Updated existing card #{card.id} #{card.name}(#{card.multiverse_id})."
          else
            puts "Failed to update existing card #{card.name}(#{card.multiverse_id}). #{card.errors.full_messages.join('. ')}."
          end
        else
          card = Card.new({
                            :multiverse_id => imported_card['multiverseid'].to_s,
                            :name => imported_card['name'].to_s,
                            :card_set_id => card_set.id,
                            :layout => imported_card['layout'].to_s,
                            :mana_cost => imported_card['manaCost'].to_s,
                            :converted_mana_cost => imported_card['cmc'].to_s,
                            :colors => colors,
                            :card_type => imported_card['type'].to_s,
                            :card_supertypes => card_supertypes,
                            :card_types => card_types,
                            :card_subtypes => card_subtypes,
                            :card_text => imported_card['text'].to_s.gsub("\n", '<br>'),
                            :flavor_text => imported_card['flavor'].to_s.gsub("\n", '<br>'),
                            :power => imported_card['power'].to_s,
                            :toughness => imported_card['toughness'].to_s,
                            :loyalty => imported_card['loyalty'].to_s,
                            :rarity => imported_card['rarity'].to_s,
                            :card_number => imported_card['number'].to_s,
                            :artist => imported_card['artist'].to_s
                          })

          if card.save
            puts "Created new card #{card.name}(#{card.multiverse_id})."
          else
            puts "Failed to create new card #{card.name}(#{card.multiverse_id}). #{card.errors.full_messages.join('. ')}."
          end
        end

        card
      end

      imported_cards.select { |imported_card| %w(normal leveler plane scheme phenomenon).include? imported_card['layout'] }.each do |imported_card|
        card = cards.select { |card| card.multiverse_id == imported_card['multiverseid'].to_s }.first

        create_or_update_card(imported_card, card, card_set)
      end

      imported_cards.select { |imported_card| imported_card['layout'] == 'split' }.group_by { |imported_card| imported_card['multiverseid'] }.each do |_, imported_card_parts|
        card_name = imported_card_parts.first['names'].join(' // ')

        colors = imported_card_parts.inject([]) { |colors, imported_card_part| colors + (imported_card_part['colors'] || []) }.uniq

        card_supertypes = imported_card_parts.inject([]) { |supertypes, imported_card_part| supertypes + (imported_card_part['supertypes'] || []) }.uniq

        card_types = imported_card_parts.inject([]) { |types, imported_card_part| types + (imported_card_part['types'] || []) }.uniq

        card_subtypes = imported_card_parts.inject([]) { |subtypes, imported_card_part| subtypes + (imported_card_part['subtypes'] || []) }.uniq

        card_number = imported_card_parts.first['number'].gsub(/\D/, '')

        card = cards.select { |card| card.name == card_name }.first

        imported_card = {
          'multiverseid' => imported_card_parts.first['multiverseid'],
          'name' => card_name,
          'layout' => 'split',
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
                                        :layout => 'split',
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
                                  :layout => 'split',
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
