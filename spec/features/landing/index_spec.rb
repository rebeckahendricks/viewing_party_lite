require 'rails_helper'

RSpec.describe 'landing page', type: :feature do
  describe 'title of application' do
    it 'has a title at the top of the page' do
      visit '/'

      expect(page).to have_content('Viewing Party Lite')
    end
  end

  describe 'button to create a new user' do
    it 'has a button to create a new user' do
      visit '/'

      expect(page).to have_button('Create a New User')
      click_button('Create a New User')
      expect(current_path).to eq('/register')
    end
  end

  describe 'list of existing users' do
    before :each do
      @user1 = create(:user, name: 'Erin', email: 'epintozzi@turing.edu')
      @user2 = create(:user, name: 'Mike', email: 'mike@turing.edu')
      @user3 = create(:user, name: 'Meg', email: 'mstang@turing.edu')
    end

    it 'has a list of existing user which links to the users dashboard' do
      visit '/'

      within '#existing_users' do
        expect(page).to have_link("epintozzi@turing.edu's Dashboard")
        expect(page).to have_link("mike@turing.edu's Dashboard")
        expect(page).to have_link("mstang@turing.edu's Dashboard")
      end

      within '#existing_users' do
        click_link("epintozzi@turing.edu's Dashboard")
      end

      expect(current_path).to eq("/users/#{@user1.id}")
    end
  end

  describe ' link to go back to landing page' do
    it 'has a link to go back to the landing page' do
      visit '/'

      expect(page).to have_link('Home')
      click_link('Home')
      expect(current_path).to eq('/')
    end
  end

  describe 'As a registered user' do
    describe 'When I visit the landing page "/"' do
      it 'I see a link for "Log In"' do
        visit '/'

        expect(page).to have_link('Log In')
      end

      describe 'When I click on "Log In"' do
        it 'I am taken to a Log In page ("/login") where I can input my unique email and password"' do
          visit '/'

          click_link('Log In')

          expect(current_path).to eq('/login')
        end 
      end

      describe 'When I enter my unique email and correct password' do
        it 'I am taken to my dashboard page' do
          user = create(:user, email: 'rebecka@gmail.com', password: 'password123')
          visit '/login'

          fill_in :email, with: 'rebecka@gmail.com'
          fill_in :password, with: 'password123'
          click_button 'Log In'

          expect(current_path).to eq(user_path(user))
        end
      end
    end
  end
end