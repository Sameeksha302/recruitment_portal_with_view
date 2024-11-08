class EmailNotificationJob < ApplicationJob
  queue_as :default
    # include Sidekiq::Job

    def perform(action, *args)
      case action
      when "job_posted"
        recruiter = User.find(args[0])
        job = Job.find(args[1])
        NotificationMailer.job_posted_email(recruiter, job).deliver_now
      when "application_submitted"
        job_application = JobApplication.find(args[0])
        if job_application.nil?
          Rails.logger.error("JobApplication with ID #{args[0]} not found.")
          return
        end
        ApplicationMailer.notify_recruiter(job_application).deliver_now
        ApplicationMailer.application_confirmation(job_application).deliver_now
      end
    end
end
