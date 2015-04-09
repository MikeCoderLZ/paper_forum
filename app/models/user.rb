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
    attr_accessor :remember_token
    
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
    
    # Returns true of the given token matches the digest.
    def authenticated?( remember_token )
        # In this context, "password" is taken to be a generalization;
        # we are using the authentication code of BCrypt to authenticate
        # something that isn't STRICTLY speaking 'the' password.
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
    
    def forget
        # clear the remember token
        update_attribute(:remember_digest, nil)
    end
end
