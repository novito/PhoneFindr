require 'spec_helper'

describe Sources do
  it "is invalid without a name" do
    expect(FactoryGirl.build(:source, name:nil)).to_not be_valid
  end

  it "is invalid without a url" do
    expect(FactoryGirl.build(:source, url:nil)).to_not be_valid
  end

  it "is invalid with an invalid url" do
    expect(FactoryGirl.build(:source, url:'www.gsmarena.com')).to_not be_valid
  end

  it "is valid with a valid url" do
    expect(FactoryGirl.build(:source, url:'http://www.google.es')).to be_valid
  end
end
