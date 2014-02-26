require 'spec_helper'

describe CategoryParsingResult do
  it "is invalid without a date" do
    expect(FactoryGirl.build(:category_parsing_result, date:nil)).to_not be_valid
  end
end
