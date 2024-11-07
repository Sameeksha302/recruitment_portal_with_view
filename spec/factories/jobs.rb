# spec/factories/jobs.rb
FactoryBot.define do
  factory :job do
    title { "Software Engineer" }
    description { "Develop and maintain software applications." }
    salary { 70000 }
    location { "New York" }
    status { :active } # Default status

    association :company, factory: :company
    association :user, factory: :user # Make sure you have a user factory

    # Optional: You could define traits for active and closed jobs if needed
    trait :closed do
      status { :closed }
    end
  end
end
