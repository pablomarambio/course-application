class CreateCourseBatches < ActiveRecord::Migration
  def change
    create_table :course_batches do |t|
      t.string :name
      t.boolean :open_status

      t.timestamps
    end
  end
end
