class Comment < ActiveRecord::Base
  belongs_to :note
  validates :commenter, :presence => true
  validates :user_id, :presence => true
  validates :body, :presence => true,
                   :length => { :maximum => 500 }
end
