class AddApplicantDetailsToJobApplications < ActiveRecord::Migration[7.2]
  def change
    add_column :job_applications, :applicant_name, :string
    add_column :job_applications, :applicant_email, :string
  end
end
