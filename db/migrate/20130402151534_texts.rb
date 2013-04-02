class Texts < ActiveRecord::Migration
  def up
    add_column :texts, :sequence, :float
  end

  def down
    drop_table :texts
  end
end
