class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  enum :role, { Admin: 0, Recruiter: 1, Candidate: 2 }

  # has_many :companies, foreign_key: :user_id, dependent: :destroy#, if: :Admin?
  belongs_to :company, optional: true # ,foreign_key: :company_id # Only recruiters and admins are linked to a company
  has_many :jobs, foreign_key: :recruiter_id, dependent: :destroy    # Jobs created by this user (if Recruiter)


  validates :company_name, presence: true, if: :requires_company_name?
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true

  # Set a default role on creation if none is provided
  after_initialize :set_default_role, if: :new_record?
  after_create :set_company_id

  # def set_company_id
  #    company_id = Company.find_by(name: self.company_name).id
  #    if company_id.present?
  #    self.update(company_id: company_id)
  #    self.save!
  #    end
  # end

  def set_company_id
    return if company_name.nil? # Skip if no company_name is provided
  
    company = Company.find_by(name: self.company_name)
    if company.present?
      self.company_id = company.id
      self.save!
    end
  end
  

  private
  def set_default_role
    self.role ||= :Candidate
  end


  def requires_company_name?
    role == "Recruiter"
  end
end
