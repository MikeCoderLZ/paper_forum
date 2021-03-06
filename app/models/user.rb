class User < ActiveRecord::Base
    # copied from www.railstutorial.org, chapter 6
    # it ain't perfect, but we can deal with that later
    before_save { self.email = email.downcase }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255},
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    VALID_NAME_REGEX = /\A[\w]+/
    validates :name, presence: true,
                     length: { minimum: 1, maximum: 255 }
    validates :password, presence: true,
                         length: { minimum: 6 }
    has_secure_password
    attr_accessor :remember_token
    
    def User.digest( string )
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create( string, cost: cost )
    end
    
    def User.new_token
        SecureRandom.urlsafe_base64
    end
    
    def remember
        self.remember_token = User.new_token
        update_attribute( :remember_digest, User.digest( remember_token ) )
    end
    
    # Returns true of the given token matches the digest.
    def authenticated?( remember_token )
        # In this context, "password" is taken to be a generalization;
        # we are using the authentication code of BCrypt to authenticate
        # something that isn't STRICTLY speaking 'the' password.
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
    
    def forget
        update_attribute(:remember_digest, nil)
    end
end
