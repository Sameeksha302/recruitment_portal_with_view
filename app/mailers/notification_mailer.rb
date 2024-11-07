class NotificationMailer < ApplicationMailer
  default from: "sameekshasingh951@gmail.com"
  layout "mailer"
    def job_posted_email(recruiter, job)
      @recruiter = recruiter
      @job = job
      mail(to: @recruiter.email, subject: "Job Posted Confirmation")
    end

    def application_received_email(recruiter, candidate, job)
      @recruiter = recruiter
      @candidate = candidate
      @job = job
      mail(to: @recruiter.email, subject: "New Job Application Received")
    end
end
