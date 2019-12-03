class Recruitment < ApplicationRecord
  has_many :recruitment_comments
  has_secure_password
  validates :room_name,presence: true
  validate :check_url

  private
   def check_url
     unless room_url.starts_with? 'https://line.me/ti/g2/'
       errors.add(:room_url,"Invalid URL")
     end
   end
end
