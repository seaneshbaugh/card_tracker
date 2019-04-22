# frozen_string_literal: true

require 'test_helper'

class CardColoringTest < ActiveSupport::TestCase
  describe 'associations' do
    describe 'card' do
      it 'should belong to Card' do
        reflection = CardColoring.reflect_on_association(:card)

        expect(reflection).wont_be_nil
        expect(reflection.macro).must_equal :belongs_to
        expect(reflection.klass).must_equal Card
      end
    end

    describe 'color' do
      it 'should belong to Color' do
        reflection = CardColoring.reflect_on_association(:color)

        expect(reflection).wont_be_nil
        expect(reflection.macro).must_equal :belongs_to
        expect(reflection.klass).must_equal Color
      end
    end
  end
end
