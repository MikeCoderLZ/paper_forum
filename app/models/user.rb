class User < ActiveRecord::Base
    # copied from www.railstutorial.org, chapter 6
    # it ain't perfect, but we can deal with that later
    # does what it says: downcase the email before we save
    # this is the ONLY ENSURANCE we have that the database won't be
    # corrupted.
    before_save { self.email = email.downcase }
    # This matches emails. Not 100% to spec, but rational
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    # An email shall be present, no logner than 255 characters (DB restriction),
    # follows the regex format, and its uniqueness is indifferent to case
    validates :email, presence: true, length: { maximum: 255},
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    # Matches an alphanumeric name
    VALID_NAME_REGEX = /\A[\w]+/
    # A name shall be present, at least one character long and no more than 255
    validates :name, presence: true,
                     length: { minimum: 1, maximum: 255 },
                     format: { with: VALID_NAME_REGEX }
    validates :password, presence: true,
                         length: { minimum: 6 }
    # this does all the machinery for a secure password, in conjunction with Bcrypt
    has_secure_password
    # This is used for the remember session functionality
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save   :downcase_email
    before_create :create_activation_digest
    
    # member method: encrypts a string
    def User.digest( string )
        # sets the encryption cost to the minimum cost if we are in dev mode,
        # basically
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        # use the BCrypt engine to encrypt the string
        BCrypt::Password.create( string, cost: cost )
    end
    
    def User.new_token
        # generate a random base 64 string as the token
        SecureRandom.urlsafe_base64
    end
    
    def remember
        # generate a new token. This is the ONLY PLACE where the remember_token
        # is reset. VERY IMPORTANT TO REMEMBER
        self.remember_token = User.new_token
        # we got the remember_digest from the database, I think?
        # whatever: encrypt the new token, store it in the digest
        update_attribute( :remember_digest, User.digest( remember_token ) )
    end
    
    # Returns true of the given token matches the given attribute digest.
    def authenticated?( attribute, token )
        # In this context, "password" is taken to be a generalization;
        # we are using the authentication code of BCrypt to authenticate
        # something that isn't STRICTLY speaking 'the' password.
        digest = send("#{attribute}_digest")
        # ^ Ruby metaprogramming hoodoo ^
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end
    
    def forget
        # clear the remember token
        update_attribute(:remember_digest, nil)
    end
    
    def activate
        update_attribute(:activated, true)
        update_attribute(:activated_at, Time.zone.now)
    end
    
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end
    
    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest, User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end
    
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
    
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end
    
    private
        def downcase_email
            self.email = email.downcase
        end
        
        def create_activation_digest
            self.activation_token  = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
end
