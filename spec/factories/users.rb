FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    name { "John Doe" }
    password { "password" }
    role { :Candidate }  # Default role

    # Trait for recruiters (link to existing company via company_id)
    trait :recruiter do
      role { :Recruiter }
      company { create(:company) }  # Creates and associates a company
      company_name { company&.name } # Only set company_name if company is not nil
    end

    # Trait for admins (admins should not have a company associated)
    trait :admin do
      role { :Admin }
      company { nil }  # Admins should not have a company associated
      company_name { nil }  # Ensure company_name is also nil for admins
    end

    # Trait for candidates (candidates should not have a company associated)
    trait :candidate do
      role { :Candidate }
      company { nil }  # Candidates should not have a company associated
      company_name { nil }  # Ensure company_name is nil for candidates
    end
  end
end