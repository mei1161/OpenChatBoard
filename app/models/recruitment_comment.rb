class RecruitmentComment < ApplicationRecord
  belongs_to :recruitment
  has_secure_password
  has_many :recruitment_comments
  has_ancestry
  validates :text,presence: true
end
