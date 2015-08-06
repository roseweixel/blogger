class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create]
  
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    login_user
    redirect_to_landing_page
  end

  def destroy
    logout_user
    flash[:notice] = "Goodbye!"
    redirect_to root_path
  end

  private

    def auth_hash
      request.env['omniauth.auth']
    end

    def redirect_to_landing_page
      if @user.admin
        redirect_to cohorts_path
      else
        redirect_to user_path(@user)
      end
    end
end
