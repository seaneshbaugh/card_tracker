# frozen_string_literal: true

class Layout < ApplicationRecord
  has_many :cards, dependent: :restrict_with_exception, foreign_key: :layout_code, inverse_of: :layout

  validates :layout_code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
