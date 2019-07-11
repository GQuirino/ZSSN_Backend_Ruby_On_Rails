require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_record/railtie"
require "active_storage/engine"
require "action_mailer/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ZSSNBackendRubyOnRails
  class Application < Rails::Application
    # load /libs
    config.autoload_paths += Dir[
      "#{config.root}/lib/**/"
    ]

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.api_only = true

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
