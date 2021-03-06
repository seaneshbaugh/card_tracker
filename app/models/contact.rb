# frozen_string_literal: true

class Contact
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :name
  attr_accessor :email
  attr_accessor :subject
  attr_accessor :body

  validates :name, length: { maximum: 128 }, presence: true
  validates :email, email: { allow_blank: true }, presence: true
  validates :subject, length: { minimum: 4, maximum: 128, allow_blank: true }, presence: true
  validates :body, length: { minimum: 8, maximum: 2048, allow_blank: true }, presence: true

  def sanitize!
    @name = name.strip

    @email = email.downcase.strip

    @subject = Sanitize.clean(subject).gsub(/\n|\r|\t/, '').strip

    @body = Sanitize.clean(body).gsub(/\r|\t/, '').split("\n").reject(&:empty?).join("\n").strip

    self
  end
end
