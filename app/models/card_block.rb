# frozen_string_literal: true

class CardBlock < ApplicationRecord
  has_many :card_sets, -> { order(release_date: :asc) }, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
end
