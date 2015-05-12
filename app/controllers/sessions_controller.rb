class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create]
  
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    if @user.is_authorized?
      session[:user_id] = @user.id
      if @user.admin
        redirect_to cohorts_path
      else
        redirect_to user_path(@user)
      end
    else
      flash[:notice] = "You must be part of the Flatiron School Github organization to use Flatiron Blogger!"
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Goodbye!"
    redirect_to root_path
  end

  private

    def auth_hash
      request.env['omniauth.auth']
    end
end
