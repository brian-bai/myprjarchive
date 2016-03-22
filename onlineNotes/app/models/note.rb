class Note < ActiveRecord::Base
  belongs_to :user
  has_many :comment, :dependent => :destroy
  validates :title, :presence => true,
                     :length => { :maximum => 50 }
  validates :user_id, :presence => true
  validates :detail, :presence => true,
                      :length => { :maximum => 10000 }
  validates :openlevel, :presence => true,
                        :inclusion => 1..2

end
