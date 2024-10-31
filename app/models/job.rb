class Job < ApplicationRecord
  belongs_to :company
  # has_many :applications, dependent: :destroy
  has_many :job_applications, dependent: :destroy

  enum status: { :active=>0, :closed=>1 }

  scope :active_jobs, -> { where(status: :active) }
  scope :closed_jobs, -> { where(status: :closed) }

  validates :title, :description, :salary, :location, :status, presence: true
  
  # scope :available, -> { where(status: true) }
end
