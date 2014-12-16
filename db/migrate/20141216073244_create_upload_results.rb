class CreateUploadResults < ActiveRecord::Migration
  def change
    create_table :upload_results do |t|
      t.string :message
      t.integer :upload_id
      t.string :result_type
      t.integer :row_number
      t.timestamps
    end
  end
end
