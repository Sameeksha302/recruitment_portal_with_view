# class ProfilesController < ApplicationController
#   before_action :authenticate_user!
#   before_action :check_recruiter_permissions, only: [:edit, :update]

#   def show
#     @user = current_user
#   end

#   def edit
#     @user = current_user
#   end

#   def update
#     @user = current_user
#     if @user.update(profile_params)
#       redirect_to profile_path, notice: "Profile updated successfully."
#     else
#       render :edit, alert: "There was an error updating your profile."
#     end
#   end

#   private

#   def profile_params
#     params.require(:user).permit(:email, :name, :company_name, :role)
#   end
#   def check_recruiter_permissions
#     unless current_user.Admin? || current_user.Recruiter? || current_user.Candidate?
#       redirect_to root_path, alert: 'Access denied.'
#     end
#   end
  
# end


class ProfilesController < ApplicationController
  before_action :authenticate_user!
  # before_action :check_recruiter_permissions, only: [:edit, :update]
  before_action :set_user

  def show; end

  def edit; end

  def update
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def profile_params
    params.require(:user).permit(:email, :name, :company_name) # Exclude :role if not updatable by users
  end

  # def check_recruiter_permissions
  #   unless current_user.Admin? || current_user.Recruiter? || current_user.Candidate?
  #     redirect_to root_path, alert: 'Access denied.'
  #   end
  # end
end
