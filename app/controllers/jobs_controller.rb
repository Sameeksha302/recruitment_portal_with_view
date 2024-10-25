class JobsController < ApplicationController
    # Ensure that the user is logged in, and possibly authorized (depending on your app's logic)
    before_action :set_job, only: [:show, :edit, :update, :destroy]
  
    # GET /jobs
    def index
      @jobs = Job.all
      render json: @jobs # Optional: Change this to render a view
    end
  
    # GET /jobs/:id
    def show
      render json: @job # Optional: Change this to render a view
    end
  
    # GET /jobs/new
    def new
      @job = Job.new
    end
  
    # POST /jobs
    def create
      @job = Job.new(job_params)
      if @job.save
        redirect_to @job, notice: 'Job was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    # GET /jobs/:id/edit
    def edit
    end
  
    # PATCH/PUT /jobs/:id
    def update
      if @job.update(job_params)
        redirect_to @job, notice: 'Job was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    # DELETE /jobs/:id
    def destroy
      @job.destroy
      redirect_to jobs_url, notice: 'Job was successfully deleted.'
    end
  
    private
  
    # Set job for the actions that require it (show, edit, update, destroy)
    def set_job
      @job = Job.find(params[:id])
    end
  
    # Strong parameters to permit the job attributes
    def job_params
      params.require(:job).permit(:title, :description, :location, :company_name, :salary)
    end
  end
  