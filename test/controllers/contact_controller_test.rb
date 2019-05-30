# frozen_string_literal: true

require 'test_helper'

class ContactControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  describe '#new' do
    it 'should enqueue a new ContactJob with valid parameters' do
      assert_enqueued_jobs 1, only: ContactNotificationJob do
        post contact_url, params: { contact: { name: 'Test Contact', email: 'test@test.com', subject: 'Hello!', body: 'This is a test.' } }
      end

      assert_response :ok
    end

    it 'should not enqueue a new ContactJob with invalid parameters' do
      assert_no_enqueued_jobs do
        post contact_url, params: { contact: { name: '', email: 'test@test.com', subject: 'Hello!', body: 'This is a test.' } }
      end

      assert_response :unprocessable_entity
    end
  end
end
