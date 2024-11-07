class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  enum :role, { Admin: 0, Recruiter: 1, Candidate: 2 }

  # has_many :companies, foreign_key: :user_id, dependent: :destroy#, if: :Admin?
  belongs_to :company, optional: true # ,foreign_key: :company_id # Only recruiters and admins are linked to a company
  has_many :jobs, foreign_key: :recruiter_id, dependent: :destroy    # Jobs created by this user (if Recruiter)

  validates :company_id, presence: true, if: :requires_company_name?
  validates :company_name, presence: true, if: :requires_company_name?
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true

  # Set a default role on creation if none is provided
  after_initialize :set_default_role, if: :new_record?

  private
  def set_default_role
    self.role ||= :Candidate
  end


  def requires_company_name?
    role == "Recruiter"
  end
end
