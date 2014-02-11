require "spec_helper"

feature 'Admin accesses sources management' do
  scenario 'fails to access because he doesnt have admin flag' do
      source = create(:source, { :name => 'GSMArena', :url => 'http://www.gsmarena.com' }) 

      user = create(:user)
      sign_in(user)

      visit "/sources"

      expect(page).to have_text('Hi there')
  end

  context 'being an admin' do
    let(:user) { create(:user, :admin) }

    before(:each) do
      create(:source, { :name => 'GSMArena', :url => 'http://www.gsmarena.com' }) 
    end

    scenario 'fails to access because he isnt signed in' do
      visit "/sources"

      expect(page).to have_text('Sign in')
    end

    scenario 'sees list of all sources' do
      sign_in(user)

      visit "/sources"

      expect(page).to have_text("GSMArena")
    end

    scenario 'parses an existing source' do
      sign_in(user)

      visit "/sources"
      click_button 'Parse this source'

      expect(page).to have_text('The source is being parsed. Check later')
    end
  end

end
