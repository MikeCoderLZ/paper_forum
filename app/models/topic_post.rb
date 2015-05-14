class TopicPost < ActiveRecord::Base
  belongs_to :user
  belongs_to :board
  belongs_to :root_post, class_name: "TopicPost"
end
