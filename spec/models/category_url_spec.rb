require 'spec_helper'

describe CategoryUrl do
  it "is invalid without a source" do
    expect(FactoryGirl.build(:category_url, source:nil)).to_not be_valid
  end

  it "is invalid without a url" do
    expect(FactoryGirl.build(:category_url, url:nil)).to_not be_valid
  end

  it "is invalid with an invalid url" do
    expect(FactoryGirl.build(:category_url, url:'www.gsmarena.com')).to_not be_valid
  end

  it "is valid with a valid url" do
    expect(FactoryGirl.build(:category_url, url:'http://www.google.es')).to be_valid
  end
end
