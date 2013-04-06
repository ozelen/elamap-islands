class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.integer :session_id
      t.string :name
      t.string :letter
      t.timestamps
    end
  end

  def down
    drop_table :units
  end

end
