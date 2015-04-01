require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
   
    # mostly lifted from www.railstutorial.org
    def setup
        @user = users(:john_doe)
    end
    
    test "login with invalid information" do
        get login_path
        assert_template 'sessions/new'
        post login_path, session: { email: "", password: "" }
        assert_template 'sessions/new'
        assert_not flash.empty?
        get root_path
        assert flash.empty?
    end
    
    test "login with valid information" do
        # go to the login page
        get login_path
        # Note that the YML file represents an instance of the User
        # model, which DOES NOT have a password attribute and the
        # database DOES NOT either. So we are saying that all fixture
        # based test objects have the same password: "password"
        post login_path, session: { email: @user.email, password: 'password' }
        assert is_logged_in?
        # we should be redirected to the page for the user that logged in
        assert_redirected_to @user
        follow_redirect!
        # make sure that the redirect displayed the correct template
        assert_template 'users/show'
        # make sure the correct links appear, or don't
        # this obliquely makes sure that the page is correctly
        # detecting a logged-in user
        assert_select "a[href=?]", login_path, count: 0
        assert_select "a[href=?]", logout_path
        assert_select "a[href=?]", user_path(@user)
        # now, log out
        delete logout_path
        assert_not is_logged_in?
        # make sure we are redirected to the home page
        assert_redirected_to root_url
        follow_redirect!
        assert_select "a[href=?]", login_path
        assert_select "a[href=?]", logout_path,      count: 0
        assert_select "a[href=?]", user_path(@user), count: 0
    end
end
