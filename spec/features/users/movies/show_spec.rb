require 'rails_helper'

RSpec.describe 'Movie Details Page', type: :feature do
  before :each do
    json_response = File.open('./fixtures/godfather_details.json')
    stub_request(:get, 'https://api.themoviedb.org/3/movie/238').
      with(query: {'api_key' => ENV['movie_api_key']}).
      to_return(status: 200, body: json_response)

    json_response1 = File.open('./fixtures/godfather_cast.json')
    stub_request(:get, 'https://api.themoviedb.org/3/movie/238/credits').
      with(query: {'api_key' => ENV['movie_api_key']}).
      to_return(status: 200, body: json_response1)

    json_response2 = File.open('./fixtures/godfather_reviews.json')
    stub_request(:get, 'https://api.themoviedb.org/3/movie/238/reviews').
      with(query: {'api_key' => ENV['movie_api_key']}).
      to_return(status: 200, body: json_response2)

    json_response3 = File.open('./fixtures/godfather_image.json')
    stub_request(:get, 'https://api.themoviedb.org/3/movie/238/images').
      with(query: {'api_key' => ENV['movie_api_key']}).
      to_return(status: 200, body: json_response3) 
  end

  describe 'When I visit movies detail page' do
    it 'I see a button to create a viewing party' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit user_movie_path(user1, 238)

      expect(page).to have_button('Create Viewing Party for The Godfather')

      click_button('Create Viewing Party for The Godfather')

      expect(current_path).to eq(new_user_movie_viewing_party_path(user1, 238))
    end

    it 'I see a button to return to the Discover Page' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit user_movie_path(user1, 238)

      expect(page).to have_button('Discover Page')

      click_button('Discover Page')

      expect(current_path).to eq(user_discover_index_path(user1))
    end
  end

  describe 'I should see the following information about the movie' do
    it 'has a movie title' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit user_movie_path(user1, 238)

      expect(page).to have_content('The Godfather')
    end

    it 'has a vote average' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit user_movie_path(user1, 238)

      expect(page).to have_content('Vote Average: 8.7')
    end

    it 'has a runtime' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit user_movie_path(user1, 238)

      expect(page).to have_content('Runtime: 2hr 55min')
    end

    it 'has genre(s)' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit user_movie_path(user1, 238)

      expect(page).to have_content('Genre(s): Drama, Crime')
    end

    it 'has a summary description' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit user_movie_path(user1, 238)

      within('#summary') do
        expect(page).to have_content('Spanning the years 1945 to 1955')
        expect(page).to have_content('launching a campaign of bloody revenge.')
      end
    end

    it 'lists the first 10 cast members' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit user_movie_path(user1, 238)

      within('#cast') do
        expect(page).to have_css('div', maximum: 10)
        expect(page).to have_content('Marlon Brando as Don Vito Corleone')
        expect(page).to have_content('Al Pacino as Don Michael Corleone')
        expect(page).to have_content("James Caan as Santino 'Sonny' Corleone")
      end
    end

    it 'has a count of total reviews' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit user_movie_path(user1, 238)

      within('#reviews') do
        expect(page).to have_content('2 Reviews')
      end
    end

    it 'has each reviews author and info' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit user_movie_path(user1, 238)

      within('#reviews') do
        expect(page).to have_content('Author: futuretv')
        expect(page).to have_content('The Godfather Review by Al Carlson')
        expect(page).to have_content('The Godfather is a movie you can’t refuse.')
      end
    end
  end
end