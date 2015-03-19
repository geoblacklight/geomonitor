class ApplicationController < ActionController::Base

  include Squash::Ruby::ControllerMethods
  enable_squash_client
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
