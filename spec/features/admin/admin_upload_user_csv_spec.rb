include Warden::Test::Helpers
Warden.test_mode!


# Allows the admin to manage the students, that is, to read, create, update and delete students. All CRUD actions are done using a CSV file.
# The students file is a CSV with the following columns:
#  ID:int
#  Name:string
#  RUT:int (stored without the DV)
#  Password:string
#  Course Batch:string
# To create, update or delete a student, a CSV is uploaded. To read all the students, the CSV is downloaded. Except when reading, the file does not need to have as many rows as students in the database. When creating, updating and deleting, if the system detects an error it will report the number of the row at which it stopped processing, and the cause of the error.
# To create, a row must have a Name, RUT and Password. The ID will be assigned by the system (if the record doesn't have errors.)
# To update, a row must have an ID. Any other column will be overwritten on the database.
# To delete, a row must have an ID and all other columns must be left empty.

feature 'Admin for Users - CSV upload', :devise do

    before(:all) do
      User.destroy_all
      @user = FactoryGirl.create(:user, :admin, id: 10)
    end

    before(:each) do
      login_as(@user, :scope => :user)
    end

    after(:each) do
      Warden.test_reset!
    end

  scenario 'admin can upload CSV file and users are created' do
    visit upmin_path
    click_link "Upload students"
    attach_file :upload_file, "spec/test_files/students.csv"
    click_button "Upload"
    #test csv file should create 4 users
    expect(User.count).to eq 5
  end

  scenario 'error is displayed when CSV is missing columns' do
    visit upmin_path
    click_link "Upload students"
    attach_file :upload_file, "spec/test_files/students_with_missing_columns.csv"
    click_button "Upload"
    expect(current_path).to eq upmin.new_upload_path(:users)
    expect(User.count).to eq 1
    expect(page).to have_content "File has incorrect headers. It should contain: id, Email, Name, RUT, Password, Course_Batch, uploaded file has: id, Email, RUT, Password"
  end

  scenario 'CSV file upload displays results'
  #   visit upmin_path
  #   click_link "Upload students"
  #   attach_file :upload_file, "spec/test_files/students.csv"
  #   click_button "Upload"
  #   expect(current_path).to eq new_upload_path(:users)
  # end

  scenario 'admin can upload CSV file and users are updated'
  #setup users
  #upload file
  #test results (2 users should be updated)

  scenario 'admin can upload CSV file and users are deleted'
  #setup users
  #upload file
  #test results (2 users should be deleted)

  scenario 'CSV errors are detected and the rest of the file is processed'
  #setup users
  #upload file
  #test result output
  #page should contain information about 3 errors with details

  scenario 'empty lines in CSV are skipped'
  #setup users
  #upload file
  #test result output
  #page should contain info about skipped lines


end