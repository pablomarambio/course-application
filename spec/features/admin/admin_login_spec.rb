# feature 'Sign in', :devise do

#   # Scenario: User cannot sign in if not registered
#   #   Given I do not exist as a user
#   #   When I sign in with valid credentials
#   #   Then I see an invalid credentials message
#   scenario 'user cannot sign in if not registered' do
#     signin('test@example.com', 'please123')
#     expect(page).to have_content I18n.t 'devise.failure.not_found_in_database', authentication_keys: 'email'
#   end


#create admin

#login as admin

#admin can access /admin


#create ordinary user

#login as user

#ordinary user can't access /admin


