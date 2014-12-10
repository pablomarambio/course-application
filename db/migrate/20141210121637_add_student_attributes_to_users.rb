class AddStudentAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rut, :string
    add_column :users, :course_batch_id, :integer
  end
end
