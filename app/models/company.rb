class Company < ApplicationRecord
    # belongs_to :user, class_name: 'User', foreign_key: 'company_id', optional: true
    # belongs_to :user, optional: true
    has_many :users, dependent: :destroy
    has_many :jobs, dependent: :destroy
    validates :name, :address, :industry_type, presence: true
end
