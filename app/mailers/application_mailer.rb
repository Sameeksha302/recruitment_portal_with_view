# class ApplicationMailer < ActionMailer::Base
#   default from: "from@example.com"
#   layout "mailer"
# end


# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: "sameekshasingh951@gmail.com"
  layout "mailer"
  def application_confirmation(job_application)
    @job_application = job_application
    mail(to: @job_application.Candidate.email, subject: 'Application Confirmation')
  end

  def notify_recruiter(job_application)
    @job_application = job_application
    @job = @job_application.job  # Set @job from @job_application

    if @job && @job.Recruiter
      recruiter_email = @job.Recruiter.email
      mail(to: recruiter_email, subject: 'New Job Application Submitted')
    else
      Rails.logger.error("No recruiter or job found for application ID: #{job_application.id}")
    end
  end
end
