class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :set_from_uri, :clear_from_uri

  before_action :require_login
 
  private
 
    def current_user
      User.find(session[:user_id]) if session[:user_id]
    end

    def require_admin_status
      if !current_user || !current_user.admin
        flash[:alert] = "You are not allowed to see this page!"
        redirect_to root_path
      end
    end

    def require_login
      if !current_user
        flash[:alert] = "Please sign in to continue!"
        redirect_to root_path
      end
    end

    def set_from_uri
      session[:from_uri] = request.env["HTTP_REFERER"]
    end

    def clear_from_uri
      session[:from_uri] = nil
    end

    def redirect_to_from_uri
      redirect_uri = session[:from_uri]
      clear_from_uri
      redirect_to redirect_uri
    end

    def login_user
      session[:user_id] = @user.id
    end

    def logout_user
      session[:user_id] = nil
    end
end
