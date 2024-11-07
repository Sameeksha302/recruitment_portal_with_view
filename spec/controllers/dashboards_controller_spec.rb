require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  # Let variables for each user type
  let(:company) { create(:company, name: "Test Company", address: "1234 Test St") }  # Create a valid company
  let(:admin_user) { create(:user, :admin) }  # Admin user with no company
  let(:recruiter_with_company) { create(:user, :recruiter, company: company) }  # Recruiter user with a company
  let(:candidate_user) { create(:user, :candidate) }  # Candidate user with no company

  describe "GET #index" do
    context "when the user is an admin" do
      before { sign_in admin_user }

      it "redirects to the new company page" do
        get :index
        expect(response).to redirect_to(new_company_path)
      end
    end

    context "when the user is a recruiter with a company" do
      before { sign_in recruiter_with_company }

      it "renders the new job form" do
        get :index
        expect(response).to render_template('jobs/new')
        expect(assigns(:job)).to be_a_new(Job)  # Verifying that a new Job is initialized
      end
    end

    context "when the user is a candidate" do
      before { sign_in candidate_user }

      it "redirects to the companies page" do
        get :index
        expect(response).to redirect_to(companies_path)
      end
    end
  end
end
