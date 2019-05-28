# frozen_string_literal: true

require 'test_helper'

class EmailValidatorTest < ActiveSupport::TestCase
  class DummyClass
    include ActiveModel::Model
    include ActiveModel::Validations
    attr_accessor :email
    validates :email, email: true
  end

  test 'valid email address' do
    dummy_object = DummyClass.new

    dummy_object.email = 'test@test.com'

    assert dummy_object.valid?
  end

  test 'invalid email address' do
    dummy_object = DummyClass.new

    dummy_object.email = 'test'

    assert_not dummy_object.valid?

    assert dummy_object.errors[:email] == ['is invalid']
  end
end
