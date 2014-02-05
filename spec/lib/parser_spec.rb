require 'spec_helper'
require 'parser'

describe "#parse_cat" do

  before(:each) do
    @parser = Parser.new
  end

  it "needs a url" do
    expect { @parser.parse_cat }.to raise_error(ArgumentError)
  end

  it "returns an Array" do
    VCR.use_cassette "nokia" do
      @parser.parse_cat('http://www.gsmarena.com/nokia-phones-f-1-2-p1.php').should be_instance_of(Array)
    end
  end

  context "when parsing Nokia" do
    it "should return an Array with Nokia phones urls" do
      known_nokia_url = 'http://www.gsmarena.com/nokia_2700_classic-2657.php' 
      VCR.use_cassette "nokia" do
        nokia_urls = @parser.parse_cat('http://www.gsmarena.com/nokia-phones-f-1-2-p1.php')
        expect(nokia_urls).to include(known_nokia_url)
      end
    end
  end

end

describe "#parse_page" do
  before(:each) do
    @parser = Parser.new
    @url = 'http://www.gsmarena.com/nokia_lumia_1520-5760.php' 
  end

  it "needs a url" do
    expect { @parser.parse_page }.to raise_error(ArgumentError)
  end

  it "returns a Hash" do
    VCR.use_cassette "nokia specific page" do
      @parser.parse_page(@url).should be_instance_of(Hash)
    end
  end

  it "returns an empty Hash if the url is an empty string" do
    expect(@parser.parse_page('')).to be_empty
  end
end
