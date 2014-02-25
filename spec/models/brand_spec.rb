require 'spec_helper'

describe Brand do
  it "is invalid without a name" do
    expect(FactoryGirl.build(:brand, name:nil)).to_not be_valid
  end

  it "is valid with a valid name" do
    expect(FactoryGirl.build(:brand, name:'Samsung')).to be_valid
  end

  it "is invalid with a repeated name" do
    create(:brand, name: 'Samsung')
    expect(FactoryGirl.build(:brand, name:'Samsung')).to_not be_valid
  end
end
