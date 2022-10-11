require 'rails_helper'

RSpec.describe 'User Registration Page', type: :feature do
  describe 'User Registration Form - Happy Path' do
    it 'has a form to create a new user' do
      visit '/register'

      fill_in('Name', with: 'Becka')
      fill_in('Email', with: 'rebecka@gmail.com')

      click_button 'Create New User'

      expect(User.last.name).to eq('Becka')
      expect(current_path).to eq("/users/#{User.last.id}")
      expect(page).to have_content('User was successfully created')
    end
  end

  describe 'User Registration Form - Sad Path' do
    it 'can only create a user when the email is unique' do
      @user1 = User.create!(name: 'Becka', email: 'rebecka@gmail.com')

      visit '/register'

      fill_in('Name', with: 'Thomas')
      fill_in('Email', with: 'rebecka@gmail.com')

      click_button 'Create New User'

      expect(current_path).to eq('/register')
      expect(page).to have_content('User not created')
      expect(User.count).to eq(1)
    end

    it 'can only create a user when a email is provided' do
      visit '/register'

      fill_in('Name', with: 'Thomas')
      fill_in('Email', with: '')

      click_button 'Create New User'

      expect(current_path).to eq('/register')
      expect(page).to have_content('User not created')
      expect(User.count).to eq(0)
    end

    it 'can only create a user when an name is provided' do
      visit '/register'

      fill_in('Name', with: '')
      fill_in('Email', with: 'thomas@gmail.com')

      click_button 'Create New User'

      expect(current_path).to eq('/register')
      expect(page).to have_content('User not created')
      expect(User.count).to eq(0)
    end
  end
end