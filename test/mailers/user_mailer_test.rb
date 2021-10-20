require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = User.first
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "激活您的账户", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@educoder.net"], mail.from
    assert_match "Educoder | Rails Tutorial", mail.body.encoded
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

end
