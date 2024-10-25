class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job
  has_one_attached :resume

  validates :cover_letter, :resume, presence: true
end
