class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  enum :role, {:Admin=>0, :Recruiter=>1, :Candidate=>2}

  has_many :companies, dependent: :destroy #Admin
  belongs_to :company, optional: true  # Only recruiters and admins are linked to a company
  validates :company_name, presence: true, if: -> { role == 'Recruiter' }
  validates :name,presence: true
  # validates :role, presence: true

  # Set a default role on creation if none is provided
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :Candidate
  end
end


