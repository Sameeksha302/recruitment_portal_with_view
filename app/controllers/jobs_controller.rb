class JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_job, only: [:edit, :update, :destroy]
  before_action :authorize_recruiter

  def index
    @jobs = @company.jobs # Start with jobs only from the user's company

    # # Implement search filters
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

    # @jobs = @jobs.includes(:company) # Eager load companies to reduce queries
  end

  def show
    @job = @company.jobs.find(params[:id])
  end

  def new
    @job = @company.jobs.new
  end

  def create
    @job = @company.jobs.new(job_params)
    if @job.save
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
    @company = current_user.company
  end

  def set_job
    @job = @company.jobs.find(params[:id])
  end

  def authorize_recruiter
    redirect_to root_path, alert: 'Access denied.' unless current_user.Recruiter?
  end

  def job_params
    params.require(:job).permit(:title, :description, :salary, :location, :status)
  end
end
