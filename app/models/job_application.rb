class JobApplication < ApplicationRecord
  belongs_to :candidate, class_name: 'User',foreign_key: 'candidate_id'
  belongs_to :job
  has_one_attached :resume
  validates :applicant_name, :applicant_email, :cover_letter, :resume, presence: true
  validates :applicant_email,presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email format" }

  # validates :resume, attached: true, content_type: ['application/pdf', 'application/msword']

  
end