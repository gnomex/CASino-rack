# Be sure to restart your server when you modify this file.
# require 'rack-cas/session_store/active_record'

# Rails.application.config.session_store :cookie_store, key: '_casino-rack_SSO_session'
# Rails.application.config.rack_cas.session_store = RackCAS::ActiveRecordStore

require 'rack-cas/session_store/rails/active_record'
CASinoRack::Application.config.session_store :rack_cas_active_record_store
