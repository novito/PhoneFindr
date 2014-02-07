require 'spec_helper'

feature 'Admin panel' do
  scenario 'logged in admin access the dashboard' do
      user = create(:user, :admin)
      sign_in(user)
      visit '/admin' 
      page.should have_content('Dashboard')
  end

  scenario "not logged in admin can't access the dashboard" do
    user = create(:user, :admin)
    visit '/admin' 
    page.should have_content('Hi there')
  end

  scenario "not logged in user can't access the dashboard" do
    user = create(:user, :not_admin)
    sign_in(user)
    visit '/admin' 
    page.should have_content('Hi there')
  end

  scenario "logged in user can't access the dashboard" do
    user = create(:user, :not_admin)
    visit '/admin' 
    page.should have_content('Hi there')
  end
end

