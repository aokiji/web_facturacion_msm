class UsersController < ApplicationController

  def show
    if current_user
      @user = current_user

      respond_to do |format|
        format.html
        format.xml  { render :xml => @user }
      end
    else
      redirect_to login_path
    end
  end
end
