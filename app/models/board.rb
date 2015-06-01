class Board < ActiveRecord::Base
  belongs_to :parent, class_name: "Board"
  has_many :children, class_name: "Board",
           dependent: :destroy, foreign_key: "parent_id"
  has_many :topic_posts, foreign_key: "board"
  
end
