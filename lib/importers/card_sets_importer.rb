# frozen_string_literal: true

module Importers
  class CardSetsImporter < Base
    ATTRIBUTE_MAP = {
      'block' => {
        name: :card_block,
        transformation: -> (card_block_name) { CardBlock.find_or_create_by(name: card_block_name) }
      },
      'code' => :code,
      'name' => :name,
      'releaseDate' => :release_date,
      'type' => {
        name: :card_set_type_code,
        transformation: -> (card_set_type_code) { card_set_type_code.upcase }
      }
    }.freeze

    def import!
      card_sets_file_contents = download_file('SetList.json')

      card_sets_data = JSON.parse(card_sets_file_contents)

      card_sets_data.each do |card_set_data|
        card_set = CardSet.find_or_create_by(code: card_set_data['code'])

        card_set_file_contents = download_file("#{card_set.code}.json")

        extended_card_set_data = JSON.parse(card_set_file_contents)

        full_card_set_data = card_set_data.deep_merge(extended_card_set_data)

        card_set.update(attribute_mapper.map_attributes(full_card_set_data))

        puts "CardSet #{card_set.code} (#{card_set.name}) created."
      end
    end

    private

    def attribute_mapper
      @attribute_mapper ||= AttributeMapper.new(ATTRIBUTE_MAP)
    end
  end
end
