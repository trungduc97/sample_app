class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t "success"
      redirect_to @user
    else
      flash[:danger] = t "error_signup"
      render :new
    end
  end

  def show
    return if @user = User.find_by(id: params[:id])
    flash[:danger] = t "error_find_user"
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
