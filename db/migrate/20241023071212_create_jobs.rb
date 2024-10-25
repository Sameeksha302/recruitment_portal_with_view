class CreateJobs < ActiveRecord::Migration[7.2]
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :description
      t.decimal :salary
      t.string :location
      t.integer :status
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
