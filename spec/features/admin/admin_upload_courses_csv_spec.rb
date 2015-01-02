include Warden::Test::Helpers
Warden.test_mode!

# Allows the admin to manage the courses, that is, to read, create, update and delete
# courses. All CRUD actions are done using a CSV file.
# The
# courses file is a CSV with the following columns:
#  ID:int
#  Name:string  Batch:string  Block:string  From:hour
#  To:hour
# To create, update or delete a course, a CSV is uploaded. To read all the courses, the CSV
# is downloaded. Except when reading, the file does not need to have as many rows as
# courses in the database. When creating, updating and deleting, if the system detects an
# error it will report the number of the row at which it stopped processing, and the cause
# of the error.
# To create, a row must have a Name, Batch and Block. The ID will be assigned by the system (if the record doesn't have errors.) If a Block with that name doesn't exist, it will be created. If a Batch with that name doesn't exist, it will be created. If the block is created, it will be assigned to the batch. The course will be assigned to the block.
# To update, a row must have an ID. The name will be overwritten on the database. If the
# batch or block change, new objects will be created. Batches and blocks doesn't change
# name. If the hours change, they will be updated on the course's block.
# To delete, a row must have an ID and all other columns must be left empty. This deletes only the course, but not the batch and neither the block.

feature 'Admin for Courses - CSV upload', :devise do

    before(:all) do
      @user = FactoryGirl.create(:user, :admin)
    end

    before(:each) do
      login_as(@user, :scope => :user)
    end

    after(:each) do
      Warden.test_reset!
    end

  scenario 'admin can upload CSV file and courses are created' do
    courses_count = Course.count
    visit upmin_path
    click_link "Upload courses"
    attach_file :upload_file, "spec/test_files/courses.csv"
    click_button "Upload"
    #test csv file should create 4 courses and remove 1
    expect(Course.count).to eq courses_count+3
  end

  scenario 'CSV file upload displays results'
  #   visit upmin_path
  #   click_link "Upload students"
  #   attach_file :upload_file, "spec/test_files/students.csv"
  #   click_button "Upload"
  #   expect(current_path).to eq upload_path
  # end

  scenario 'admin can upload CSV file and users are updated'
  # #setup users
  # #upload file
  # #test results (2 users should be updated)

  scenario 'admin can upload CSV file and users are deleted'
  # #setup users
  # #upload file
  # #test results (2 users should be deleted)

  scenario 'CSV errors are detected and the rest of the file is processed'
  # #setup users
  # #upload file
  # #test result output
  # #page should contain information about 3 errors with details


end