class JobApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job, only: [ :new, :create ]

  def new
    @job_application = @job.job_applications.new(
      applicant_name: current_user.name,
      applicant_email: current_user.email
    )
  end

  def create
    @job_application = @job.job_applications.new(job_application_params)
    @job_application.candidate_id = current_user.id

    if @job_application.save
      begin
        # ApplicationMailer.application_confirmation(@job_application).deliver_now
        flash[:notice] = "Application submitted successfully."
        EmailNotificationJob.perform_async("application_submitted", @job_application.id)
        redirect_to public_companies_path
      rescue StandardError => e
        flash[:alert] = "Application submitted, but there was an issue sending confirmation emails."
        redirect_to public_companies_path
      end
    else
      render :new
    end
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end

  def job_application_params
    params.require(:job_application).permit(:applicant_name, :applicant_email, :cover_letter, :resume)
  end
end
