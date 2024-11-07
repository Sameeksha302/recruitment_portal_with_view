class Public::CompaniesController < ApplicationController
  def index
    # Check if any search parameters are present
    @filters_applied = params[:company_name].present? || params[:title].present? || params[:location].present? || params[:min_salary].present? || params[:max_salary].present?

    if @filters_applied
      # Apply filters and fetch only matching companies and jobs
      @companies = Company.joins(:jobs).distinct
      @companies = @companies.where("name ILIKE ?", "%#{params[:company_name]}%") if params[:company_name].present?
      @filtered_jobs = {}

      @companies.each do |company|
        jobs = company.jobs.active
        jobs = jobs.where("title ILIKE ?", "%#{params[:title]}%") if params[:title].present?
        jobs = jobs.where("location ILIKE ?", "%#{params[:location]}%") if params[:location].present?
        jobs = jobs.where("salary >= ?", params[:min_salary]) if params[:min_salary].present?
        jobs = jobs.where("salary <= ?", params[:max_salary]) if params[:max_salary].present?
        @filtered_jobs[company.id] = jobs if jobs.any?
      end

      # Filter out companies with no matching jobs
      @companies = @companies.select { |company| @filtered_jobs[company.id].present? }
    else
      # If no filters are applied, fetch all companies with active jobs
      @companies = Company.all.includes(:jobs)
    end
  end
end

