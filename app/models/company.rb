class Company < ApplicationRecord
    has_many :users, dependent: :destroy
    # has_many :jobs, dependent: :destroy
    # belongs_to :Admin, class_name: 'User', foreign_key: 'admin_id'
    has_many :jobs, dependent: :destroy
    # has_many :Recruiters, class_name: 'User', foreign_key: 'company_id'
    

    validates :name, :address, :industry_type, presence: true
end