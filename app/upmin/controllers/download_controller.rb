require 'csv'

module Upmin
  class DownloadController < ApplicationController

    def applications
      @applications = Application.all
      send_data @applications.to_csv, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=applications.csv"
    end

    def users
    end

    def courses
    end


  end
end