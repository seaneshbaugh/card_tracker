# frozen_string_literal: true

class CollectionPresenter < BasePresenter
  def initialize(collection, template)
    super

    @collection = collection
  end

  def quantity_as_integer
    if @collection.present? && @collection.quantity.positive?
      @collection.quantity
    else
      0
    end
  end

  def quantity_as_string
    if @collection.present? && @collection.quantity.positive?
      @collection.quantity.to_s
    else
      '-'
    end
  end
end
