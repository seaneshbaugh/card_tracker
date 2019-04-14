# frozen_string_literal: true

namespace :db do
  desc 'Truncate the database tables'
  task truncate: :environment do
    ActiveRecord::Base.connection.tables.reject { |table_name| table_name == 'schema_migrations' }.each do |table_name|
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name} RESTART IDENTITY")
    end
  end
end
