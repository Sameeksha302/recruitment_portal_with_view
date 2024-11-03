# class Public::CompaniesController < ApplicationController
#   def index
#     @filters_applied = search_params_present? # Set the variable accessible to the view

#     if @filters_applied
#       # Start by filtering active jobs based on search parameters
#       @jobs = Job.active.joins(:company)

#       # Apply filters based on search parameters
#       @jobs = @jobs.where('companies.name ILIKE ?', "%#{params[:company_name]}%") if params[:company_name].present?
#       @jobs = @jobs.where('jobs.title ILIKE ?', "%#{params[:title]}%") if params[:title].present?
#       @jobs = @jobs.where('jobs.location ILIKE ?', "%#{params[:location]}%") if params[:location].present?
#       @jobs = @jobs.where('jobs.salary >= ?', params[:min_salary]) if params[:min_salary].present?
#       @jobs = @jobs.where('jobs.salary <= ?', params[:max_salary]) if params[:max_salary].present?

#       # Filter companies based on the filtered jobs' company IDs
#       company_ids_from_jobs = @jobs.select(:company_id).distinct
#       @companies = Company.where(id: company_ids_from_jobs).includes(:jobs)

#       # Group the filtered jobs by company ID for display
#       @filtered_jobs = @jobs.group_by(&:company_id)
#     else
#       # Show all companies with their active jobs
#       @companies = Company.includes(:jobs).where(jobs: { status: :active })
#     end
#   end

#   private

#   # Check if any search parameters are provided
#   def search_params_present?
#     params[:company_name].present? || params[:title].present? || params[:location].present? ||
#     params[:min_salary].present? || params[:max_salary].present?
#   end
# end


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
