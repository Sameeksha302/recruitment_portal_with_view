class Public::CompaniesController < ApplicationController
  def index
    # Start with an empty result set for jobs if any parameter is provided
    if search_params_present?
      @jobs = Job.where(status: :active) # Only active jobs

      # Apply filters on jobs if parameters are present
      @jobs = @jobs.where('title ILIKE ?', "%#{params[:title]}%") if params[:title].present?
      @jobs = @jobs.where('location ILIKE ?', "%#{params[:location]}%") if params[:location].present?
      @jobs = @jobs.where('salary >= ?', params[:min_salary]) if params[:min_salary].present?
      @jobs = @jobs.where('salary <= ?', params[:max_salary]) if params[:max_salary].present?

      # Get company IDs from filtered jobs
      company_ids_from_jobs = @jobs.select(:company_id).distinct

      # Filter companies based on jobs and company name if provided
      @companies = Company.where(id: company_ids_from_jobs)
      @companies = @companies.where('name ILIKE ?', "%#{params[:company_name]}%") if params[:company_name].present?

      # Eager load jobs to optimize queries
      @companies = @companies.includes(:jobs)
    else
      # If no search parameters are given, don't show any companies/jobs
      @companies = Company.none
    end
  end

  private

  # Helper method to check if any search parameters are present
  def search_params_present?
    params[:company_name].present? || params[:title].present? || params[:location].present? ||
    params[:min_salary].present? || params[:max_salary].present?
  end
end
