require 'spec_helper'

describe DevicePage do
  it "is invalid without a url" do
    expect(FactoryGirl.build(:device_page, url:nil)).to_not be_valid
  end
  it "is invalid without a category url" do
    expect(FactoryGirl.build(:device_page, category_page:nil)).to_not be_valid
  end
end
