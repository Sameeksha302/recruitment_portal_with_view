class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :role, :company_name, :name, :company_id ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :role, :company_name, :name, :company_id ])
  end

  private

  def log_user_activity
    Rails.logger.info("User Activity: #{current_user&.email} accessed #{request.path}")
  end
end
