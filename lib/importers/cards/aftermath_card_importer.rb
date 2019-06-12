# frozen_string_literal: true

module Importers
  module Cards
    class AftermathCardImporter < SplitCardImporter
      def initialize
        super

        @layout_code = 'AFTERMATH'
      end
    end
  end
end
