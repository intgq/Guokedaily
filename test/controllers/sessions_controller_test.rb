require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(name: "Example User", email: "user@example.com",
                        password: 'testPassword',
                        password_confirmation: 'testPassword')
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_select "div[class=?]", "alert alert-danger", count: 1
    assert_not flash.empty?
    get login_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'testPassword' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "h1", text: @user.name
    assert is_logged_in?
    get login_path
    assert_redirected_to @user
    get logout_path
    assert_redirected_to login_path
    assert_not is_logged_in?
    get logout_path
  end

  test "login with remembering" do
    log_in_as(@user, password: 'testPassword', remember_me: '1')
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, password: 'testPassword', remember_me: '1')
    log_in_as(@user, password: 'testPassword', remember_me: '0')
    assert_empty cookies['remember_token']
  end

end

