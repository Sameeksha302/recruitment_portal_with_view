class JobApplication < ApplicationRecord
  # belongs_to :user
  # belongs_to :job
  # has_one_attached :resume

  belongs_to :Candidate, class_name: 'User'
  belongs_to :job
  has_one_attached :resume

  # validates :cover_letter, :resume, presence: true
  validates :applicant_name, :applicant_email, :cover_letter, :resume,presence: true

  
end
