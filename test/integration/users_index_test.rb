require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
    def setup
        @admin = users(:john_doe)
        @non_admin = users(:jane_doe)
    end
    
    test "index including pagination" do
        log_in_as(@admin)
        # navigate to the user index apge
        get users_path
        # make sure that we actually got to the index page
        assert_template 'users/index'
        # make sure the paginate gadget is present
        assert_select 'div.pagination'
        # make sure the user links actually go to the correct user
        first_page_of_users = User.paginate( page: 1)
        first_page_of_users.each do |user|
            assert_select 'a[href=?]', user_path(user)#, text: user.name
#             unless user == @admin
#                 assert_select 'a[href=?]', user_path(user), text: 'delete',
#                         method: :delete
#             end
        end
        assert_difference 'User.count', -1 do
            delete user_path(@non_admin)
        end
    end
    
    test "index as non-admin" do
        log_in_as(@non_admin)
        get users_path
        assert_select 'a', text: 'delete', count: 0
    end
    
end
