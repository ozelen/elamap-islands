class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :name
      t.date :start
      t.date :end
      t.integer :student_id

      t.timestamps
    end
  end
end
