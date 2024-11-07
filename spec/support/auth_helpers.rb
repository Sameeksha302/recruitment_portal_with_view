# spec/support/auth_helpers.rb

module AuthHelpers
  def sign_in(user)
    visit new_user_session_path  # Use the Devise login path helper
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'  # Replace with the actual button text or ID
  end
end
