# frozen_string_literal: true

namespace :db do
  desc 'Truncate the database tables'
  task truncate: :environment do
    table_names = ActiveRecord::Base.connection.tables.reject { |table_name| table_name == 'schema_migrations' }

    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_names.join(', ')} RESTART IDENTITY")
  end
end
