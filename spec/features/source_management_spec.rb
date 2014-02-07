require "spec_helper"

feature "Source management" do
  context "as a logged in admin" do

    before(:each) do
      @user = create(:user, :admin)
      sign_in(@user)
    end

    scenario "see list of all sources" do
      source = create(:source, { :name => 'GSMArena', :url => 'http://www.gsmarena.com' }) 
      visit "/sources"

      expect(page).to have_text("GSMArena")
    end

    scenario "parse a source" do
      source = create(:source, { :name => 'GSMArena', :url => 'http://www.gsmarena.com' }) 
      visit "/sources"
      click_button 'Parse this source'

      expect(page).to have_text("The source is being parsed. Check later")
    end
  end

  context "as a non admin user who is not logged in" do
    scenario "should be redirected to the sign in page" do
      user = create(:user)
      source = create(:source, { :name => 'GSMArena', :url => 'http://www.gsmarena.com' }) 
      visit "/sources"

      expect(page).to have_text("Sign in")
    end
  end

  context "as a non admin user who is logged in" do
    scenario "should be redirected to the home page" do
      user = create(:user)
      sign_in(user)

      source = create(:source, { :name => 'GSMArena', :url => 'http://www.gsmarena.com' }) 
      visit "/sources"

      expect(page).to have_text("Hi there")
    end
  end
end
