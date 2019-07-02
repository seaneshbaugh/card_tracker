# frozen_string_literal: true

module Importers
  module Cards
    class AftermathCardImporter < SplitCardImporter
      def initialize(card_set, card_data)
        super

        @layout_code = 'AFTERMATH'
      end
    end
  end
end
