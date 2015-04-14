require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
    # Yet again, I took this from www.railstutorial.org.
    def setup
        ActionMailer::Base.deliveries.clear
    end
    
    
    test "invalid signup information" do
        get new_user_path
        assert_no_difference 'User.count' do
            post users_path, user: { name: "",
                                     email: "user@invalid",
                                     password: "foo",
                                     password_confirmation: "bar" }
        end
        assert_template 'users/new'
    end
    
    test "valid signup information with account activation" do
        get new_user_path
        assert_difference 'User.count' do
            post users_path, user: { name: "Jenny Loggins",
                                     email: "jlogs@example.com",
                                     password: "foobar",
                                     password_confirmation: "foobar" }
        end
        assert_equal 1, ActionMailer::Base.deliveries.size
        user = assigns(:user)
        assert_not user.activated?
        # Try to log in; we aren't activated yet, so it wshouldn't work
        log_in_as(user)
        assert_not is_logged_in?
        # Token is good, but the email is wrong
        get edit_account_activation_path(user.activation_token, email: 'wrong')
        assert_not is_logged_in?
        # everything is correct
        get edit_account_activation_path(user.activation_token, email: user.email)
        assert user.reload.activated?
        follow_redirect!
        assert_template 'users/show'
        assert is_logged_in?
    end
    
end
