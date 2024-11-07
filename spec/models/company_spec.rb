require 'rails_helper'

RSpec.describe Company, type: :model do
  # Test presence validations
  it "is valid with a name, address, and industry type" do
    company = build(:company)
    expect(company).to be_valid
  end

  it "is invalid without a name" do
    company = build(:company, name: nil)
    company.valid?
    expect(company.errors[:name]).to include("can't be blank")
  end

  it "is invalid without an address" do
    company = build(:company, address: nil)
    company.valid?
    expect(company.errors[:address]).to include("can't be blank")
  end

  it "is invalid without an industry type" do
    company = build(:company, industry_type: nil)
    company.valid?
    expect(company.errors[:industry_type]).to include("can't be blank")
  end

  # Test association with users
  it "can have many users" do
    company = create(:company)
    user1 = create(:user, :recruiter, company: company)  # No need to pass company explicitly
    user2 = create(:user, :recruiter, company: company)

    expect(company.users).to include(user1, user2)
  end

  # Test dependent destroy on users
  it "destroys associated users when the company is destroyed" do
    company = create(:company)
    create(:user, :recruiter, company: company)

    expect { company.destroy }.to change(User, :count).by(-1)
  end

  # Test association with jobs
  it "can have many jobs" do
    company = create(:company)
    job1 = create(:job, company: company)
    job2 = create(:job, company: company)

    expect(company.jobs).to include(job1, job2)
  end

  # Test dependent destroy on jobs
  it "destroys associated jobs when the company is destroyed" do
    company = create(:company)
    job = create(:job, company: company)
  
    expect { company.destroy }.to change(Job, :count).by(-1)
  end
end
