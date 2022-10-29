class ViewingPartyController < ApplicationController
  def new
    if user_id_in_session
      @user = User.find(user_id_in_session)
      @movie = MoviesFacade.find_movie(params[:movie_id])
      @users = User.all
      @viewing_party = ViewingParty.new
    else
      redirect_to movie_path(params[:movie_id]), notice: 'You must be logged in or registered to create a movie party'
    end
  end

  def create
    @user = User.find(user_id_in_session)
    @viewing_party = ViewingParty.new(viewing_party_params)
    if @viewing_party.save
      UserViewingParty.create(user_id: user_id_in_session, viewing_party_id: @viewing_party.id, role: 0)
      params[:user_ids]&.each { |user_id| UserViewingParty.create(user_id: user_id, viewing_party_id: @viewing_party.id, role: 1) }
      redirect_to dashboard_path
    else
      redirect_to new_movie_viewing_party_path(params[:movie_id]), notice: 'Viewing Party Not Created'
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:duration, :date, :start_time, :movie_id)
  end
end
