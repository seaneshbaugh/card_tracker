# frozen_string_literal: true

module ActiveRecord
  module Tasks
    class PostgreSQLDatabaseTasks
      def drop
        establish_master_connection

        connection.select_all "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE datname='#{configuration['database']}' AND state='idle';"

        connection.drop_database configuration['database']
      end
    end
  end
end
