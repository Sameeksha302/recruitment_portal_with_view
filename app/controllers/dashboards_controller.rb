class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @company = @user.company
    case @user.role
    when "Admin"
      redirect_to new_company_path
    when "Recruiter"
       @job = @company.jobs.new
       render "jobs/new"
    when "Candidate"
      redirect_to companies_path
    end
  end
end
