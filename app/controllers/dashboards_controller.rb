class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @company = @user.company # Get the associated company

    case @user.role
    when "Admin"
      # Redirect admins to create a new company or display an admin dashboard
      redirect_to new_company_path
    when "Recruiter"
      if @company
        # If the recruiter has a company, show jobs associated with that company
        @jobs = @company.jobs
      else
        # If no company is associated, redirect to a page to create a new company
        redirect_to new_company_path, alert: "You need to create a company first."
      end
    when "Candidate"
      # Candidates see the companies page, potentially with job listings
      redirect_to companies_path
    else
      redirect_to root_path, alert: "Unrecognized role"
    end
  end
end
