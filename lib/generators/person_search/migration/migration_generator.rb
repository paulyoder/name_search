require 'rails/generators'
require 'rails/generators/migration'

module PersonSearch
	class MigrationGenerator < Rails::Generators::Base
		include Rails::Generators::Migration

		desc 'Generates migration for person_search models'

		def self.source_root
			@source_root ||= File.join(File.dirname(__FILE__), 'templates')
		end

		def self.next_migration_number(dirname)
			Time.now.utc.strftime('%Y%m%d%H%M%S')
		end

		def create_migration_file
			migration_template 'migration.rb', 'db/migrate/create_person_search_tables.rb'
		end
	end
end
