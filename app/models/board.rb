class Board < ActiveRecord::Base
  belongs_to :parent, class_name: "Board"
  
end
