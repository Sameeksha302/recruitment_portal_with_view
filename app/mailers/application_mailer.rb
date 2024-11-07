class ApplicationMailer < ActionMailer::Base
  default from: "sameekshasingh951@gmail.com"
  layout "mailer"
  def application_confirmation(job_application)
    @job_application = job_application
    @job_application_user = User.find_by(id: @job_application.candidate_id)
    mail(to: @job_application_user.email, subject: "Application Confirmation")
  end

  def notify_recruiter(job_application)
    @job_application = job_application
    @job = @job_application.job

    if @job && @job.user.present?
      recruiter_email = @job.user.email
      mail(to: recruiter_email, subject: "New Job Application Submitted")
    else
      Rails.logger.error("No recruiter or job found for application ID: #{job_application.id}")
    end
  end
end
