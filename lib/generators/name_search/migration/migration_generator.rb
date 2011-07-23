require 'rails/generators/migration'
require 'rails/generators/active_record'

module NameSearch
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc 'Generates migration for name_search models'

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    def create_migration_file
      migration_template 'migration.rb', 'db/migrate/create_name_search_tables.rb'
    end
  end
end
