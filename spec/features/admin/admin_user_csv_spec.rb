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
      @user = FactoryGirl.create(:user, :admin)
    end

    before(:each) do
      login_as(@user, :scope => :user)
    end

    after(:each) do
      Warden.test_reset!
    end

  scenario 'admin can upload CSV file and create users'

  scenario 'CSV errors are detected and the rest of the file is processed'

end