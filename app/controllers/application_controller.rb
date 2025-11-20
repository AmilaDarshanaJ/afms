class ApplicationController < ActionController::Base
  include Authentication

  helper_method :current_user, :user_signed_in?

  allow_browser versions: :modern
end
