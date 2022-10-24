class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @users = User.all
    @movies = @user.viewing_parties.map { |party| MoviesFacade.find_movie(party.movie_id) }
    @user_viewing_parties = UserViewingParty.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user), notice: 'User was successfully created'
    elsif user_params[:password] != user_params[:password_confirmation]
      redirect_to '/register', notice: 'Confirmation password must match password'
    else
      redirect_to '/register', notice: 'User not created'
    end
  end

  def login_form
  end

  def login
    user = User.find_by(email: params[:email])
    if !user || !user.authenticate(params[:password])
      flash[:error] = 'Sorry, either your email or your password is incorrect.'
      render :login_form
    else
      session[:user_id] = user.id
      redirect_to user_path(user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
