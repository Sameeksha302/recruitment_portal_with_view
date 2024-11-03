class RemoveUserIdFromJobApplications < ActiveRecord::Migration[7.2]
  def change
    remove_column :job_applications, :user_id, :bigint
  end
end
