# frozen_string_literal: true

require 'test_helper'

class ColorTest < ActiveSupport::TestCase
  describe 'validations' do
    describe 'color_code' do
      it 'validates presence of color_code' do
        color = Color.new

        color.validate

        color.errors[:color_code].must_include("can't be blank")
      end
    end

    describe 'name' do
      it 'validates presence of name' do
        color = Color.new

        color.validate

        color.errors[:name].must_include("can't be blank")
      end
    end
  end
end
