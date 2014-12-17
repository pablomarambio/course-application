class AddCourseBatchIdToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :course_batch_id, :integer
  end
end
