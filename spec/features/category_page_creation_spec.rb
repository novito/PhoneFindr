require "spec_helper"

feature 'Admin creates a new category page' do
  let(:source) { create(:source, { :name => 'GSMArena', :url => 'http://www.gsmarena.com' }) }

  scenario 'fails to create because he is not an admin' do
    user = create(:user, :not_admin)
    sign_in(user)

    visit new_admin_source_category_page_path(source) 

    expect(page).to have_text('Welcome to PhoneFinder')
  end

  scenario 'fails to create because is a non logged in admin' do
    user = create(:user, :admin)

    visit new_admin_source_category_page_path(source) 

    expect(page).to have_text('Sign in')
  end

  context 'logged in admin' do
    let(:user) { create(:user, :admin) }

    before(:each) do
      sign_in(user)
      visit new_admin_source_category_page_path(source) 
    end

    scenario 'fails to create because the url of the category is missing' do
      fill_in 'Name', :with => 'Nokia phones' 

      click_button('Add Category Page')
      expect(page).to have_text("Url can't be blank")
    end

  end
end
