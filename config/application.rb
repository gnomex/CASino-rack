require File.expand_path('../boot', __FILE__)

require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require 'rack-cas/session_store/active_record'

Bundler.require(*Rails.groups)

module CASinoRack
  class Application < Rails::Application
    config.time_zone = 'Brasilia'

    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.yml").to_s]
    config.autoload_paths += %W(#{config.root}/lib/validators/)
    config.i18n.default_locale = :"pt-BR"
    config.i18n.enforce_available_locales = false
    config.encoding = "utf-8"

    config.active_record.whitelist_attributes = true
    config.action_controller.action_on_unpermitted_parameters = :raise

    # To re-enable this authenticity token for remote forms
    # config.action_view.embed_authenticity_token_in_remote_forms = true

    # Disable the asset pipeline.
    config.assets.enabled = false
    # config.assets.css_compressor = :yui
    config.assets.css_compressor = :sass
    config.assets.js_compressor = :uglify

    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower')

    config.rack_cas.session_store = RackCAS::ActiveRecordStore
    config.rack_cas.server_url = 'http://localhost:3000'
  end
end
