require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @cur_user = User.create(name: "Example User", email: "user@example.com",
                            password: 'testPassword',
                            password_confirmation: 'testPassword')
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get show" do
    get "/users/#{@cur_user.id}"
    assert_response :success
  end

  test "should not have debug infos" do
    get "/users/#{@cur_user.id}"
    assert_select "body pre", 0
  end

  test "should have profile photo" do
    get "/users/#{@cur_user.id}"
    assert_select "img", alt: @cur_user.name, class: "gravatar"
  end

  test "should match cur user" do
    get "/users/#{@cur_user.id}"
    assert_select "h1", text: @cur_user.name
  end

  test "/users/new should have name text field" do
    get "/users/new"
    assert_select "input#user_name", 1
  end

  test "/users/new should have email text field" do
    get "/users/new"
    assert_select "input#user_email", 1
  end

  test "/users/new should have password text field" do
    get "/users/new"
    assert_select "input#user_password", 1
  end

  test "/users/new should have password confirmation text field" do
    get "/users/new"
    assert_select "input#user_password_confirmation", 1
  end

  test "/users/new should have submit button" do
    get "/users/new"
    assert_select "input[name=commit]", value: "创建账户"
  end

  test "unsuccess edit" do
    log_in_as(@cur_user, password: 'testPassword')
    get edit_user_path(@cur_user)
    assert_template 'users/edit'
    email = "educoder@invaild"
    patch user_path(@cur_user), params: { user: { name: '',
                                                  email: email,
                                                  password:              'abc',
                                                  password_confirmation: 'cba' } }

    assert_template 'users/edit'
  end

  test "successful edit with friendly forward" do
    get edit_user_path(@cur_user)
    log_in_as(@cur_user, password: 'testPassword')
    assert_redirected_to edit_user_url(@cur_user)
    name  = "educoder - modify"
    email = "modify@educoder.net"
    patch user_path(@cur_user), params: { user: { name:  name,
                                                  email: email,
                                                  password:              "",
                                                  password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @cur_user
    @cur_user.reload
    assert_equal name,  @cur_user.name
    assert_equal email, @cur_user.email
  end

  test "should redirect edit when user not logged" do
    get edit_user_path(@cur_user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect update when user not logged" do
    name  = "educoder - modify"
    email = "modify@educoder.net"
    patch user_path(@cur_user), params: { user: { name:  name,
                                                  email: email } }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index when not logged" do
    get users_url
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
      user: { password: 'password',
              password_confirmation: 'password',
              admin: 1 } }
    assert_not @other_user.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to users_url
  end

  test "user detail page should have micropost info" do
    log_in_as(@other_user)
    @other_user.save
    @other_user.microposts.create!(content: "Hello, World!")
    get "/users/#{@other_user.id}"
    assert_select "h3", text: "我的微博(#{@other_user.microposts.count})"
    assert_select "span.content", text: "Hello, World!"
    assert_select "span.timestamp", /发布于/
  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

end
