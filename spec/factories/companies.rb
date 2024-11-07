# # spec/factories/companies.rb

# FactoryBot.define do
#     factory :company do
#       name { "Example Company" }
#       address { "123 Main St, Anytown, USA" }
#       industry_type { "Technology" }
  
#       # You can also create associated users or jobs within the company factory
#       # Example of creating associated users (optional):
#       after(:create) do |company|
#         create_list(:user, 3, company: company)
#       end
#     end
#   end


FactoryBot.define do
  factory :company do
    name { "Example Company" }
    address { "123 Main St, Anytown, USA" }
    industry_type { "Technology" }

    # Optional association with a user (if needed)
    # association :user, factory: :user

    # You may define users or jobs associated with this company in specific tests as needed.
  end
end
