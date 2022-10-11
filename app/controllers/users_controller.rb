class UsersController < ApplicationController 
  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user), notice: 'User was successfully created'
    else
      redirect_to '/register', notice: 'User not created'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end