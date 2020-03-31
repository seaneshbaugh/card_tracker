# frozen_string_literal: true

# Taken from https://github.com/gitlabhq/gitlabhq/blob/master/app/validators/devise_email_validator.rb
class EmailValidator < ActiveModel::EachValidator
  DEFAULT_OPTIONS = {
    regexp: Devise.email_regexp,
    not_spam: true
  }.freeze

  SPAM_DOMAINS = [
    'mail.ru',
    'yandex.com'
  ]

  def initialize(options)
    options.reverse_merge!(DEFAULT_OPTIONS)

    raise ArgumentError, "Expected 'regexp' argument of type class Regexp" unless options[:regexp].is_a?(Regexp)

    super(options)
  end

  def validate_each(record, attribute, value)
    return if options[:allow_blank] && value.blank?

    record.errors.add(attribute, options[:message] || :invalid) unless value =~ options[:regexp]

    record.errors.add(attribute, options[:messsge] || :invalid) if options[:not_spam] && is_spam?(value)
  end

  private

  def is_spam?(value)
    SPAM_DOMAINS.any? { |spam_domain| value.ends_with?("@#{spam_domain}") }
  end
end
