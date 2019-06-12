# frozen_string_literal: true

module Importers
  module Cards
    class SplitCardImporter < NormalCardImporter
      ATTRIBUTE_MAP = {
        'artist' => :artist,
        'colors' => {
          name: :colors,
          transformation: -> (color_codes) { Color.where(color_code: color_codes) }
        },
        'convertedManaCost' => :converted_mana_cost,
        'flavorText' => :flavor_text,
        'loyalty' => :loyalty,
        'manaCost' => :mana_cost,
        'multiverseId' => :multiverse_id,
        'number' => :card_number,
        'name' => :name,
        'originalText' => :original_card_text,
        'originalType' => :original_type_text,
        'power' => :power,
        'side' => :side,
        'subtypes' => {
          name: :card_sub_types,
          # TODO: Fix this! This will silently drop unknown subtypes.
          transformation: -> (card_subtype_names) { CardSubType.where(name: card_subtype_names) }
        },
        'supertypes' => {
          name: :card_super_types,
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

      attr_reader :layout_code
      attr_reader :rarity_code

      def initialize(card_set, card_data)
        @card_set = card_set
        @layout_code = 'SPLIT'
        @rarity_code = card_data['rarity'].first.upcase
        @attributes = attribute_mapper.map_attributes(card_data)
      end

      def import!
        CardPart.transaction do
          this_card_part.update(attributes)
          card.update(card_attributes)
          card.save
          this_card_part.card = card
          this_card_part.save
        end

        card
      end

      private

      def attribute_mapper
        @attribute_mapper ||= AttributeMapper.new(ATTRIBUTE_MAP)
      end

      def card_attributes
        card_attributes_for_one_side if card_parts.length == 1
        card_attributes_for_both_sides
      end

      def card_attributes_for_one_side
        {
          name: this_card_part.side == 'a' ? "#{this_card_part.name} // ???" : "??? // #{this_card_part.name}",
          artist: this_card_part.side == 'a' ? "#{this_card_part.artist} // ???" : "??? // #{this_card_part.artist}",
          type_text: this_card_part.side == 'a' ? "#{this_card_part.type_text} // ???" : "??? // #{this_card_part.type_text}",
          layout_Code: layout_code,
          rarity_code: rarity_code
        }
      end

      def card_attributes_for_both_sides
        {
          name: card_parts.map(&:name).join(' // '),
          artist: card_parts.map(&:artist).join(' // '),
          type_text: card_parts.map(&:type_text).join(' // '),
          layout_code: layout_code,
          rarity_code: rarity_code
        }
      end

      def card_parts
        @card_parts ||= (other_card_parts + [this_card_part]).sort_by(&:side)
      end

      def other_card_parts
        @other_card_parts ||= CardPart.where(card_id: card.id).where.not(name: attributes[:name]).to_a
      end

      def this_card_part
        @this_card_part ||= CardPart.find_or_create_by(card_id: card.id, name: attributes[:name])
      end
    end
  end
end
