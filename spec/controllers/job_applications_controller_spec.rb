# spec/controllers/job_applications_controller_spec.rb
require 'rails_helper'
require 'sidekiq/testing'
# Sidekiq::Testing.inline!

RSpec.describe JobApplicationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let!(:job) { create(:job) }    # Create job instance with let! to ensure it's available
  let(:valid_attributes) do
    {
      applicant_name: user.name,
      applicant_email: user.email,
      cover_letter: 'This is a cover letter.',
      resume: fixture_file_upload('spec/support/resume.pdf', 'application/pdf') # Adjusted to use fixture_file_upload
    }
  end

  before do
    sign_in user
    Sidekiq::Testing.fake!
  end


  describe 'POST #create' do
    context 'with valid parameters' do
      it 'redirects to the public companies path with a success message' do
        post :create, params: { job_id: job.id, job_application: valid_attributes }
        expect(response).to redirect_to(public_companies_path)
        expect(flash[:notice]).to eq('Application submitted successfully.')
      end

      it 'queues an email notification job' do
        expect {
          post :create, params: { job_id: job.id, job_application: valid_attributes }
        }.to change(EmailNotificationJob.jobs, :size).by(1)
      end

      it 'creates a new job application' do
        expect {
          post :create, params: { job_id: job.id, job_application: valid_attributes }
        }.to change(JobApplication, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      before do
        allow_any_instance_of(JobApplication).to receive(:save).and_return(false)
      end

      it 'renders the new template with an alert message' do
        post :create, params: { job_id: job.id, job_application: { cover_letter: '' } }
        expect(response).to render_template(:new)
      end

      it 'does not create a new job application' do
        expect {
          post :create, params: { job_id: job.id, job_application: { cover_letter: '' } }
        }.not_to change(JobApplication, :count)
      end
    end
  end
end
