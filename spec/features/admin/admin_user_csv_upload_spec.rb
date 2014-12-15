include Warden::Test::Helpers
Warden.test_mode!


#   scenario 'admin can view users listing index' do
#     visit "/admin/m/User"
#     test_user = @users.sample
#     expect(page).to have_content test_user.email
#     expect(page).to have_content test_user.name
#     expect(page).to have_content test_user.rut
#     expect(page).to have_content test_user.role
#   end

feature 'Admin for Users - CSV upload', :devise do

    before(:all) do
      @user = FactoryGirl.create(:user, :admin)
      @users =FactoryGirl.create_list(:user,5)
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