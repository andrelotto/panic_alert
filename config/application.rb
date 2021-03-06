require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PanicAlert
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    config.middleware.insert_after ActionDispatch::Callbacks, Warden::Manager do |manager|
      manager.default_strategies :auth_token, :basic_auth
      manager.failure_app = UnauthorizedController
    end


    Date::DATE_FORMATS[:default] = "%d/%m/%Y"
    Time::DATE_FORMATS[:default] = "%d/%m/%Y %H:%M"
    DateTime::DATE_FORMATS[:default] = "%d/%m/%Y %H:%M"

    Date::DATE_FORMATS[:for_code] = "%d%m%Y"
    Time::DATE_FORMATS[:for_code] = "%d%m%Y%H%M%S"
    DateTime::DATE_FORMATS[:for_code] = "%d%m%Y%H%M%S"

    config.time_zone = 'Brasilia'
  end
end
