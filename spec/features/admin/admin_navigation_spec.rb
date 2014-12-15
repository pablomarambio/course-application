feature 'Admin navigation', :devise do

  scenario 'view navigation links' do
    user = FactoryGirl.create(:user, :admin)
    signin(user.email, user.password)
    visit upmin_path
    expect(page).to have_content 'Upmin'
    expect(page).to have_content 'Users'
    expect(page).to have_content 'Sign out'
  end

end