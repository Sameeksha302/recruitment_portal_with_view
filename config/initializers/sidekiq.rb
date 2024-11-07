Sidekiq.configure_server do |config|
    config.redis = { url: "redis://localhost:6379/0" }
end

Sidekiq.configure_client do |config|
config.redis = { url: "redis://localhost:6379/0" }
end


# Sidekiq.configure_server do |config|
#     config.redis = {
#       url: Rails.env.development? ? "redis://localhost:6379/0" : "redis://red-csm94artq21c738ec9d0:6379"
#     }
#   end
  
#   Sidekiq.configure_client do |config|
#     config.redis = {
#       url: Rails.env.development? ? "redis://localhost:6379/0" : "redis://red-csm94artq21c738ec9d0:6379"
#     }
#   end
