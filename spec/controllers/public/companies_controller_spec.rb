# spec/controllers/public/companies_controller_spec.rb

require 'rails_helper'

RSpec.describe Public::CompaniesController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { create(:user) }  # Make sure you have a user factory

  before do
    sign_in user  # This will sign in the user for all tests
  end
  describe 'GET #index' do
    let!(:company_with_jobs) { create(:company) }
    let!(:company_without_jobs) { create(:company) }
    let!(:job) { create(:job, company: company_with_jobs, title: 'Software Engineer', location: 'New York', salary: 100000) }
    let!(:closed_job) { create(:job, company: company_with_jobs, title: 'Project Manager', location: 'Remote', salary: 80000, status: :closed) }

    context 'when filters are applied' do
      before do
        get :index, params: {
          company_name: company_with_jobs.name,
          title: job.title,
          location: job.location,
          min_salary: 50000,
          max_salary: 150000
        }
      end

      it 'assigns @filters_applied as true' do
        expect(assigns(:filters_applied)).to be true
      end

      it 'assigns @companies with matching companies' do
        expect(assigns(:companies)).to include(company_with_jobs)
        expect(assigns(:companies)).not_to include(company_without_jobs)
      end

      it 'assigns @filtered_jobs with matching jobs' do
        expect(assigns(:filtered_jobs)).to have_key(company_with_jobs.id)
        expect(assigns(:filtered_jobs)[company_with_jobs.id]).to include(job)
      end

      it 'does not include closed jobs in the filtered jobs' do
        expect(assigns(:filtered_jobs)[company_with_jobs.id]).not_to include(closed_job)
      end
    end

    context 'when no filters are applied' do
      before do
        get :index
      end

      it 'assigns @filters_applied as false' do
        expect(assigns(:filters_applied)).to be false
      end

      it 'assigns @companies with all companies' do
        expect(assigns(:companies)).to include(company_with_jobs)
        expect(assigns(:companies)).to include(company_without_jobs)
      end

      it 'includes jobs for all companies' do
        expect(assigns(:companies).flat_map(&:jobs)).to include(job)
      end
    end
  end
end
