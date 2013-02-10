require 'spec_helper'

describe Collection do
  it 'should have a valid factory' do
    collection = create(:collection)

    collection.should be_valid
  end
end
