require "spec_helper"

feature 'Admin accesses sources management' do
  scenario 'fails to access because he is not an admin' do
      source = create(:source, { :name => 'GSMArena', :url => 'http://www.gsmarena.com' }) 

      user = create(:user)
      sign_in(user)

      visit admin_sources_path 

      expect(page).to have_text('Welcome to PhoneFinder')
  end

  context 'being an admin' do
    let(:user) { create(:user, :admin) }

    before(:each) do
      create(:source, { :name => 'GSMArena', :url => 'http://www.gsmarena.com' }) 
    end

    scenario 'fails to access because he isnt signed in' do
      visit  admin_sources_path

      expect(page).to have_text('Sign in')
    end

    scenario 'sees list of all sources' do
      sign_in(user)

      visit admin_sources_path 

      expect(page).to have_text("GSMArena")
    end

    scenario 'can delete a particular source' do
      sign_in(user)
      visit admin_sources_path 

      click_button('Delete source')
      expect(page).to have_text('Source deleted correctly.')
    end

    scenario 'can add a category page for a source' do
      sign_in(user)
      visit admin_sources_path 

      click_link('Add category page')
      expect(page).to have_text('Create a new category page for the source')
    end

    scenario 'can go to the category pages for a source' do
      sign_in(user)
      visit admin_sources_path 

      click_link('See category pages for this source')
      expect(page).to have_text('Category Pages for')
    end
  end
end


