# frozen_string_literal: true

class Contact
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :name
  attr_accessor :email
  attr_accessor :subject
  attr_accessor :body

  validates :name, presence: true, length: { maximum: 128 }
  validates :email, presence: true, email: { allow_blank: true }
  validates :subject, presence: true, length: { minimum: 4, maximum: 128, allow_blank: true }
  validates :body, presence: true, length: { minimum: 8, maximum: 2048, allow_blank: true }

  # TODO: Remove this method when Rails 6 is released.
  def as_json(options = nil)
    super({ except: %w[errors validation_context] }.deep_merge(options || {}))
  end

  def sanitize!
    @name = name.strip

    @email = email.downcase.strip

    @subject = Sanitize.clean(subject).gsub(/\n|\r|\t/, '').strip

    @body = Sanitize.clean(body).gsub(/\r|\t/, '').split("\n").reject(&:empty?).join("\n").strip

    self
  end
end
