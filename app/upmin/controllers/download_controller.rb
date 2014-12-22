require 'csv'

module Upmin
  class DownloadController < ApplicationController

    def applications
      @applications = Application.all
      send_data @applications.to_csv, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=applications.csv"
    end

    def users
      @users = User.all
      send_data @users.to_csv, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=users.csv"
    end

    def courses
      @courses = Course.all
      send_data @courses.to_csv, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=courses.csv"
    end


  end
end