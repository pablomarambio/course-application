class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception



  protected

  def after_sign_in_path_for(resource)
      if resource.admin?
        upmin_path
      else
        if resource.course_batch.nil?
          root_path
        else
          batch = resource.course_batch
          block = batch.blocks.first
          apply_path(batch.id, block.id)
        end
      end
  end

end