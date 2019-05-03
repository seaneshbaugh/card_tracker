# frozen_string_literal: true

require 'test_helper'

require_relative '../../lib/importers/attribute_mapper'

class AttributeMapperTest < ActiveSupport::TestCase
  describe '#map_attributes' do
    context 'when not preserving nonmapped keys' do
      it 'maps key names' do
        map = {
          from1: :to1,
          from2: :to2,
          from3: :to3
        }

        values = {
          from1: '1',
          from2: '2',
          from3: '3',
          from4: '4'
        }

        attribute_mapper = AttributeMapper.new(map)

        mapped = attribute_mapper.map_attributes(values)

        mapped.keys.must_equal %i[to1 to2 to3]

        mapped[:to1].must_equal '1'
        mapped[:to2].must_equal '2'
        mapped[:to3].must_equal '3'
      end
    end

    context 'when preserving nonmapped keys' do
      it 'maps key names' do
        map = {
          from1: :to1,
          from2: :to2,
          from3: :to3
        }

        values = {
          from1: '1',
          from2: '2',
          from3: '3',
          from4: '4'
        }

        attribute_mapper = AttributeMapper.new(map)

        mapped = attribute_mapper.map_attributes(values, true)

        mapped.keys.must_equal %i[to1 to2 to3 from4]

        mapped[:to1].must_equal '1'
        mapped[:to2].must_equal '2'
        mapped[:to3].must_equal '3'
      end
    end

    context 'when mapping with a value transformation' do
      it 'maps key names and values' do
        map = {
          from1: :to1,
          from2: {
            name: :to2,
            transformation: -> (value) { value * 10 }
          }
        }

        values = {
          from1: '1',
          from2: '2'
        }

        attribute_mapper = AttributeMapper.new(map)

        mapped = attribute_mapper.map_attributes(values)

        mapped.keys.must_equal %i[to1 to2]

        mapped[:to1].must_equal '1'
        mapped[:to2].must_equal '2222222222'
      end
    end
  end
end
