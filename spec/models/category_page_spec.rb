require 'spec_helper'

describe CategoryPage do
  it "is invalid without a source" do
    expect(FactoryGirl.build(:category_page, source:nil)).to_not be_valid
  end

  it "is invalid without a url" do
    expect(FactoryGirl.build(:category_page, url:nil)).to_not be_valid
  end

  it "is invalid without a name" do
    expect(FactoryGirl.build(:category_page, name:nil)).to_not be_valid
  end

  it "is invalid without a brand" do
    expect(FactoryGirl.build(:category_page, brand:nil)).to_not be_valid
  end

  it "is invalid with an invalid url" do
    expect(FactoryGirl.build(:category_page, url:'www.gsmarena.com')).to_not be_valid
  end

  it "is valid with a valid url" do
    expect(FactoryGirl.build(:category_page, url:'http://www.google.es')).to be_valid
  end

  it 'should respond to parsing results' do
    expect(FactoryGirl.create(:category_page)).to respond_to(:category_parsing_results)
  end

  it 'should respond to the last parsed result' do
    expect(FactoryGirl.create(:category_page_with_parsed_results)).to respond_to(:last_parsed_result)
  end
end
