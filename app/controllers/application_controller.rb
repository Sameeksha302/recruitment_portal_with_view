# class ApplicationController < ActionController::Base
#   # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
#   allow_browser versions: :modern
#   # before_action :configure_permitted_parameters, if: :devise_controller?

#   # protected

#   # def configure_permitted_parameters
#   #   devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
#   #   devise_parameter_sanitizer.permit(:account_update, keys: [:role])
#   # end

#   # def after_sign_up_path_for(resource)
#   #   dashboard_path  # Redirect to the dashboard path after sign up
#   # end
  
#   # before_action :configure_permitted_parameters, if: :devise_controller?

#   # protected

#   # def configure_permitted_parameters
#   #   devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
#   #   devise_parameter_sanitizer.permit(:account_update, keys: [:role])
#   # end

#   protect_from_forgery with: :exception
  
#     before_action :configure_permitted_parameters, if: :devise_controller?
  
#     protected
  
#     def configure_permitted_parameters
#       devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :company_name,:name,:company_id])
#       devise_parameter_sanitizer.permit(:account_update, keys: [:role, :company_name,:name,:company_id])
#     end
# end


class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :log_user_activity

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :company_name, :name, :company_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:role, :company_name, :name, :company_id])
  end

  private

  def log_user_activity
    Rails.logger.info("User Activity: #{current_user&.email} accessed #{request.path}")
  end
end
