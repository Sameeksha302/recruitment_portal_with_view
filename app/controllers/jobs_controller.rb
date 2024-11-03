# class JobsController < ApplicationController
#   before_action :authenticate_user!
#   before_action :set_company
#   before_action :set_job, only: [:show, :edit, :update, :destroy]
#   before_action :authorize_recruiter, only: [:new, :create, :edit, :update, :destroy]

#   def index
#     @jobs = @company.jobs # Filter by the company’s jobs

#     # Uncomment and implement search filters as needed
#     # if params[:title].present?
#     #   @jobs = @jobs.where('title ILIKE ?', "%#{params[:title]}%")
#     # end
#     # if params[:location].present?
#     #   @jobs = @jobs.where('location ILIKE ?', "%#{params[:location]}%")
#     # end
#     # if params[:min_salary].present?
#     #   @jobs = @jobs.where('salary >= ?', params[:min_salary])
#     # end
#     # if params[:max_salary].present?
#     #   @jobs = @jobs.where('salary <= ?', params[:max_salary])
#     # end

#     @jobs = @jobs.includes(:company) # Eager load companies
#   end

#   def show
#     unless @job
#       redirect_to company_jobs_path(@company), alert: 'Job not found.'
#     end
#   end

#   def new
#     @job = @company.jobs.new
#   end

#   def create
#     @job = @company.jobs.new(job_params)
#     if @job.save
#       redirect_to company_jobs_path(@company), notice: 'Job created successfully.'
#     else
#       render :new
#     end
#   end

#   def edit; end

#   def update
#     if @job.update(job_params)
#       redirect_to company_jobs_path(@company), notice: 'Job updated successfully.'
#     else
#       render :edit
#     end
#   end

#   def destroy
#     @job.destroy
#     redirect_to company_jobs_path(@company), notice: 'Job deleted successfully.'
#   end

#   private

#   def set_company
#     @company = current_user.company
#     redirect_to companies_path, alert: 'Company not found.' unless @company
#   end

#   def set_job
#     @job = @company.jobs.find_by(id: params[:id])
#     redirect_to company_jobs_path(@company), alert: 'Job not found.' unless @job
#   end

#   def authorize_recruiter
#     redirect_to root_path, alert: 'Access denied.' unless current_user.recruiter?
#   end

#   def job_params
#     params.require(:job).permit(:title, :description, :salary, :location, :status)
#   end
# end


class JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :authorize_recruiter, only: [:new, :create, :edit, :update, :destroy]

  def index
    @jobs = @company.jobs # Filter by the company’s jobs
    @jobs = @jobs.includes(:company) # Eager load companies

    # Uncomment and implement search filters as needed
    # if params[:title].present?
    #   @jobs = @jobs.where('title ILIKE ?', "%#{params[:title]}%")
    # end
    # if params[:location].present?
    #   @jobs = @jobs.where('location ILIKE ?', "%#{params[:location]}%")
    # end
    # if params[:min_salary].present?
    #   @jobs = @jobs.where('salary >= ?', params[:min_salary])
    # end
    # if params[:max_salary].present?
    #   @jobs = @jobs.where('salary <= ?', params[:max_salary])
    # end
  end

  def show; end

  def new
    @job = @company.jobs.new
  end

  def create
    @job = @company.jobs.new(job_params)
    @job.Recruiter = current_user  
    if @job.save
      # EmailNotificationJob.perform_async('job_posted', current_user.id, @job.id)
      # In your controller or job creation callback
      NotificationMailer.job_posted_email(current_user, @job).deliver_now
      flash[:notice] = "Job created successfully."
      redirect_to company_jobs_path(@company), notice: 'Job created successfully.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @job.update(job_params)
      redirect_to company_jobs_path(@company), notice: 'Job updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @job.destroy
    redirect_to company_jobs_path(@company), notice: 'Job deleted successfully.'
  end

  private

  def set_company
    @company = Company.find_by(id: params[:company_id])
    if @company.nil? || (current_user.Recruiter? && current_user.company != @company)
      redirect_to companies_path, alert: 'Access denied or company not found.'
    end
  end

  def set_job
    @job = @company.jobs.find_by(id: params[:id])
    redirect_to company_jobs_path(@company), alert: 'Job not found.' unless @job
  end

  def authorize_recruiter
    redirect_to root_path, alert: 'Access denied.' unless current_user.Recruiter?
  end

  def job_params
    params.require(:job).permit(:title, :description, :salary, :location, :status,:company_id)
  end
end
