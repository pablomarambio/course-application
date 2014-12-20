include Warden::Test::Helpers
Warden.test_mode!

feature 'Public interface', :devise do

  after(:each) do
    Warden.test_reset!
  end


  scenario "User can sign in using rut" do
    #create user
    @user = FactoryGirl.create :user, :with_batch
    #go to login page
    visit new_user_session_path
    #login using rut
    fill_in "user_login", with: @user.rut
    fill_in "user_password", with: @user.password
    click_button "Sign in"
    #expect to be logged in
    expect(page).to have_content "Signed in successfully"
  end

  scenario "shows link to each other public page" do
    visit root_path
   #home
   expect(page).to have_link("Home", :href=>"/")
   #idle students
   expect(page).to have_link("Idle students", :href=>"/public/students/idle")
   #incomplete applications
   expect(page).to have_link("Incomplete applications", :href=>"/public/applications/incomplete")
   #available courses
   expect(page).to have_link("Available courses", :href=>"/public/courses/available")
   #batches
   expect(page).to have_link("Batches", :href=>"/public/batches")
   #sign in
   expect(page).to have_link("Sign in", :href=>"/users/sign_in")
  end

  scenario "idle students page shows llst of students" do
    User.destroy_all
    @users = FactoryGirl.create_list(:user,5, :with_batch)
    visit idle_students_path
    expect(all(".idle-students-row").count).to eq 5
    within("#idle-student-row-#{@users.first.id}") do
      expect(page).to have_content @users.first.rut
      expect(page).to have_content @users.first.name
      expect(page).to have_content @users.first.sign_in_count
      expect(page).to have_content @users.first.last_sign_in_at
    end
  end

  scenario "incomplete applications page shows students with incomplete applications" do
    @users = FactoryGirl.create_list(:user,5, :incompleted_application)
    visit incomplete_applications_path
    expect(all(".incompleted-applications-students-row").count).to eq 5
    within("#incompleted-applications-student-row-#{@users.first.id}") do
      expect(page).to have_content @users.first.rut
      expect(page).to have_content @users.first.name
      expect(page).to have_content @users.first.sign_in_count
      expect(page).to have_content @users.first.last_sign_in_at
    end
  end

  context "available courses page" do

    before(:each) do
      @course_batches = FactoryGirl.create_list(:course_batch, 5, :with_blocks)
      visit available_courses_path
    end

    scenario "shows courses table" do
      expect(all(".available-course-row").count).to eq @course_batches.sum{|b| b.courses.count}
    #Lists all course batches.
    end

    scenario "each row has assigned students count" do
      within("#available-course-#{@course_batches.first.courses.first.id}") do
        expect(page).to have_content @course_batches.first.users.count
      end
    end

    scenario "each row shows from and to" do
      within("#available-course-#{@course_batches.first.courses.first.id}") do
        expect(page).to have_content @course_batches.first.courses.first.block.to.strftime("%H:%M")
        expect(page).to have_content @course_batches.first.courses.first.block.from.strftime("%H:%M")
      end
    end

  end

  context "batches page" do

    before(:each) do
      @course_batches = FactoryGirl.create_list(:course_batch, 5, :with_blocks)
      visit batches_path
    end
    #Lists all batches and their status.

    scenario "shows batches table" do
      expect(all(".batches-row").count).to eq @course_batches.count
    end

    scenario "shows number of blocks for each row" do
        within("#batch-row-#{@course_batches.first.id}") do
          expect(page).to have_content @course_batches.first.blocks.count
        end
    end

    scenario "shows number of courses for each row" do
      within("#batch-row-#{@course_batches.first.id}") do
        expect(page).to have_content @course_batches.first.courses.count
      end
    end

    scenario "shows status for each row" do
      within("#batch-row-#{@course_batches.first.id}") do
        expect(page).to have_content "Open"
      end
    end

  end

  context "after sign in" do

    scenario "user is redirected to /apply/:batch/block" do
      #create user
      #setup batch and blocks
      @user = FactoryGirl.create :user, :with_batch
      #go to login page
      visit new_user_session_path
      #login using rut
      fill_in "user_login", with: @user.rut
      fill_in "user_password", with: @user.password
      click_button "Sign in"
      #expect to be redirected to course selection, to the assigned batch and to the first block
      expect(current_path).to eq "/apply/#{@user.course_batch_id}/#{@user.course_batch.blocks.first.id}"
    end

    scenario "admin is redirected to /admin" do
      #create admin
      @user = FactoryGirl.create :user, :admin
      #go to login page
      visit new_user_session_path
      #login using rut
      fill_in "user_login", with: @user.rut
      fill_in "user_password", with: @user.password
      click_button "Sign in"
      #expect to be redirected to admin
      expect(current_path).to eq upmin_path
    end

    scenario "batches page allows admins to toggle batch status" do
      @user = FactoryGirl.create :user, :admin
      @course_batches = FactoryGirl.create_list(:course_batch, 5, :with_blocks)
      signin(@user.rut, @user.password)
      visit batches_path
      within("#batch-row-#{@course_batches.first.id}") do
          click_link "Toggle"
      end
      expect(current_path).to eq batches_path
      within("#batch-row-#{@course_batches.first.id}") do
        expect(page).to have_content "Closed"
      end
    end

  end

end