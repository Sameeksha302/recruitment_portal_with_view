class CreateCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :industry_type

      t.timestamps
    end
  end
end
