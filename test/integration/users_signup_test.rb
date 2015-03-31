require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
    # Yet again, I took this from www.railstutorial.org.
    
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
    
    test "valid signup information" do
        get new_user_path
        assert_difference 'User.count' do
            post_via_redirect users_path, user: { name: "Jenny Loggins",
                                                  email: "jlogs@example.com",
                                                  password: "foobar",
                                                  password_confirmation: "foobar" }
        end
        assert_template 'users/show'
    end
    
end