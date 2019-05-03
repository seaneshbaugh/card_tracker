# frozen_string_literal: true

class AttributeMapper
  attr_accessor :map

  def initialize(hash)
    @map = hash.map do |from, to|
      if to.is_a?(Hash)
        Attribute.new(from, to[:name], to[:transformation])
      else
        Attribute.new(from, to)
      end
    end
  end

  def map_attributes(values, preserve_nonmapped_keys = false)
    result = @map.each_with_object({}) do |attribute, translated_attributes|
      translated_attributes[attribute.to] = attribute.transform(values[attribute.from])
    end

    return result unless preserve_nonmapped_keys

    nonmapped_keys = values.keys - mapped_keys

    nonmapped_keys.each do |key|
      result[key] = values[key]
    end

    result
  end

  private

  def mapped_keys
    @map.map(&:from)
  end

  class Attribute
    attr_accessor :from, :to, :transformation

    def initialize(from, to, transformation = nil)
      @from = from
      @to = to
      @transformation = transformation

      raise ArgumentError, 'to cannot be nil' unless @to
      raise ArgumentError, 'from cannot be nil' unless @from
      raise ArgumentError, 'transformation must respond to `call`' if @transformation && !@transformation.respond_to?(:call)
    end

    def transform(value)
      return value unless transformation

      transformation.call(value)
    end
  end
end
