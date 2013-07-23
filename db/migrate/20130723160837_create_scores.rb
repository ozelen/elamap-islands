class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :value
      t.integer :text_id
      t.integer :student_id
      t.integer :teacher_id

      t.timestamps
    end
  end
end
