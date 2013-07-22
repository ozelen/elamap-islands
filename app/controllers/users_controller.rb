class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_url, :notice => "Successfully created user."
    else
      render :action => 'new'
    end
  end

  def edit
    @user = params[:id] ? User.find(params[:id]) : current_user
    @roles = Role.all
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      #redirect_to users_url, :notice  => "Successfully updated user."
      render :action => 'edit', :notice  => "Successfully updated user."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def list
    #@users = User.find_all_by_roles_mask
  end

end
