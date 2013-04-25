class CreateHypsometries < ActiveRecord::Migration
  def change
    create_table :hypsometries do |t|
      t.string :name
      t.string :color
      t.integer :position

      t.timestamps
    end
  end
end
