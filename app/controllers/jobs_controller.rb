class JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, except: [:new]
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :authorize_recruiter, only: [:new, :create, :edit, :update, :destroy]

  def index
    if current_user.Recruiter?
      @jobs = @company.jobs.includes(:company) 
    else
      @jobs = Job.all 
    end
  end
  def show; end

  def new
    if current_user.Recruiter?
      @company = current_user.company
      @job = @company.jobs.new 
    else
      @job = Job.new 
    end
  end

  def create
    @job = current_user.company.jobs.new(job_params) 
    @job.recruiter_id = current_user.id 
    if @job.save
      begin
        EmailNotificationJob.perform_async('job_posted', @job.recruiter_id, @job.id)
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

  def set_company
    if current_user.Recruiter?
      @company = current_user.company
      redirect_to companies_path, alert: 'Access denied or company not found.' if @company.nil?
    else
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
