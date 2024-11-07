# spec/models/job_spec.rb
require 'rails_helper'

RSpec.describe Job, type: :model do
  # Test presence validations
  it "is valid with a title, description, salary, location, and status" do
    job = build(:job)
    expect(job).to be_valid
  end

  it "is invalid without a title" do
    job = build(:job, title: nil)
    job.valid?
    expect(job.errors[:title]).to include("can't be blank")
  end

  it "is invalid without a description" do
    job = build(:job, description: nil)
    job.valid?
    expect(job.errors[:description]).to include("can't be blank")
  end

  it "is invalid without a salary" do
    job = build(:job, salary: nil)
    job.valid?
    expect(job.errors[:salary]).to include("can't be blank")
  end

  it "is invalid without a location" do
    job = build(:job, location: nil)
    job.valid?
    expect(job.errors[:location]).to include("can't be blank")
  end

  it "is invalid without a status" do
    job = build(:job, status: nil)
    job.valid?
    expect(job.errors[:status]).to include("can't be blank")
  end

  # Test the association with company
  it "belongs to a company" do
    company = create(:company)
    job = create(:job, company: company)

    expect(job.company).to eq(company)
  end

  # Test the association with recruiter (user)
  it "belongs to a recruiter" do
    recruiter = create(:user)
    job = create(:job, user: recruiter)

    expect(job.user).to eq(recruiter)
  end

  # Test the job status enum
  it "has a status of active by default" do
    job = create(:job)
    expect(job.status).to eq("active")
  end

  it "can change status to closed" do
    job = create(:job, status: :active)
    job.closed!
    expect(job.status).to eq("closed")
  end

  # Test scopes
  it "can scope active jobs" do
    active_job = create(:job, status: :active)
    closed_job = create(:job, status: :closed)

    expect(Job.active_jobs).to include(active_job)
    expect(Job.active_jobs).not_to include(closed_job)
  end

  it "can scope closed jobs" do
    active_job = create(:job, status: :active)
    closed_job = create(:job, status: :closed)

    expect(Job.closed_jobs).to include(closed_job)
    expect(Job.closed_jobs).not_to include(active_job)
  end

  # Test dependent destroy on job applications (if applicable)
  it "destroys associated job applications when the job is destroyed" do
    job = create(:job)
    job_application = create(:job_application, job: job)

    expect { job.destroy }.to change { JobApplication.count }.by(-1)
  end
end
