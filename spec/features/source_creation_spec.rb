require "spec_helper"

feature 'Admin creates a new source' do
  scenario 'fails to create because he is not an admin' do
    source = create(:source, { :name => 'GSMArena', :url => 'http://www.gsmarena.com' }) 

    user = create(:user)
    sign_in(user)

    visit new_admin_source_path 

    expect(page).to have_text('Hi there')
  end

  context 'being an admin' do
    let(:user) { create(:user, :admin) }


    scenario 'fails to create because if there is no name' do
      sign_in(user)
      visit new_admin_source_path
      fill_in 'Url', :with => 'http://www.gsmarena.com'

      click_button('Create source')
      expect(page).to have_text("Name can't be blank")
    end

    scenario 'fails to create if there is not URL' do
      sign_in(user)
      visit new_admin_source_path
      fill_in 'Name', :with => 'GSMArena'

      click_button('Create source')
      expect(page).to have_text("Url can't be blank")
    end

    scenario 'creates succesfully a source with all the required fields' do
      sign_in(user)
      visit new_admin_source_path
      fill_in 'Name', :with => 'GSMArena'
      fill_in 'Url', :with => 'http://www.gsmarena.com'

      click_button('Create source')
      expect(page).to have_text('Source has been created!')
    end

    scenario 'fails to create if the URL is not correct' do
      sign_in(user)
      visit new_admin_source_path
      fill_in 'Name', :with => 'GSMArena'
      fill_in 'Url', :with => 'www.gsmarena.com'

      click_button('Create source')
      expect(page).to have_text('Url must be a valid URL')
    end
  end
end
