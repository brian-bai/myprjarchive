class Profile < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :presence => true
  validates :birthday, :presence => true
  validates :gender, :presence => true
  validates :address, :presence => true
  phone_regex = /\A[\d]+\z/
  #phone_regex = /\A\d{8,9}\z/
  validates :phone, :presence => true,
                    :format => { :with => phone_regex },
                    :length => { :within => 6..9 }
end
