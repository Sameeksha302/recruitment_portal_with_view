class NotificationMailer < ApplicationMailer
    def job_posted_email(recruiter, job)
      @recruiter = recruiter
      @job = job
      mail(to: @recruiter.email, subject: 'Job Posted Confirmation')
    end
  
    def application_received_email(recruiter, candidate, job)
      @recruiter = recruiter
      @candidate = candidate
      @job = job
      mail(to: @recruiter.email, subject: 'New Job Application Received')
    end
end
  

# NotificationMailer.job_posted_email(current_user, @job).deliver_later
