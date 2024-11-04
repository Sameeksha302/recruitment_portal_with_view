# # # app/controllers/job_applications_controller.rb

# # class JobApplicationsController < ApplicationController
# #     before_action :set_job
  
# #     # Display the application form
# #     def new
# #       @job_application = @job.job_applications.new
# #     end
  
# #     # Handle application submission
# #     def create
# #       @job_application = @job.job_applications.new(job_application_params)
# #       if @job_application.save
# #         flash[:notice] = 'Application submitted successfully.'
# #         redirect_to job_path(@job)
# #       else
# #         flash[:alert] = 'There was an error submitting your application.'
# #         render :new
# #       end
# #     end
  
# #     # Display the list of applications (for admin or company view)
# #     def index
# #       @job_applications = @job.job_applications
# #     end
  
# #     # Show a specific application (for admin or company view)
# #     def show
# #       @job_application = @job.job_applications.find(params[:id])
# #     end
  
# #     # Optional: actions to edit/update or delete applications if required
  
# #     private
  
# #     def set_job
# #       @job = Job.find(params[:job_id])
# #     end
  
# #     def job_application_params
# #       params.require(:job_application).permit(:applicant_name, :applicant_email, :cover_letter, :resume)
# #     end
# #   end
  

# # app/controllers/job_applications_controller.rb
# class JobApplicationsController < ApplicationController
#   before_action :authenticate_user!
#   before_action :set_job, only: [:new, :create]

#   # def new
#   #   @job_application = @job.job_applications.new
#   # end

#   # job_applications_controller.rb
#   def new
#     @job_application = @job.job_applications.new(
#       applicant_name: current_user.name,
#       applicant_email: current_user.email
#     )
#   end


#   def create
#     @job_application = @job.job_applications.new(job_application_params)
#     # @job_application.Candidate = current_user
#     @job_application.candidate_id = current_user.id

    

#     if @job_application.save
#       # Send confirmation email to candidate
      
#       EmailNotificationJob.perform_async('application_submitted', @job_application.id)


#       ApplicationMailer.application_confirmation(@job_application).deliver_now

#       # Send notification to recruiter
#       ApplicationMailer.notify_recruiter(@job_application).deliver_now

#       # redirect_to job_path(@job), notice: 'Application submitted successfully.'
#       redirect_to public_companies_path,notice: 'Application submitted successfully.'
#     else
#       flash.now[:alert] = 'There was an error submitting your application. Please fix the errors below.'
#       render :new
#     end
#   end

#   private

#   def set_job
#     @job = Job.find(params[:job_id])
#   end

#   def job_application_params
#     params.require(:job_application).permit(:applicant_name, :applicant_email, :cover_letter, :resume)
#   end
# end


class JobApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job, only: [:new, :create]

  # Display the application form
  def new
    @job_application = @job.job_applications.new(
      applicant_name: current_user.name,
      applicant_email: current_user.email
    )
  end

  # Handle application submission
  def create
    @job_application = @job.job_applications.new(job_application_params)
    @job_application.candidate_id = current_user.id

    if @job_application.save
      # Send confirmation email to 
      debugger
      begin
        # ApplicationMailer.application_confirmation(@job_application).deliver_now
        EmailNotificationJob.perform_async('application_submitted', @job_application.id)

        # Send notification to recruiter
        # ApplicationMailer.notify_recruiter(@job_application).deliver_now

        # redirect_to job_path(@job), notice: 'Application submitted successfully.'
        redirect_to new_company_path,notice: 'Application submitted successfully.'
      rescue StandardError => e
        Rails.logger.error("Failed to send email: #{e.message}")
        flash[:alert] = 'Application submitted, but there was an issue sending confirmation emails.'
        redirect_to job_path(@job)
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
