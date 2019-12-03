class RecruitmentComment < ApplicationRecord
  belongs_to :recruitment
  has_secure_password
  validates :text,presence: true
end
