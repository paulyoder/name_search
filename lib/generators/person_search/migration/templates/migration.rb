class CreatePersonSearchTables < ActiveRecord::Migration
  def self.up
    create_table :person_search_names do |t|
      t.string  :text
      t.integer :name_relationship_id
    end
    add_index :person_search_names, :name_relationship_id
     
    create_table :person_search_name_relationships do |t|
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
    drop_table :person_search_related_names
    drop_table :person_search_name_person_joins
  end
end
