require "spec_helper"

feature 'Admin can see a category page' do
  let(:category_page) { create(:category_page_with_parsed_results, name: 'Nokia phones for GSMArena') } 

  scenario 'fails to show because he is not admin' do
    user = create(:user, :not_admin)
    sign_in(user)

    visit admin_category_page_path(category_page) 

    expect(page).to have_text('Welcome to PhoneFinder')
  end

  scenario 'fails to show because he is not admin' do
    user = create(:user, :admin)

    visit admin_category_page_path(category_page) 

    expect(page).to have_text('Sign in')
  end

  context 'being a signed in admin' do
    before(:each) do
      user = create(:user, :admin)
      sign_in(user)
      visit admin_category_page_path(category_page) 
    end

    scenario 'shows the url of the category page' do
      expect(page).to have_link('http://www.gsmarena.com/nokia-phones-1.php') 
    end

    scenario 'shows the name of the category page' do
      expect(page).to have_text('Nokia phones for GSMArena')
    end

    scenario 'shows the last time the cat page was parsed' do
      expect(page).to have_text('2012-01-01')
    end

    scenario 'allows to go to the last parsing results' do
      click_link('See parsing results')
      expect(page).to have_text('Parsing date: 2012-01-01')
    end

    scenario 'allows to start a new parsing for the cat page' do
      click_button('Start parsing')
      expect(page).to have_text('Category parser working on it...')
    end
  end

end
