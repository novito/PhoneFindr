require "spec_helper"

feature 'Admin accesses sources management' do
  scenario 'fails to access because he is not an admin' do
      source = create(:source, { :name => 'GSMArena', :url => 'http://www.gsmarena.com' }) 

      user = create(:user)
      sign_in(user)

      visit admin_sources_path 

      expect(page).to have_text('Hi there')
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

  end
end


