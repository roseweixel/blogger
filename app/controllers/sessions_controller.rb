class SessionsController < ApplicationController

  def create
    @user = Student.find_or_create_from_auth_hash(auth_hash)
    session[:user_id] = @user.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Signed Out!"
    redirect_to root_path
  end

  private

    def auth_hash
      request.env['omniauth.auth']
    end
end
