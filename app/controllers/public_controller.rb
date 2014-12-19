class PublicController < ApplicationController
  def index
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
end
