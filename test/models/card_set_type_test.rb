# frozen_string_literal: true

require 'test_helper'

class CardSetTypeTest < ActiveSupport::TestCase
  let(:card_set_type) { card_set_types(:core) }

  describe 'associations' do
    it 'has many card_sets' do
      card_set_type.must have_many(:card_sets).dependent(:restrict_with_exception).with_foreign_key(:card_set_type_code).inverse_of(:card_set_type)
    end
  end

  describe 'validations' do
    describe 'name' do
      it 'validates presence of name' do
        card_set_type.must validate_presence_of(:name)
      end

      it 'validates uniqueness of name' do
        card_set_type.must validate_uniqueness_of(:name)
      end
    end
  end
end
