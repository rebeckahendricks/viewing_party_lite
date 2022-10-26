class MoviesController < ApplicationController
  def index
    search = params[:search]
    if search == ''
      redirect_to discover_path, notice: 'Search field cannot be blank'
    elsif !search.nil?
      @movies = MoviesFacade.find_search_movies(search)
    else
      @movies = MoviesFacade.find_top_movies
    end
  end

  def show
    movie_id = params[:id]
    @movie = MoviesFacade.find_movie(movie_id)
    @cast = MoviesFacade.find_cast(movie_id)
    @reviews = MoviesFacade.find_reviews(movie_id)
  end
end
