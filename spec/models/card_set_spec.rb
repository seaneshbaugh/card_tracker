require 'spec_helper'

describe CardSet do
  it 'should have a valid factory' do
    card_set = create(:card_set)

    card_set.should be_valid
  end
end
