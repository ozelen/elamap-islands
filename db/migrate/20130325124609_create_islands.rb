class CreateIslands < ActiveRecord::Migration
  def change
    create_table :islands do |t|
      t.string :name
      t.integer :size
      t.integer :genre
      t.integer :grade
      t.integer :begin

      t.timestamps
    end
  end
end
