class CreatePersonSearchTables < ActiveRecord::Migration
  def self.up
    create_table :person_search_names do |t|
      t.string  :value
      t.integer :nick_name_family_id
    end
    add_index :person_search_names, :value
    add_index :person_search_names, :nick_name_family_id
     
    create_table :person_search_nick_name_families do |t|
    end

    create_table :person_search_name_person_joins do |t|
      t.integer :name_id
      t.integer :person_id
      t.string :person_klass
    end
    add_index :person_search_name_person_joins, :name_id
    add_index :person_search_name_person_joins, [:person_id, :person_klass], :name => 'index_person_search_person_id_person_klass'
  end

  def self.down
    drop_table :person_search_names
    drop_table :person_search_nick_name_families
    drop_table :person_search_name_person_joins
  end
end
