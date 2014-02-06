require 'spec_helper'

feature 'Admin panel' do
  describe 'an admin user' do
    context "logged in" do
      it "can access" do
        user = create(:user, :admin)
        sign_in(user)
        visit '/admin' 
        page.should have_content('Dashboard')
      end
    end

    context "not logged in" do
      it "cannot access" do
        user = create(:user, :admin)
        visit '/admin' 
        page.should have_content('Hi there')
      end
    end
  end

  describe "a not admin user" do
    context "logged in" do
      it "cannot access" do
        user = create(:user, :not_admin)
        sign_in(user)
        visit '/admin' 
        page.should have_content('Hi there')
      end
    end

    context "not logged in" do
      it "cannot access" do
        user = create(:user, :not_admin)
        visit '/admin' 
        page.should have_content('Hi there')
      end
    end
  end

end

