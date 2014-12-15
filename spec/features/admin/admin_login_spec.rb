feature 'Admin panel', :devise do

  #create admin
  #login as admin
  #admin can access /admin

  scenario 'admin can sign in and access the admin panel' do
    user = FactoryGirl.create(:user, :admin)
    signin(user.email, user.password)
    visit upmin_path
    expect(page).to have_content "Upmin"
    expect(current_path).to eq upmin_path
  end

  #create ordinary user
  #login as user
  #ordinary user can't access /admin

  scenario 'ordinary user cant access the admin panel' do
    user = FactoryGirl.create(:user)
    signin(user.email, user.password)
    visit upmin_path
    expect(page).to have_content "Access denied"
    expect(current_path).to eq root_path
  end

end