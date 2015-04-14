require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
    
    def setup
        @user1 = User.new(name: "Example User",
                          email: "user@example.com",
                          password: "password",
                          password_confirmation: "password")
    end
    
    # the original test was copied whole-hog from
    # www.railstutorial.org/book/modeling_users.
    
    test "email validation should accept valid addresses" do
        valid_addresses = %w[user@example.com
                             USER@foo.COM A_US-ER@foo.bar.org
                             first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
            @user1.email = valid_address
            assert @user1.valid?, "#{valid_address.inspect} should be valid"
        end
    end
    
    # likewise
    
    test "email validation should reject invalid addresses" do
        invalid_addresses = %w[user@example,com
                               user_at_foo.org user.name@example.
                               foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
            @user1.email = invalid_address
            assert_not @user1.valid?,
                       "#{invalid_address.inspect} should be invalid"
        end
    end
    
    test "emails must be unique" do
        duplicate_user = @user1.dup
        duplicate_user.email = @user1.email.upcase
        @user1.save
        assert_not duplicate_user.valid?
    end
    
    test "emails should be converted to lower case" do
        uppercase_email = @user1.email.upcase
        @user1.email = uppercase_email.dup
        @user1.save
        assert_not @user1.email.eql? uppercase_email
    end
    
    
    test "name validation should accept limited strings as valid" do
        valid_names = %w[ james_joyce
                          _geofrey43
                          HelloThere ]
        valid_names.each do |valid_name|
            @user1.name = valid_name
            assert @user1.valid?,
                  "#{valid_name.inspect} should be valid"
        end
    end
    
    test "passwords should have a minimu length" do
        @user1.password = @user1.password_confirmation = "a" * 5
        assert_not @user1.valid?
    end
    
    test "authenticated? should return false for a user with nil digest" do
        assert_not @user1.authenticated?(:remember, '')
    end
    
#     test "name validation should reject limited strings as valid" do
#         invalid_names = %w[ james~oyce
#                             (*^^(%__dfkjh
#                             (){}]
#         invalid_names.each do |invalid_name|
#             @user1.name = invalid_name
#             assert_not @user1.valid?,
#                       "#{invalid_name.inspect} should be invalid"
#         end
#     end
        
end
