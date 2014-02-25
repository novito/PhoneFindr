require "spec_helper"

feature 'Admin creates a new category page' do
  let(:source) { create(:source, { :name => 'GSMArena', :url => 'http://www.gsmarena.com' }) }

  scenario 'fails to create because he is not an admin' do
    user = create(:user)
    sign_in(user)

    visit new_admin_source_category_page_path(source) 

    expect(page).to have_text('Hi there')
  end

end
