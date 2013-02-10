require 'spec_helper'

describe CardBlockType do
  it 'should have a valid factory' do
    card_block_type = create(:card_block_type)

    card_block_type.should be_valid
  end
end
