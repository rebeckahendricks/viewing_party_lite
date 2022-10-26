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
      @user1 = create(:user, name: 'Erin', email: 'epintozzi@turing.edu')
      allow_any_instance_of(ApplicationController).to receive(:user_id_in_session).and_return(@user1.id)

      visit movie_path(238)

      expect(page).to have_button('Create Viewing Party for The Godfather')

      click_button('Create Viewing Party for The Godfather')

      expect(current_path).to eq(new_movie_viewing_party_path(238))
    end

    it 'I see a button to return to the Discover Page' do
      visit movie_path(238)

      expect(page).to have_button('Discover Page')

      click_button('Discover Page')

      expect(current_path).to eq(discover_path)
    end
  end

  describe 'I should see the following information about the movie' do
    it 'has a movie title' do
      visit movie_path(238)

      expect(page).to have_content('The Godfather')
    end

    it 'has a vote average' do
      visit movie_path(238)

      expect(page).to have_content('Vote Average: 8.7')
    end

    it 'has a runtime' do
      visit movie_path(238)

      expect(page).to have_content('Runtime: 2hr 55min')
    end

    it 'has genre(s)' do
      visit movie_path(238)

      expect(page).to have_content('Genre(s): Drama, Crime')
    end

    it 'has a summary description' do
      visit movie_path(238)

      within('#summary') do
        expect(page).to have_content('Spanning the years 1945 to 1955')
        expect(page).to have_content('launching a campaign of bloody revenge.')
      end
    end

    it 'lists the first 10 cast members' do
      visit movie_path(238)

      within('#cast') do
        expect(page).to have_css('div', maximum: 10)
        expect(page).to have_content('Marlon Brando as Don Vito Corleone')
        expect(page).to have_content('Al Pacino as Don Michael Corleone')
        expect(page).to have_content("James Caan as Santino 'Sonny' Corleone")
      end
    end

    it 'has a count of total reviews' do
      visit movie_path(238)

      within('#reviews') do
        expect(page).to have_content('2 Reviews')
      end
    end

    it 'has each reviews author and info' do
      visit movie_path(238)

      within('#reviews') do
        expect(page).to have_content('Author: futuretv')
        expect(page).to have_content('The Godfather Review by Al Carlson')
        expect(page).to have_content('The Godfather is a movie you can’t refuse.')
      end
    end
  end

  describe 'As a visitor' do
    describe 'If I got to a movies show page and I click the button to create a viewing party' do
      it 'I am redirected to the movies show page, and a message appears to let me know I must be logged in or registered to create a movie party' do
        visit movie_path(238)

        click_button 'Create Viewing Party for The Godfather'

        expect(current_path).to eq(movie_path(238))
        expect(page).to have_content('You must be logged in or registered to create a movie party')
      end
    end
  end
end