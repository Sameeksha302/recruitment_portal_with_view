# class JobsController < ApplicationController
#   before_action :authenticate_user!
#   before_action :set_company,except: [:new]
#   before_action :set_job, only: [:show, :edit, :update, :destroy]
#   before_action :authorize_recruiter, only: [:new, :create, :edit, :update, :destroy]

#   def index
#     # @jobs = @company.jobs # Filter by the company’s jobs
#     # @jobs = @jobs.includes(:company) # Eager load companies

#     if current_user.Recruiter?
#       @jobs = @company.jobs # Get jobs associated with the user's company
#     else
#       @jobs = Job.all # Or handle other roles accordingly
#     end
#   end

#   def show; end

#   def new
#     if current_user.Recruiter?
#       @company = current_user.company
#       @job = @company.jobs.new
#       # @company.jobs.includes(:company)
#     else
#       @job = Job.new
#     end
#   end
  

#   def create
#     @job = @company.jobs.new(job_params)
#     @job.Recruiter = current_user  
#     if @job.save
#       # EmailNotificationJob.perform_async('job_posted', current_user.id, @job.id)
#       # In your controller or job creation callback
#       # NotificationMailer.job_posted_email(current_user, @job).deliver_now
#       begin
#         NotificationMailer.job_posted_email(current_user, @job).deliver_now
#       rescue StandardError => e
#         Rails.logger.error("Failed to send job posted email: #{e.message}")
#         flash[:alert] = 'Job created, but there was an issue sending the email notification.'
#       end
      
#       flash[:notice] = "Job created successfully."
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
#     @company = Company.find_by(id: params[:company_id])
#     if @company.nil? || (current_user.Recruiter? && current_user.company != @company)
#       redirect_to companies_path, alert: 'Access denied or company not found.'
#     end
#   end

#   def set_job
#     @job = @company.jobs.find_by(id: params[:id])
#     redirect_to company_jobs_path(@company), alert: 'Job not found.' unless @job
#   end

#   def authorize_recruiter
#     redirect_to root_path, alert: 'Access denied.' unless current_user.Recruiter?
#   end

#   def job_params
#     params.require(:job).permit(:title, :description, :salary, :location, :status,:company_id)
#     # params.require(:job).permit(:title, :description, :salary, :location, :status)
#   end
# end

class JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, except: [:new]
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :authorize_recruiter, only: [:new, :create, :edit, :update, :destroy]

  def index
    if current_user.Recruiter?
      @jobs = @company.jobs.includes(:company) # Eager load the associated company
    else
      @jobs = Job.all # Or handle other roles accordingly
    end
  end
  def show; end

  def new
    if current_user.Recruiter?
      @company = current_user.company
      @job = @company.jobs.new # Initialize a new job for the user's company
    else
      @job = Job.new # For other roles, you might need a different approach
    end
  end

  def create
    @job = current_user.company.jobs.new(job_params) # Use current user's company to build the job
    # @job.Recruiter = current_user # Assign the current user as the recruiter 
    @job.recruiter_id = current_user.id 
    if @job.save
      begin
        # NotificationMailer.job_posted_email(current_user, @job).deliver_now
        EmailNotificationJob.perform_async('job_posted', @job.recruiter_id, @job.id)
        # EmailNotificationJob.perform_later('job_posted', @job.recruiter_id, @job.id)
      rescue StandardError => e
        Rails.logger.error("Failed to send job posted email: #{e.message}")
        flash[:alert] = 'Job created, but there was an issue sending the email notification.'
      end
      flash[:notice] = "Job created successfully."
      redirect_to company_jobs_path(@company), notice: 'Job created successfully.'
    else
      render :new
    end
  end

  def edit; 
  end

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

  # def set_company
  #   @company = Company.find_by(id: params[:company_id])
  #   if @company.nil? || (current_user.Recruiter? && current_user.company != @company)
  #     redirect_to companies_path, alert: 'Access denied or company not found.'
  #   end
  # end

  def set_company
    # If the current user is a Recruiter, set @company to the user's associated company
    if current_user.Recruiter?
      @company = current_user.company
      redirect_to companies_path, alert: 'Access denied or company not found.' if @company.nil?
    else
      # Otherwise, find the company by the provided company_id parameter
      @company = Company.find_by(id: params[:company_id])
      redirect_to companies_path, alert: 'Access denied or company not found.' if @company.nil?
    end
  end
  

  def set_job
    @job = @company.jobs.find_by(id: params[:id])
    redirect_to company_jobs_path(@company), alert: 'Job not found.' unless @job.present?
  end

  def authorize_recruiter
    redirect_to root_path, alert: 'Access denied.' unless current_user.Recruiter?
  end

  def job_params
    params.require(:job).permit(:title, :description, :salary, :location, :status,:company_id)
  end
end
