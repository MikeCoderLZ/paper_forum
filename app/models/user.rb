class User < ActiveRecord::Base
    # copied from www.railstutorial.org, chapter 6
    # it ain't perfect, but we can deal with that later
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255},
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    VALID_NAME_REGEX = /\A[\w]+/
    validates :name, presence: true,
                     length: { minimum: 1, maximum: 255 }
end
