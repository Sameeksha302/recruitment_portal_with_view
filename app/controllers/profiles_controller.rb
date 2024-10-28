class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_recruiter_permissions, only: [:edit, :update]

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit, alert: "There was an error updating your profile."
    end
  end

  private

  def profile_params
    params.require(:user).permit(:email, :name, :company_name, :role)
  end
  def check_recruiter_permissions
    unless current_user.Admin? || current_user.Recruiter? || current_user.Candidate?
      redirect_to root_path, alert: 'Access denied.'
    end
  end
  
end
