class UserSessionsController < ApplicationController
  layout nil
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to users_path
    else
      flash[:error] = "Invalid Username or password.Please try again!"
      render :action => :new
      
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to new_user_session_url
  end

end
