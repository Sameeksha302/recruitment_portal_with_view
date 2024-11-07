# spec/models/job_application_spec.rb
require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  subject { build(:job_application) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an applicant name' do
      subject.applicant_name = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without an applicant email' do
      subject.applicant_email = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without a cover letter' do
      subject.cover_letter = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without a resume' do
      subject.resume = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid with an invalid email format' do
      subject.applicant_email = "invalid_email"
      expect(subject).not_to be_valid
    end

    # Optional: Uncomment if you decide to enforce resume format validation
    # it 'is not valid with an invalid resume format' do
    #   subject.resume.attach(io: File.open(Rails.root.join('spec', 'support', 'invalid_resume.txt')), filename: 'invalid_resume.txt', content_type: 'text/plain')
    #   expect(subject).not_to be_valid
    # end
  end

  describe 'associations' do
    it { should belong_to(:candidate).class_name('User') }
    it { should belong_to(:job) }
    it { should have_one_attached(:resume) }
  end
end
