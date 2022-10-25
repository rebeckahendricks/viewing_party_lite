require 'rails_helper'

RSpec.describe 'New viewing party page', type: :feature do
  before :each do
    json_response = File.open('./fixtures/godfather_details.json')
    stub_request(:get, 'https://api.themoviedb.org/3/movie/238').
      with(query: {'api_key' => ENV['movie_api_key']}).
      to_return(status: 200, body: json_response)

    json_response2 = File.open('./fixtures/godfather_image.json')
    stub_request(:get, 'https://api.themoviedb.org/3/movie/238/images').
      with(query: {'api_key' => ENV['movie_api_key']}).
      to_return(status: 200, body: json_response2) 
  end
  describe 'When I visit the new viewing party page' do
    it 'I should see the name of the movie title rendered above a form' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit new_user_movie_viewing_party_path(user1, 238)

      expect(page).to have_content('Create a Movie Party for The Godfather')
    end

    it 'I should see a form with a field for duration of the party' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit new_user_movie_viewing_party_path(user1, 238)

      expect(page).to have_field('Duration of Party')
    end

    it 'the field for duration of the party has a default value of movie runtime in minutes' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit new_user_movie_viewing_party_path(user1, 238)

      expect(page).to have_field('Duration of Party', with: 175)
    end

    it 'I should see a date field for the day of the viewing party' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit new_user_movie_viewing_party_path(user1, 238)

      expect(page).to have_field('Day')
    end

    it 'I should see a time field to select the start time for the viewing party' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit new_user_movie_viewing_party_path(user1, 238)

      expect(page).to have_field('Start Time')
    end

    it 'I should see checkboxes next to each existing user in the system' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')
      user2 = create(:user, name: 'Mike', email: 'mike@turing.edu')
      user3 = create(:user, name: 'Meg', email: 'mstang@turing.edu')
      user4 = create(:user, name: 'Erin', email: 'epintozzi@turing.edu')

      visit new_user_movie_viewing_party_path(user1, 238)
      expect(page).to have_field('user_ids[]', checked: false)
    end

    it 'I should see a button to create a party' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit new_user_movie_viewing_party_path(user1, 238)

      expect(page).to have_button('Create Party')
    end
  end
  describe 'happy path' do
    it 'the user is redirected back to the dashboard where the newly created event is displayed' do
      user1 = create(:user, name: 'Erin', email: 'epintozzi@turing.edu')
      user2 = create(:user, name: 'Mike', email: 'mike@turing.edu')
      user3 = create(:user, name: 'Meg', email: 'mstang@turing.edu')

      visit new_user_movie_viewing_party_path(user1, 238)

      fill_in('Duration of Party', with: 200)
      fill_in('Day', with: Date.today)
      fill_in('Start Time', with: '7:00 PM')

      within "#invitee_#{user2.name}" do
        check
      end

      within "#invitee_#{user3.name}" do
        check
      end

      click_button('Create Party')

      expect(current_path).to eq(user_path(user1))
      expect(page).to have_content('The Godfather')
      expect(page).to have_content('Hosting')
    end

    it 'the new event should be listed on other users dashboards who were invited to the party' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')
      user2 = create(:user, name: 'Mike', email: 'mike@turing.edu')
      user3 = create(:user, name: 'Meg', email: 'mstang@turing.edu')
      user4 = create(:user, name: 'Erin', email: 'epintozzi@turing.edu')

      visit new_user_movie_viewing_party_path(user1, 238)

      fill_in('Duration of Party', with: 200)
      fill_in('Day', with: Date.today)
      fill_in('Start Time', with: '7:00 PM')

      within "#invitee_#{user2.name}" do
        check
      end

      within "#invitee_#{user3.name}" do
        check
      end

      click_button('Create Party')

      visit user_path(user2)

      expect(page).to have_content('The Godfather')
      expect(page).to have_content('Invited')

      visit user_path(user4)

      expect(page).to_not have_content('The Godfather')
      expect(page).to_not have_content('Invited')
    end
  end

  describe 'sad path' do
    it 'if a new viewing party is not created, the user is redirected back to the new viewing party page and a message is displayed' do
      user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')
      user2 = create(:user, name: 'Mike', email: 'mike@turing.edu')
      user3 = create(:user, name: 'Meg', email: 'mstang@turing.edu')

      visit new_user_movie_viewing_party_path(user1, 238)

      fill_in('Duration of Party', with: 177)
      fill_in('Day', with: '')
      fill_in('Start Time', with: '7:00')

      within "#invitee_#{user2.name}" do
        check
      end

      within "#invitee_#{user3.name}" do
        check
      end

      click_button('Create Party')

      expect(current_path).to eq(new_user_movie_viewing_party_path(user1, 238))
      expect(page).to have_content('Viewing Party Not Created')
    end
  end
end
