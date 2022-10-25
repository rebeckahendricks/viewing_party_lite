require 'rails_helper'

RSpec.describe 'User Registration Page', type: :feature do
  describe 'User Registration Form - Happy Path' do
    it 'I see a form to fill in my name, email, password, and password confirmation' do
      visit '/register'

      fill_in('Name', with: 'Becka')
      fill_in('Email', with: 'rebecka@gmail.com')
      fill_in('Password', with: 'password')
      fill_in('Password Confirmation', with: 'password')

      click_button 'Create New User'

      expect(User.last.name).to eq('Becka')
      expect(current_path).to eq("/users/#{User.last.id}")
      expect(page).to have_content('User was successfully created')
    end
  end

  describe 'User Registration Form - Sad Path' do
    it 'can only create a user when the email is unique' do
      @user1 = create(:user, name: 'Becka', email: 'rebecka@gmail.com')

      visit '/register'

      fill_in('Name', with: 'Thomas')
      fill_in('Email', with: 'rebecka@gmail.com')
      fill_in('Password', with: 'password123')
      fill_in('Password Confirmation', with: 'password123')

      click_button 'Create New User'

      expect(current_path).to eq('/register')
      expect(page).to have_content('User not created')
      expect(User.count).to eq(1)
    end

    it 'can only create a user when a email is provided' do
      visit '/register'

      fill_in('Name', with: 'Thomas')
      fill_in('Email', with: '')
      fill_in('Password', with: 'password123')
      fill_in('Password Confirmation', with: 'password123')

      click_button 'Create New User'

      expect(current_path).to eq('/register')
      expect(page).to have_content('User not created')
      expect(User.count).to eq(0)
    end

    it 'can only create a user when an name is provided' do
      visit '/register'

      fill_in('Name', with: '')
      fill_in('Email', with: 'thomas@gmail.com')
      fill_in('Password', with: 'password123')
      fill_in('Password Confirmation', with: 'password123')

      click_button 'Create New User'

      expect(current_path).to eq('/register')
      expect(page).to have_content('User not created')
      expect(User.count).to eq(0)
    end

    it 'can only create a user when the password confirmation matches the password' do
      visit '/register'

      fill_in('Name', with: '')
      fill_in('Email', with: 'thomas@gmail.com')
      fill_in('Password', with: 'password123')
      fill_in('Password Confirmation', with: 'password321')

      click_button 'Create New User'

      expect(current_path).to eq('/register')
      expect(page).to have_content('Confirmation password must match password')
      expect(User.count).to eq(0)
    end
  end
end
