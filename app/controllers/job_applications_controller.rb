# app/controllers/job_applications_controller.rb

class JobApplicationsController < ApplicationController
    before_action :set_job
  
    # Display the application form
    def new
      @job_application = @job.job_applications.new
    end
  
    # Handle application submission
    def create
      @job_application = @job.job_applications.new(job_application_params)
      if @job_application.save
        flash[:notice] = 'Application submitted successfully.'
        redirect_to job_path(@job)
      else
        flash[:alert] = 'There was an error submitting your application.'
        render :new
      end
    end
  
    # Display the list of applications (for admin or company view)
    def index
      @job_applications = @job.job_applications
    end
  
    # Show a specific application (for admin or company view)
    def show
      @job_application = @job.job_applications.find(params[:id])
    end
  
    # Optional: actions to edit/update or delete applications if required
  
    private
  
    def set_job
      @job = Job.find(params[:job_id])
    end
  
    def job_application_params
      params.require(:job_application).permit(:applicant_name, :applicant_email, :cover_letter, :resume)
    end
  end
  