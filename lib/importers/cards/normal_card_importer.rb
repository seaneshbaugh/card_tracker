# frozen_string_literal: true

module Importers
  module Cards
    class NormalCardImporter
      ATTRIBUTE_MAP = {
        'artist' => :artist,
        'colors' => {
          name: :colors,
          transformation: -> (color_codes) { Color.where(color_code: color_codes) }
        },
        'convertedManaCost' => :converted_mana_cost,
        'flavorText' => :flavor_text,
        'layout' => {
          name: :layout_code,
          transformation: -> (layout_code) { layout_code.upcase }
        },
        'loyalty' => :loyalty,
        'manaCost' => :mana_cost,
        'multiverseId' => :multiverse_id,
        'number' => :card_number,
        'name' => :name,
        'originalText' => :original_card_text,
        'originalType' => :original_type_text,
        'power' => :power,
        'rarity' => {
          name: :rarity_code,
          transformation: -> (rarity_code) { rarity_code.first.upcase }
        },
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

      attr_reader :card_set, :attributes

      def initialize(card_set, card_data)
        @card_set = card_set
        @attributes = attribute_mapper.map_attributes(card_data)
      end

      def card
        @card ||= Card.find_or_create_by(card_set_id: card_set.id, card_number: attributes[:card_number])
      end

      def import!
        card.update(attributes)

        card
      end

      private

      def attribute_mapper
        @attribute_mapper ||= AttributeMapper.new(ATTRIBUTE_MAP)
      end
    end
  end
end
