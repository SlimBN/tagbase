class CreateDenies < ActiveRecord::Migration
  def change
    create_table :denies do |t|
      t.string  :denier_type
      t.integer :denier_id
      t.string  :deniable_type
      t.integer :deniable_id
      t.datetime :created_at
    end

    add_index :denies, ["denier_id", "denier_type"],       :name => "fk_denies"
    add_index :denies, ["deniable_id", "deniable_type"], :name => "fk_deniables"
  end
end
