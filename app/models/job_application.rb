class JobApplication < ApplicationRecord
  # belongs_to :user
  # belongs_to :job
  # has_one_attached :resume

  belongs_to :Candidate, class_name: 'User',foreign_key: 'candidate_id'
  belongs_to :job
  has_one_attached :resume

  # validates :cover_letter, :resume, presence: true
  validates :applicant_name, :applicant_email, :cover_letter, :resume,presence: true
  # validates :applicant_name, :applicant_email, :cover_letter, presence: true
  # validates :resume, attached: true, content_type: ['application/pdf', 'application/msword']

  
end