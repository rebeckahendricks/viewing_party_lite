class UsersController < ApplicationController
  def show
    if user_id_in_session
      @user = User.find(user_id_in_session)
      @users = User.all
      @movies = @user.viewing_parties.map { |party| MoviesFacade.find_movie(party.movie_id) }
      @user_viewing_parties = UserViewingParty.all
    else
      redirect_to '/', notice: 'You must be logged in or registered to access my dashboard'
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: 'User was successfully created'
    elsif user_params[:password] != user_params[:password_confirmation]
      redirect_to '/register', notice: 'Confirmation password must match password'
    else
      redirect_to '/register', notice: 'User not created'
    end
  end

  def login_form; end

  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash[:error] = 'Sorry, either your email or your password is incorrect.'
      render :login_form
    end
  end

  def logout
    session.delete :user_id
    redirect_to '/'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
