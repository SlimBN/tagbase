class CreateConfirms < ActiveRecord::Migration
  def change
    create_table :confirms do |t|
      t.string  :confirmer_type
      t.integer :confirmer_id
      t.string  :confirmable_type
      t.integer :confirmable_id
      t.datetime :created_at
    end

    add_index :confirms, ["confirmer_id", "confirmer_type"],       :name => "fk_confirms"
    add_index :confirms, ["confirmable_id", "confirmable_type"], :name => "fk_confirmables"
  end
end
