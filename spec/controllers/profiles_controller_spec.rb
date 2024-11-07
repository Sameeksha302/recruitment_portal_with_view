# spec/controllers/profiles_controller_spec.rb

require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET #show" do
    it "assigns the current user to @user" do
      get :show
      expect(assigns(:user)).to eq(user)
    end

    it "renders the show template" do
      get :show
      expect(response).to render_template(:show)
    end
  end

  describe "GET #edit" do
    it "assigns the current user to @user" do
      get :edit
      expect(assigns(:user)).to eq(user)
    end

    it "renders the edit template" do
      get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the user's profile" do
        patch :update, params: { user: { name: "Updated Name" } }
        user.reload
        expect(user.name).to eq("Updated Name")
      end

      it "redirects to the profile page with a success notice" do
        patch :update, params: { user: { name: "Updated Name" } }
        expect(response).to redirect_to(profile_path)
        expect(flash[:notice]).to eq("Profile updated successfully.")
      end
    end

    context "with invalid attributes" do
      it "does not update the user's profile" do
        original_name = user.name
        patch :update, params: { user: { email: "invalid_email" } }
        user.reload
        expect(user.name).to eq(original_name)
      end

      it "renders the edit template with an alert" do
        patch :update, params: { user: { email: "invalid_email" } }
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to include("Email is invalid")
      end
    end
  end
end
