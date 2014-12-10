class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.integer :user_id
      t.integer :course_id
      t.integer :priority

      t.timestamps
    end
  end
end
