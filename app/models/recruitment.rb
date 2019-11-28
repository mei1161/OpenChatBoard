class Recruitment < ApplicationRecord
  validates :room_url,starts_with? 'https://line.me/ti/g2/'
  validates :room_name,presence: true
end
