require 'spec_helper'

describe Card do
  it 'should have a valid factory' do
    card = create(:card)

    card.should be_valid
  end
end
