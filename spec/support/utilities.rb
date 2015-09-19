def login_user
  visit login_path
  fill_in "session_email", with: "misha@krutman.ru"
  fill_in "session_password", with: "hellorex"
  click_button "Login"
end
