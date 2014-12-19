feature 'Public interface', :devise do

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

  end

end