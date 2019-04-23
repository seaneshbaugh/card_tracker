# frozen_string_literal: true

class CardBlockTypePresenter < BasePresenter
  def initialize(card_block_type, template)
    super

    @card_block_type = card_block_type
  end
end
