class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :classroom
      t.integer :block_id
      t.integer :capacity

      t.timestamps
    end
  end
end
