# frozen_string_literal: true

require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  let(:contact) { Contact.new(name: 'Test Contact', email: 'test@test.com', subject: 'Test', body: 'This is a test.') }

  describe 'validations' do
    describe 'name' do
      it 'validates length of name' do
        contact.must validate_length_of(:name).is_at_most(128)
      end

      it 'validates presence of name' do
        contact.must validate_presence_of(:name)
      end
    end

    describe 'email' do
      # it 'validates email is an email address' do
      # end

      it 'validates presence of email' do
        contact.must validate_presence_of(:email)
      end
    end

    describe 'subject' do
      it 'validates presence of subject' do
        contact.must validate_presence_of(:subject)
      end

      it 'validates length of subject' do
        contact.must validate_length_of(:subject).is_at_least(4).is_at_most(128)
      end
    end

    describe 'body' do
      it 'validates presence of body' do
        contact.must validate_presence_of(:body)
      end

      it 'validates length of body' do
        contact.must validate_length_of(:body).is_at_least(8).is_at_most(2048)
      end
    end
  end

  describe '#sanitize!' do
    it 'removes leading and trailing whitespace from the contact\'s name' do
      contact.name = ' t e s t '

      contact.sanitize!

      contact.name.must_equal 't e s t'
    end

    it 'downcases the contact\'s email' do
      contact.email = 'TEST@tEST.coM'

      contact.sanitize!

      contact.email.must_equal 'test@test.com'
    end

    it 'removes leading and trailing whitespace from the contact\'s email' do
      contact.email = ' test@test.com '

      contact.sanitize!

      contact.email.must_equal 'test@test.com'
    end

    it 'removes HTML from the contact\'s subject' do
      contact.subject = '<p>Hello<span>World</span></span>'

      contact.sanitize!

      contact.subject.must_equal 'HelloWorld'
    end

    it 'removes linefeeds, newlines, and tabs from the contact\'s subject' do
      contact.subject = "Hello\r\t\nWorld"

      contact.sanitize!

      contact.subject.must_equal 'HelloWorld'
    end

    it 'removes HTML from the contact\'s body' do
      contact.body = '<p>Hello<span>World</span></span>'

      contact.sanitize!

      contact.body.must_equal 'HelloWorld'
    end

    it 'removes linefeeds, and tabs from the contact\'s body' do
      contact.body = "Hello\r\t\nWorld"

      contact.sanitize!

      contact.body.must_equal "Hello\nWorld"
    end

    it 'turns multiple newlines in the contact\'s body into a single newline' do
      contact.body = "Hello\n\n\n\n\nWorld\n"

      contact.sanitize!

      contact.body.must_equal "Hello\nWorld"
    end
  end
end
