# frozen_string_literal: true

require 'test_helper'

class CardSubTypingTest < ActiveSupport::TestCase
  describe 'associations' do
    describe 'card' do
      it 'should belong to Card' do
        reflection = CardSubTyping.reflect_on_association(:card)

        expect(reflection).wont_be_nil
        expect(reflection.macro).must_equal :belongs_to
        expect(reflection.klass).must_equal Card
      end
    end

    describe 'card_sub_type' do
      it 'should belong to CardSubType' do
        reflection = CardSubTyping.reflect_on_association(:card_sub_type)

        expect(reflection).wont_be_nil
        expect(reflection.macro).must_equal :belongs_to
        expect(reflection.klass).must_equal CardSubType
      end
    end
  end
end
