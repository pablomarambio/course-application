# Feature: Navigation links
#   As a visitor
#   I want to see navigation links
#   So I can find home, sign in, or sign up
feature 'Navigation links', :devise do

  # Scenario: View navigation links
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see "home," "sign in
  scenario 'view navigation links' do
    visit root_path
    expect(page).to have_content 'Home'
    expect(page).to have_content 'Sign in'
    expect(page).to_not have_content 'Admin'
    # expect(page).to have_content 'Sign up'
  end

  # Scenario: No admin for normal users
  #   Given I am a admin
  #   When I visit the home page
  #   Then I see "admin"
  scenario 'no admin for normal users' do
    user = FactoryGirl.create(:user)
    signin(user.email, user.password)
    expect(page).to_not have_content 'Admin'
  end

  # Scenario: View admin link
  #   Given I am a admin
  #   When I visit the home page
  #   Then I see "admin"

  scenario 'view admin link' do
    user = FactoryGirl.create(:user, :admin)
    signin(user.email, user.password)
    visit root_path
    expect(page).to have_content 'Admin'
  end

end
