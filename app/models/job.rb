class Job < ApplicationRecord
  belongs_to :company
  has_many :job_applications, dependent: :destroy
  # belongs_to :recruiter, class_name: 'User', foreign_key: 'recruiter_id'
  belongs_to :user,foreign_key: 'recruiter_id'
  # belongs_to :user,foreign_key: 'recruiter_id'
  enum status: { active: 0, closed: 1 }



  scope :active_jobs, -> { where(status: :active) }
  scope :closed_jobs, -> { where(status: :closed) }

  validates :title, :description, :salary, :location, :status, presence: true
  
end
