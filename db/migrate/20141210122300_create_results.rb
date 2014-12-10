class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :student_id
      t.integer :course_id
      t.integer :block_id

      t.timestamps
    end
  end
end
