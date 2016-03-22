class History < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :presence => true
  validates :company, :presence => true,
                      :length => { :maximum => 100 }
  validates :position, :presence => true,
                       :length => { :maximum => 50 }
  validates :startdate, :presence => true
  validates :details, :presence => true,
                      :length => { :maximum => 10000 }

end
