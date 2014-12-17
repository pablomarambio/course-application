# The top of the page shows the dashboard, which displays the following information

include Warden::Test::Helpers
Warden.test_mode!

feature 'Admin - Dashboard', :devise do

    before(:all) do
      @user = FactoryGirl.create(:user, :admin)
    end

    before(:each) do
      login_as(@user, :scope => :user)
    end

    after(:each) do
      Warden.test_reset!
    end

# Number of students with completed applications, that is, students with N applications, where N is the number of courses contained within the student's course batch.
  scenario 'completed applications count' do
  #create users with completed
    test_users = FactoryGirl.create_list(:user,  5, :completed_application)
    #check the numbers
    visit upmin_path
    expect(page).to have_css(".completed-count", text: test_users.count)
  end



# Number of students with incomplete applications, that is, students with more than 1 and less than N applications, where N is the number of courses contained within the student's course batch.
scenario 'incompleted applications count' do
    test_users = FactoryGirl.create_list(:user,  5, :incompleted_application)
    #check the numbers
    visit upmin_path
    expect(page).to have_css(".incompleted-count", text: test_users.count)
end

# Number of "idle students", that is, students that haven't submitted any application
scenario 'idle students count' do
  #create idle
      test_users = FactoryGirl.create_list(:user,  5, :idle)
      #check the numbers
      visit upmin_path
      # count +1 because of user used to log in
      expect(page).to have_css(".idle-count", text: User.idle.count)
end

# The control panel is shown below the dashboard, and it shows a link to each of the
# following URLs: /admin/upload-students,
#/admin/upload-courses,
#/admin/upload-results,
# /admin/download-applications,
#/public/idle-students and
#/public/incomplete-applications
scenario 'control panel links' do
  visit upmin_path
  expect(page).to have_link("Upload students", :href=>"/admin/upload/new/users")
  expect(page).to have_link("Upload courses", :href=>"/admin/upload/new/courses")
  expect(page).to have_link("Upload results", :href=>"/admin/upload/new/results")
  expect(page).to have_link("Download applications", :href=>"/admin/applications/download")
  expect(page).to have_link("Idle students", :href=>"/students/idle")
  expect(page).to have_link("Incomplete applications", :href=>"/applications/incomplete")
end


end