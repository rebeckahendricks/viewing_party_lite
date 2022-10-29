require 'rails_helper'

RSpec.describe Movie do
  before :all do
    json_response = File.open('./fixtures/godfather_image.json')
    stub_request(:get, 'https://api.themoviedb.org/3/movie/238/images').
      with(query: {'api_key' => ENV['movie_api_key']}).
      to_return(status: 200, body: json_response) 
  end

  it 'exists' do
    movie_data = {
      "adult": false,
      "backdrop_path": "/rSPw7tgCH9c6NqICZef4kZjFOQ5.jpg",
      "belongs_to_collection": {
          "id": 230,
          "name": "The Godfather Collection",
          "poster_path": "/9Baumh5J9N1nJUYzNkm0xsgjpwY.jpg",
          "backdrop_path": "/3WZTxpgscsmoUk81TuECXdFOD0R.jpg"
      },
      "budget": 6000000,
      "genres": [
          {
              "id": 18,
              "name": "Drama"
          },
          {
              "id": 80,
              "name": "Crime"
          }
      ],
      "homepage": "http://www.thegodfather.com/",
      "id": 238,
      "imdb_id": "tt0068646",
      "original_language": "en",
      "original_title": "The Godfather",
      "overview": "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.",
      "popularity": 100.336,
      "poster_path": "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg",
      "production_companies": [
          {
              "id": 4,
              "logo_path": "/gz66EfNoYPqHTYI4q9UEN4CbHRc.png",
              "name": "Paramount",
              "origin_country": "US"
          },
          {
              "id": 10211,
              "logo_path": "null",
              "name": "Alfran Productions",
              "origin_country": "US"
          }
      ],
      "production_countries": [
          {
              "iso_3166_1": "US",
              "name": "United States of America"
          }
      ],
      "release_date": "1972-03-14",
      "revenue": 245066411,
      "runtime": 175,
      "spoken_languages": [
          {
              "english_name": "English",
              "iso_639_1": "en",
              "name": "English"
          },
          {
              "english_name": "Italian",
              "iso_639_1": "it",
              "name": "Italiano"
          },
          {
              "english_name": "Latin",
              "iso_639_1": "la",
              "name": "Latin"
          }
      ],
      "status": "Released",
      "tagline": "An offer you can't refuse.",
      "title": "The Godfather",
      "video": false,
      "vote_average": 8.715,
      "vote_count": 16726
    }

    movie = Movie.new(movie_data)

    expect(movie).to be_a Movie
    expect(movie.movie_id).to eq(238)
    expect(movie.title).to eq('The Godfather')
    expect(movie.runtime).to eq(175)
    expect(movie.summary).to include('Spanning the years 1945 to 1955')
    expect(movie.summary).to include('launching a campaign of bloody revenge.')
    expect(movie.vote_average).to eq(8.715)
    expect(movie.genres).to eq(["Drama", "Crime"])
    expect(movie.image_path).to eq('/3bhkrj58Vtu7enYsRolD1fZdja1.jpg')
  end
end
