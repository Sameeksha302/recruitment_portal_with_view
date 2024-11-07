# spec/factories/job_applications.rb
FactoryBot.define do
    factory :job_application do
      applicant_name { "John Doe" }
      applicant_email { "john.doe@example.com" }
      cover_letter { "I am excited to apply for this position." }
      resume { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'resume.pdf'), 'application/pdf') }
      association :candidate, factory: :user # Assuming you have a user factory
      association :job # Assuming you have a job factory

      # Optional: You can use a method to attach a resume file if you want to test the attachment
      after(:build) do |job_application|
        job_application.resume.attach(io: File.open(Rails.root.join('spec', 'support', 'resume.pdf')), filename: 'resume.pdf', content_type: 'application/pdf') if job_application.resume.blank?
      end
    end
  end
