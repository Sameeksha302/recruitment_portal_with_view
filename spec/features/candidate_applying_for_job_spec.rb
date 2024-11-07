require 'rails_helper'


RSpec.feature "Candidate Applying for a Job", type: :feature do
  let(:candidate) { create(:user, :candidate) }
  let(:company) { create(:company) }
  let(:job) { create(:job, company: company) }

  before do
    sign_in candidate
  end

  scenario "Candidate applies for a job successfully" do
    visit company_job_path(company, job)  # Use correct path helper

    # Ensure the Apply button is visible for the candidate
    expect(page).to have_link('Apply', href: new_job_job_application_path(job))  # Ensure the link is correctly generated

    click_link 'Apply'  # Click the 'Apply' link

    expect(page).to have_current_path(new_job_job_application_path(job))  # Corrected path

    # Fill in the application form
    fill_in "Full Name", with: candidate.name
    fill_in "Email", with: candidate.email
    fill_in "Cover Letter", with: "I am very interested in this position."
    attach_file "Resume", Rails.root.join("spec", "support", "resume.pdf")

    click_button "Submit Application"
    expect(page).to have_current_path(public_companies_path)
    expect(page).to have_content("Application submitted successfully")
  end

  scenario "Candidate fails to apply for a job due to validation errors" do
    visit company_job_path(company, job)
  
    expect(page).to have_link('Apply', href: new_job_job_application_path(job))
  
    click_link 'Apply'
  
    expect(page).to have_current_path(new_job_job_application_path(job))
  
    # Leave fields blank to trigger validation errors
    fill_in "Cover Letter", with: ""
  
    click_button "Submit Application"
  
    # Check for validation error messages
    expect(page).to have_text("Please fix the following errors:")
    expect(page).to have_text("Cover letter can't be blank")
    expect(page).to have_text("Resume can't be blank")
  end
  
end
