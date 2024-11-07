require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:role) }

    it { is_expected.to allow_value("user@example.com").for(:email) }
    it { is_expected.not_to allow_value("invalid_email").for(:email) }

    context 'email uniqueness' do
      before { create(:user, email: "test@example.com") }
    
      it 'does not allow duplicate email (case insensitive)' do
        new_user = build(:user, email: "TEST@example.com")
        expect(new_user).not_to be_valid
        expect(new_user.errors[:email]).to include("has already been taken")
      end
    end

    context 'when role is Recruiter' do
      subject { build(:user, :recruiter) }

      it { is_expected.to validate_presence_of(:company_name) }
    

      it 'requires company_name to be present' do
        subject.company_name = nil
        expect(subject).not_to be_valid
        expect(subject.errors[:company_name]).to include("can't be blank")
      end
    end

    context 'when role is Admin' do
      subject { build(:user, :admin) }

      it 'is valid without a company_name' do
        subject.company_name = nil
        expect(subject).to be_valid
      end

      it 'is valid without a company_id' do
        subject.company_id = nil
        expect(subject).to be_valid
      end
    end

    context 'when role is Candidate' do
      subject { build(:user, :candidate) }

      it 'is valid without a company_name' do
        subject.company_name = nil
        expect(subject).to be_valid
      end

      it 'is valid without a company_id' do
        subject.company_id = nil
        expect(subject).to be_valid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:company).optional }
    it { is_expected.to have_many(:jobs).dependent(:destroy) }
  end

  describe 'roles' do
    it 'has a default role of Candidate' do
      user = User.new(email: "test@example.com", password: "password", name: "Test User")
      expect(user.role).to eq("Candidate")
    end
  end

  describe 'callbacks' do
    it 'sets a default role if none is provided' do
      user = User.create(email: "default@example.com", password: "password", name: "Test User")
      expect(user.role).to eq("Candidate")
    end

    it 'sets company_id after creation if company_name is present' do
      company = create(:company)
      user = create(:user, :recruiter, company_name: company.name)
      expect(user.company_id).to eq(company.id)
    end
  end
end
