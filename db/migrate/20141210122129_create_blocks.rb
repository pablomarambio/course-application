class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :name
      t.time :from
      t.time :to
      t.integer :course_batch_id

      t.timestamps
    end
  end
end
