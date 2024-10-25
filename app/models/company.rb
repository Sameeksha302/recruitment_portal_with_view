class Company < ApplicationRecord
    has_many :users, dependent: :destroy
    has_many :jobs, dependent: :destroy
  
    validates :name, :address, :industry_type, presence: true
end