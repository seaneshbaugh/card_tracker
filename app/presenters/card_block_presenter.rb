# frozen_string_literal: true

class CardBlockPresenter < BasePresenter
  def initialize(card_block, template)
    super

    @card_block = card_block
  end

  def card_block_type_name
    @card_block.card_block_type.name
  end
end
