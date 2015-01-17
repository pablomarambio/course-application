class PublicController < ApplicationController

  def index
        if user_signed_in?
           unless current_user.course_batch.nil?
            @batch = current_user.course_batch
            @block = @batch.blocks.first
          else
            flash.now[:error] = "No course batch assigned"
          end
        else
          render "devise/sessions/new"
        end
  end

  def idle_students
    @idle_students = User.idle
  end

  def incomplete_applications
    @incomplete_applications_students = User.with_incompleted_applications
  end

  def available_courses
    @course_batches = CourseBatch.all
  end

  def batches
    @course_batches = CourseBatch.all
  end

  def results
    @results = Result.all
  end

end
