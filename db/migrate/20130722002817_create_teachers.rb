class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.integer :user_id
      t.integer :school_id

      t.timestamps
    end
  end
end
