require 'rails_helper'

RSpec.describe 'Discover Movies Page', type: :feature do
  describe 'When I visit the user_discover_index_path, I should see' do
    it 'has a button to discover top rated movies' do
      visit discover_path

      expect(page).to have_button('Find Top Rated Movies')
    end

    it 'when the top rated movies button is clicked, the user is taken to the movies results page' do
      visit discover_path

      json_response = File.open('./fixtures/top_20.json')
        stub_request(:get, 'https://api.themoviedb.org/3/movie/top_rated').
          with(query: {'api_key' => ENV['movie_api_key']}).
          to_return(status: 200, body: json_response)

      click_button('Find Top Rated Movies')

      expect(current_path).to eq(movies_path)
    end

    it 'has a text field to enter keyword(s) to search by movie title' do
      visit discover_path

      expect(page).to have_field('search')
    end

    it 'has a button to search by Movie Title' do
      visit discover_path

      expect(page).to have_button('Find Movies')
    end

    it 'when the search field is filled in and the search button is clicked, the user is taken to the movies results page' do
      visit discover_path

      json_response = File.open('./fixtures/avatar.json')
      stub_request(:get, 'https://api.themoviedb.org/3/search/movie').
        with(query: {'api_key' => ENV['movie_api_key'], 'query' => 'Avatar'}).
        to_return(status: 200, body: json_response)

      fill_in('search', with: 'Avatar')
      click_button('Find Movies')

      expect(current_path).to eq(movies_path)
    end

    it 'when the search field is not filled in and the search button is clicked, the user is redirected back to the discover page and a message is displayed' do
      visit discover_path

      fill_in('search', with: '')
      click_button('Find Movies')

      expect(current_path).to eq(discover_path)
      expect(page).to have_content('Search field cannot be blank')
    end
  end
end
