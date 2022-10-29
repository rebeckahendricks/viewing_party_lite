class MoviesFacade
  def self.find_movie(movie_id)
    data = MovieService.get_movie_data(movie_id)
    Movie.new(data)
  end

  def self.find_cast(movie_id)
    data = MovieService.get_cast_data(movie_id)
    cast_members = data[:cast]
    cast_members.map do |cast_member|
      Cast.new(cast_member)
    end
  end

  def self.find_reviews(movie_id)
    data = MovieService.get_review_data(movie_id)
    movie_reviews = data[:results]
    movie_reviews.map do |review|
      Review.new(review)
    end
  end

  def self.find_search_movies(search)
    data = MovieService.get_search_data(search)
    movies = data[:results]
    movies.map do |movie|
      SearchMovie.new(movie)
    end
  end

  def self.find_top_movies
    data = MovieService.get_top_movie_data
    movies = data[:results]
    movies.map do |movie|
      SearchMovie.new(movie)
    end
  end

  def self.find_movie_image(movie_id)
    data = MovieService.get_movie_image(movie_id)
    if !data[:posters].empty?
      data[:posters][0][:file_path]
    end
  end
end
