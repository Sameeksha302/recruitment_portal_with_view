class Job < ApplicationRecord
  belongs_to :company
  has_many :applications, dependent: :destroy

  enum status: { active: 0, closed: 1 }

  validates :title, :description, :salary, :location, :status, presence: true
end
