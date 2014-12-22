include Warden::Test::Helpers
Warden.test_mode!

feature 'Admin for Users', :devise do

  before(:all) do
    User.destroy_all
    @user = FactoryGirl.create(:user, :admin)
    @users =FactoryGirl.create_list(:user,5)
  end

  before(:each) do
    login_as(@user, :scope => :user)
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario 'admin can view users listing index' do
    visit "/admin/m/User"
    test_user = @users.sample
    expect(page).to have_content test_user.email
    expect(page).to have_content test_user.name
    expect(page).to have_content test_user.rut
    expect(page).to have_content test_user.role
  end

  scenario 'admin can create a new user' do
    user_count = User.count
    visit "/admin/m/User/new"
    fill_in :user_password, with:"test1234"
    fill_in 'user_name', with:"Test User"
    fill_in 'user_email', with:"test@test.com"
    fill_in 'user_rut', with:"123123123131313"
    choose 'User'
    click_button "Create"
    expect(page).to have_content "User created successfully"
    expect(User.count).to eq user_count + 1
  end

  scenario 'admin can edit user' do
    test_user = @users.sample
    visit "/admin/m/User/i/#{test_user.id}"
    fill_in 'user_name', with: "CHANGED"
    click_button "Save"
    expect(page).to have_content "User updated successfully"
    expect(test_user.reload.name).to eq "CHANGED"
  end

  scenario 'admin can delete user from index' do
    test_user = @users.sample
    visit "/admin/m/User"
    find(".delete_user_#{test_user.id}").click
    expect(current_path).to eq "/admin/m/User"
    expect(page).to_not have_content test_user.name
  end

  scenario "there is a button to download users CSV export"

end

