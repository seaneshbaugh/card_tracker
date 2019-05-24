# frozen_string_literal: true

module Importers
  module Cards
    class CardImporterFactory
      def self.new(card_set, card_data)
        layout_code = card_data['layout']

        card_importer_class = Kernel.const_get("Importers::Cards::#{layout_code.downcase.camelcase}CardImporter")

        card_importer_class.new(card_set, card_data)
      end
    end
  end
end

require_relative './normal_card_importer'
require_relative './aftermath_card_importer'
require_relative './augment_card_importer'
require_relative './double_faced_token_card_importer'
require_relative './emblem_card_importer'
require_relative './flip_card_importer'
require_relative './host_card_importer'
require_relative './leveler_card_importer'
require_relative './meld_card_importer'
require_relative './planar_card_importer'
require_relative './saga_card_importer'
require_relative './split_card_importer'
require_relative './token_card_importer'
require_relative './transform_card_importer'
require_relative './vanguard_card_importer'
