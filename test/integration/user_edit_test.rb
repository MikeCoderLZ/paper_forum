require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
    # www.railstutorial.org
    def setup
        @user = users(:john_doe)
    end
    
    test "unsuccessful edit" do
        log_in_as(@user)
        # visit the edit page for users
        get edit_user_path(@user)
        # make sure we got to the right page
        assert_template 'users/edit'
        # update the user to trigger the unsuccessful update behavior
        patch user_path(@user), user: { name: "",
                                        email: "foo@invalid",
                                        password: "foo",
                                        password_confirmation: "bar" }
        # we should have gone nowhere
        assert_template 'users/edit'
    end
    
    test "successful edit" do
        log_in_as(@user)
        # visit the edit page for users
        get edit_user_path(@user)
        # make sure we got to the right page
        assert_template 'users/edit'
        name = "Jenean"
        email = "jnah@example.com"
        # update the user to trigger the unsuccessful update behavior
        patch user_path(@user), user: { name: name,
                                        email: email,
                                        password:              "passed",
                                        password_confirmation: "passed" }
        assert_not flash.empty?
        # make sure we are redirected to thr profile page
        assert_redirected_to @user
        # clean the data
        @user.reload
        # make sure the database info is indeed the info we entered
        assert_equal @user.name, name
        assert_equal @user.email, email
    end
    
    test "successful edit with friendly forwarding" do
        get edit_user_path(@user)
        log_in_as(@user)
        assert_redirected_to edit_user_path(@user)
        name = "Jenean"
        email = "jnah@example.com"
        # update the user to trigger the unsuccessful update behavior
        patch user_path(@user), user: { name: name,
                                        email: email,
                                        password:              "passed",
                                        password_confirmation: "passed" }
        assert_not flash.empty?
        # make sure we are redirected to thr profile page
        assert_redirected_to @user
        # clean the data
        @user.reload
        # make sure the database info is indeed the info we entered
        assert_equal @user.name, name
        assert_equal @user.email, email
    end
    
end
