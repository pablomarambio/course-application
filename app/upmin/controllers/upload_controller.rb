module Upmin
  class UploadController < ApplicationController

    def new
      @upload = Upload.new
    end

    def create
      @upload = Upload.new(upload_type: params[:upload][:upload_type])
      @upload.file = params[:upload][:file].read.encode!("utf-8", "utf-8", :invalid => :replace)
        if @upload.save
          @upload.process_all_rows
          # flash[:notice] = @upload.results_for_row.inspect
          redirect_to @upload
        else
          flash.now[:alert] = @upload.errors
          render(:new)
        end
    end

    def show
      @upload = Upload.find params[:id]
    end


  end
end