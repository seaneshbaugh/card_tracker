# frozen_string_literal: true

Rails.autoloaders.main.ignore(Rails.root.join('app', 'serializers'))

require 'contact_serializer'

Rails.application.config.active_job.custom_serializers << ContactSerializer
