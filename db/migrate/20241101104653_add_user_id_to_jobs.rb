class AddUserIdToJobs < ActiveRecord::Migration[7.2]
  def change
    add_column :jobs, :recruiter_id, :integer
  end
end
