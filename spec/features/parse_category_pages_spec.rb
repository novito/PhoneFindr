require "spec_helper"

feature 'Admin can see a category page' do
  let(:category_page) { create(:category_page_with_parsed_results, name: 'Nokia phones for GSMArena') } 

  scenario 'fails to show because he is not admin' do
    user = create(:user, :not_admin)
    sign_in(user)

    visit admin_source_category_page_path(category_page.source, category_page) 

    expect(page).to have_text('Welcome to PhoneFinder')
  end

  scenario 'fails to show because he is not admin' do
    user = create(:user, :admin)

    visit admin_source_category_page_path(category_page.source, category_page) 

    expect(page).to have_text('Sign in')
  end

  context 'being a signed in admin' do
    before(:each) do
      user = create(:user, :admin)
      sign_in(user)
      visit admin_source_category_page_path(category_page.source, category_page) 
    end

    scenario 'can see when was last time the cat page was parsed' do
      expect(page).to have_text('2012-01-01')
    end

    scenario 'can go to the last parsing results' do
      click_link('See parsing results')
    end
  end

end
