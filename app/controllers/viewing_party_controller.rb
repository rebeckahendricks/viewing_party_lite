class ViewingPartyController < ApplicationController
  def new
    @users = User.all
    @user = User.find(params[:user_id])
    @movie = MoviesFacade.find_movie(params[:movie_id])
    @viewing_party = ViewingParty.new
  end

  def create
    @user = User.find(params[:user_id])
    @viewing_party = ViewingParty.new(viewing_party_params)
    if @viewing_party.save
      session[:user_id] = @user.id
      UserViewingParty.create(user_id: session[:user_id], viewing_party_id: @viewing_party.id, role: 0)
      params[:user_ids]&.each { |user_id| UserViewingParty.create(user_id: user_id, viewing_party_id: @viewing_party.id, role: 1) }
      redirect_to dashboard_path
    else
      redirect_to new_user_movie_viewing_party_path(@user, params[:movie_id]), notice: 'Viewing Party Not Created'
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:duration, :date, :start_time, :movie_id)
  end
end
