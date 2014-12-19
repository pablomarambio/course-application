class BatchesController < ApplicationController
  def toggle
    @course_batch = CourseBatch.find(params[:id])
    @course_batch.open_status = !@course_batch.open_status
    @course_batch.save
    redirect_to batches_path, notice: "Batch status changed."
  end
end
