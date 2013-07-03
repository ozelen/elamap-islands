class UserSessionsController < ApplicationController
  skip_before_filter :require_user
  def index
    @user_sessions = UserSession.all
  end

  def show
    @user_session = UserSession.find(params[:id])
  end

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to root_url, :notice => "Successfully logged in."
    else
      render :action => 'new', :notice => "Icorrect password"
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    redirect_to root_url, :notice => "Successfully logged out."
  end
end
