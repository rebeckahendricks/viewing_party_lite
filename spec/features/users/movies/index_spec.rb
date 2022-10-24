require 'rails_helper'

RSpec.describe 'Movie Results Page', type: :feature do
  describe 'When I visit the discover movies page' do
    describe 'and click on the top movies button, it takes me to the movies results page' do
      it 'I see the title "top rated movies"' do
        user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

        visit user_discover_index_path(user1)

        json_response = File.open('./fixtures/top_20.json')
        stub_request(:get, 'https://api.themoviedb.org/3/movie/top_rated').
          with(query: {'api_key' => ENV['movie_api_key']}).
          to_return(status: 200, body: json_response)

        click_button('Find Top Rated Movies')

        expect(page).to have_content('Top Rated Movies')
      end

      it 'I see the titles of the top 20 rated movies as links' do
        user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

        visit user_discover_index_path(user1)

        json_response = File.open('./fixtures/top_20.json')
        stub_request(:get, 'https://api.themoviedb.org/3/movie/top_rated').
          with(query: {'api_key' => ENV['movie_api_key']}).
          to_return(status: 200, body: json_response)

        click_button('Find Top Rated Movies')

        expect(page).to have_css('div', count: 20)

        within(first('.movie')) do
          expect(page).to have_link('The Godfather')
        end
      end

      it 'and I see the vote average of each movie' do
        user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

        visit user_discover_index_path(user1)

        json_response = File.open('./fixtures/top_20.json')
        stub_request(:get, 'https://api.themoviedb.org/3/movie/top_rated').
          with(query: {'api_key' => ENV['movie_api_key']}).
          to_return(status: 200, body: json_response)

        click_button('Find Top Rated Movies')

        within(first('.movie')) do
          expect(page).to have_content('Vote Average: 8.7')
        end
      end

      it 'has a button to return back to the discover movies page' do
        user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

        visit user_discover_index_path(user1)

        json_response = File.open('./fixtures/top_20.json')
        stub_request(:get, 'https://api.themoviedb.org/3/movie/top_rated').
          with(query: {'api_key' => ENV['movie_api_key']}).
          to_return(status: 200, body: json_response)

        click_button('Find Top Rated Movies')

        expect(page).to have_button('Discover Page')
        click_button("Discover Page")

        expect(current_path).to eq(user_discover_index_path(user1))
      end
    end
  end
  describe 'and click on the search button, it takes me to the movies results page' do
    it 'I see the title "movie results for: <search parameters>"' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit user_discover_index_path(user1)

      json_response = File.open('./fixtures/avatar.json')
      stub_request(:get, 'https://api.themoviedb.org/3/search/movie').
        with(query: {'api_key' => ENV['movie_api_key'], 'query' => 'Avatar'}).
        to_return(status: 200, body: json_response)

      fill_in(:search, with: 'Avatar')
      click_button('Find Movies')

      expect(page).to have_content('Movie Results for: Avatar')
    end

    it 'I see the titles of a maximum of 20 movies that match the search criteria' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit user_discover_index_path(user1)

      json_response = File.open('./fixtures/avatar.json')
      stub_request(:get, 'https://api.themoviedb.org/3/search/movie').
        with(query: {'api_key' => ENV['movie_api_key'], 'query' => 'Avatar'}).
        to_return(status: 200, body: json_response)

      fill_in(:search, with: 'Avatar')
      click_button('Find Movies')

      expect(page).to have_css("div", maximum: 20)
    end

    it 'I see the vote average of each movie' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit user_discover_index_path(user1)

      json_response = File.open('./fixtures/avatar.json')
      stub_request(:get, 'https://api.themoviedb.org/3/search/movie').
        with(query: {'api_key' => ENV['movie_api_key'], 'query' => 'Avatar'}).
        to_return(status: 200, body: json_response)

      fill_in(:search, with: 'Avatar')
      click_button('Find Movies')

      within(first('.movie')) do
        expect(page).to have_content('Vote Average: 7.5')
      end
    end

    it 'has a button to return back to the discover movies page' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit user_discover_index_path(user1)

      json_response = File.open('./fixtures/avatar.json')
      stub_request(:get, 'https://api.themoviedb.org/3/search/movie').
        with(query: {'api_key' => ENV['movie_api_key'], 'query' => 'Avatar'}).
        to_return(status: 200, body: json_response)

      fill_in(:search, with: 'Avatar')
      click_button('Find Movies')

      expect(page).to have_button('Discover Page')
      click_button('Discover Page')

      expect(current_path).to eq(user_discover_index_path(user1))
    end
  end
end
