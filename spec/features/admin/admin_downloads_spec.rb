include Warden::Test::Helpers
Warden.test_mode!
require 'csv'

feature 'Admin - Downloads', :devise do

    before(:all) do
      @user = FactoryGirl.create(:user, :admin)
      # generate some students with applications
      @students = FactoryGirl.create_list(:user, 5, :completed_application)
    end

    context "applications" do

      before(:each) do
        login_as(@user, :scope => :user)
        visit upmin.download_applications_path
        @csv = CSV.parse(page.body, {col_sep: ';'})
      end

      after(:each) do
        Warden.test_reset!
      end

      scenario "should allow an admin to download applications CSV file" do
        expect(@csv.length).to eq Application.count+1
      end

      scenario "dowloaded CSV has all the required columns" do
        expect(@csv.first).to eq ["Timestamp", "Student ID", "Course ID", "Priority"]
      end

      scenario "downloaded CSV has correct data" do
        @application = Application.first
        expect(@csv[1]).to eq [@application.updated_at.to_s, @application.user_id.to_s, @application.course_id.to_s, @application.priority.to_s, nil]
      end

    end

end