class AddCandidateIdToJobApplications < ActiveRecord::Migration[7.2]
  def change
    add_column :job_applications, :candidate_id, :integer
  end
end
