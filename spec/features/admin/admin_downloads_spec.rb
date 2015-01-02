include Warden::Test::Helpers
Warden.test_mode!
require 'csv'

feature 'Admin - Downloads', :devise do

    before(:all) do
      User.destroy_all
      Course.destroy_all
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

    context "users" do

      before(:each) do
        login_as(@user, :scope => :user)
        visit upmin.download_users_path
        @csv = CSV.parse(page.body, {col_sep: ';'})
      end

      after(:each) do
        Warden.test_reset!
      end

      scenario "should allow an admin to download users CSV file" do
        expect(@csv.length).to eq User.count+1
      end

      scenario "dowloaded CSV has all the required columns" do
        expect(@csv.first).to eq ["id","Email","Name","RUT","Password","Course_Batch"]
      end

      scenario "downloaded CSV has correct data" do
        @user = User.first
        expect(@csv[1]).to eq [@user.id.to_s, @user.email.to_s, @user.name.to_s, @user.rut.to_s, nil, @user.course_batch_id ,nil]
      end

      scenario 'downloaded CSV has id column (not ID)' do
        #this fixes problems with Excel 2010
        expect(@csv[0][0]).to eq 'id'

      end

    end

    context "courses" do

      before(:each) do
        login_as(@user, :scope => :user)
        visit upmin.download_courses_path
        @csv = CSV.parse(page.body, {col_sep: ';'})
      end

      after(:each) do
        Warden.test_reset!
      end

      scenario "should allow an admin to download courses CSV file" do
        expect(@csv.length).to eq Course.count+1
      end

      scenario "dowloaded CSV has all the required columns" do
        expect(@csv.first).to eq ["id","Name","Batch","Block","From","To","Classroom","Capacity"]
      end

      scenario "downloaded CSV has correct data" do
        @course = Course.first
        expect(@csv[1]).to eq [@course.id.to_s, @course.name.to_s, @course.course_batch_id.to_s, @course.block_id.to_s, @course.block.try(:from).to_s, @course.block.try(:to).to_s,  @course.classroom.to_s , @course.capacity.to_s,"\n"]
      end

      scenario 'downloaded CSV has id column (not ID)' do
        #this fixes problems with Excel 2010
        expect(@csv[0][0]).to eq 'id'

      end

    end



end