require 'rails_helper'
require 'sidekiq/testing'
# Sidekiq::Testing.fake!

RSpec.describe JobsController, type: :controller do
  let(:recruiter) { create(:user, :recruiter) }
  let(:company) { recruiter.company }
  let(:job) { create(:job, company: company, recruiter_id: recruiter.id) }

  before do
    sign_in recruiter  # Assuming Devise for authentication
  end

  describe 'GET #index' do
    context 'when the user is a recruiter' do
      it 'assigns @jobs to the recruiter’s company jobs' do
        get :index, params: { company_id: company.id }
        expect(assigns(:jobs)).to eq([ job ])
        expect(response).to render_template(:index)
      end
    end

    context 'when the user is not a recruiter' do
      let(:candidate) { create(:user, :candidate) }

      before do
        sign_in candidate
      end

      it 'assigns @jobs to all jobs' do
        get :index, params: { company_id: company.id }
        expect(assigns(:jobs)).to include(job)
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested job to @job' do
      get :show, params: { id: job.id, company_id: company.id }
      expect(assigns(:job)).to eq(job)
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new job to @job' do
      get :new, params: { company_id: company.id }
      expect(assigns(:job)).to be_a_new(Job)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) {
      {
        title: "Software Engineer",
        description: "Develop and maintain software applications.",
        salary: 70000,
        location: "New York"
      }
    }

    context 'with valid attributes' do
      it 'creates a new job' do
        expect {
          post :create, params: { company_id: company.id, job: valid_attributes }
        }.to change(Job, :count).by(1)
        expect(flash[:notice]).to eq('Job created successfully.')
        expect(response).to redirect_to(company_jobs_path(company))
      end

      it 'enqueues a job posted email notification' do
        expect(EmailNotificationJob).to receive(:perform_async).with('job_posted', recruiter.id, instance_of(Integer))
        post :create, params: { company_id: company.id, job: valid_attributes }
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new job and renders new template' do
        expect {
          post :create, params: { company_id: company.id, job: valid_attributes.merge(title: nil) }
        }.not_to change(Job, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested job to @job' do
      get :edit, params: { id: job.id, company_id: company.id }
      expect(assigns(:job)).to eq(job)
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the requested job and redirects' do
        patch :update, params: { id: job.id, company_id: company.id, job: { title: 'Updated Title' } }
        job.reload
        expect(job.title).to eq('Updated Title')
        expect(flash[:notice]).to eq('Job updated successfully.')
        expect(response).to redirect_to(company_jobs_path(company))
      end
    end

    context 'with invalid attributes' do
      it 'does not update the job and re-renders the edit template' do
        patch :update, params: { id: job.id, company_id: company.id, job: { title: nil } }
        expect(job.reload.title).not_to be_nil
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested job and redirects' do
      job_to_delete = create(:job, company: company, recruiter_id: recruiter.id)
      expect {
        delete :destroy, params: { id: job_to_delete.id, company_id: company.id }
      }.to change(Job, :count).by(-1)
      expect(flash[:notice]).to eq('Job deleted successfully.')
      expect(response).to redirect_to(company_jobs_path(company))
    end
  end

  describe 'Private methods' do
    describe '#set_company' do
      context 'when the user is a recruiter' do
        it 'sets the @company variable' do
          get :index, params: { company_id: company.id }
          expect(assigns(:company)).to eq(company)
        end
      end

      context 'when the user is not a recruiter' do
        let(:candidate) { create(:user, :candidate) }

        before do
          sign_in candidate
        end

        it 'sets the @company variable to the company by company_id' do
          get :index, params: { company_id: company.id }
          expect(assigns(:company)).to eq(company)
        end
      end
    end

    describe '#set_job' do
      it 'sets the @job variable' do
        get :show, params: { id: job.id, company_id: company.id }
        expect(assigns(:job)).to eq(job)
      end
    end

    describe '#authorize_recruiter' do
      context 'when the user is a recruiter' do
        it 'does not redirect' do
          get :new, params: { company_id: company.id }
          expect(response).to render_template(:new)
        end
      end

      context 'when the user is not a recruiter' do
        let(:candidate) { create(:user, :candidate) }

        before do
          sign_in candidate
        end

        it 'redirects to the root path with an alert' do
          get :new, params: { company_id: company.id }
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('Access denied.')
        end
      end
    end
  end
end
