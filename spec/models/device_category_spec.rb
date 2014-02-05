require 'spec_helper'

describe DeviceCategory do
  it "is invalid without a name" do
    expect(FactoryGirl.build(:device_category, name:nil)).to_not be_valid
  end
end
