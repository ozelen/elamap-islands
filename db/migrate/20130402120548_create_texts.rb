class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.integer :unit_id
      t.string :name
      t.string :author
      t.integer :lessons
      t.integer :lexiles
      t.float :sequence
      t.float :genre
      t.integer :performance
      t.timestamps
    end
  end
end
