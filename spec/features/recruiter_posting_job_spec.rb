require 'rails_helper'

RSpec.feature "Recruiter Posting a Job", type: :feature do
  let(:recruiter) { create(:user, :recruiter) }  # Assuming you have a recruiter trait in the user factory

  scenario 'Recruiter posts a job successfully' do
    sign_in recruiter

    visit new_job_path  # This should be the correct path for posting a new job

    fill_in 'Title', with: 'Software Engineer'
    fill_in 'Description', with: 'A great job opportunity.'
    fill_in 'Location', with: 'New York'
    fill_in 'Salary', with: 100000
    click_button 'Create Job'  # Change this to match the button text

    expect(page).to have_text('Job created successfully.')  # Corrected to match actual success message
    expect(current_path).to eq(company_jobs_path(recruiter.company))  # Assuming it redirects to the jobs list page
  end

  scenario 'Recruiter fails to post a job due to validation errors' do
    sign_in recruiter

    visit new_job_path

    fill_in 'Title', with: ''
    fill_in 'Description', with: ''
    fill_in 'Location', with: ''
    fill_in 'Salary', with: ''
    click_button 'Create Job'

    # Check that the error messages are displayed on the page
    expect(page).to have_text("Title can't be blank")
    expect(page).to have_text("Description can't be blank")
    expect(page).to have_text("Location can't be blank")
    expect(page).to have_text("Salary can't be blank")  # Added salary validation check
  end
end
