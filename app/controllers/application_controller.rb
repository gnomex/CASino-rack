class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :fix_cas_session
  before_filter :ensure_loggedin

  respond_to :html, :json, :xml

  private
  def fix_cas_session
    if session[:cas].respond_to?(:with_indifferent_access)
      session[:cas] = session[:cas].with_indifferent_access
    end
  end

  def ensure_loggedin
    if session[:cas].nil? || session[:cas][:user].nil?
      render status: 401, text: "Redirecting to SSO..."
    end
  end
end
