require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }  # Make sure you have a user factory
  let!(:company) { create(:company) } # Assuming you have a Company factory set up

  before do
    sign_in user  # This will sign in the user for all tests
  end

  describe 'GET #index' do
    it 'returns a success response and assigns @companies' do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:companies)).to include(company)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: company.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:company)).to eq(company)
    end
  end

  describe 'GET #new' do
    it 'returns a success response and initializes a new company' do
      get :new
      expect(response).to have_http_status(:success)
      expect(assigns(:company)).to be_a_new(Company)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) { { name: 'New Company', address: '123 Main St', industry_type: 'Tech' } }

      it 'creates a new company and redirects' do
        expect {
          post :create, params: { company: valid_attributes }
        }.to change(Company, :count).by(1)

        expect(response).to redirect_to(Company.last)
        expect(flash[:notice]).to eq('Company was successfully created.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { name: '', address: '123 Main St' } } # Missing required fields

      it 'does not create a new company and renders the new template' do
        expect {
          post :create, params: { company: invalid_attributes }
        }.to change(Company, :count).by(0)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: company.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:company)).to eq(company)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:new_attributes) { { name: 'Updated Company' } }

      it 'updates the company and redirects' do
        patch :update, params: { id: company.id, company: new_attributes }
        company.reload
        expect(company.name).to eq('Updated Company')
        expect(response).to redirect_to(company)
        expect(flash[:notice]).to eq('Company was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { name: '' } } # Invalid parameters

      it 'does not update the company and renders the edit template' do
        patch :update, params: { id: company.id, company: invalid_attributes }
        company.reload
        expect(company.name).not_to eq('')
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested company and redirects' do
      expect {
        delete :destroy, params: { id: company.id }
      }.to change(Company, :count).by(-1)

      expect(response).to redirect_to(companies_path)
      expect(flash[:notice]).to eq('Company was successfully deleted.')
    end
  end
end
