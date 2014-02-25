require "spec_helper"

feature 'Admin creates a new page' do
  scenario 'fails to create because he is not an admin' do
    source = create(:source, { :name => 'GSMArena', :url => 'http://www.gsmarena.com' }) 

    user = create(:user)
    sign_in(user)

    visit new_admin_source_page_path 

    expect(page).to have_text('Hi there')
  end

end
