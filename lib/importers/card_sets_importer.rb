# frozen_string_literal: true

module Importers
  class CardSetsImporter < Base
    ATTRIBUTE_MAP = {
      code: :code,
      name: :name,
      releaseDate: :release_date
    }.freeze

    def import!
      contents = download_file('SetList.json')

      card_sets_data = JSON.parse(contents)

      card_sets_data.each do |card_set_data|
        card_set = CardSet.find_or_create_by(code: card_set_data['code'])

        card_set.update(translate_attributes(card_set_data))
      end
    end

    private

    def translate_attributes(attributes)
      ATTRIBUTE_MAP.each_with_object({}) { |(from, to), translated_attributes| translated_attributes[to] = attributes[from.to_s] }
    end
  end
end
