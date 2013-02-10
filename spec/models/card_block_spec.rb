require 'spec_helper'

describe CardBlock do
  it 'should have a valid factory' do
    card_block = create(:card_block)

    card_block.should be_valid
  end
end
