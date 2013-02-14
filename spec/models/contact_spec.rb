require 'spec_helper'

describe Contact do
  it 'should have a valid factory' do
    contact = build(:contact)

    contact.should be_valid
  end
end
