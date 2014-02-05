require 'spec_helper'
require 'parser'

describe "#parse_cat" do

  before(:each) do
    @parser = Parser.new
  end

  it "needs a url" do
    expect { @parser.parse_cat }.to raise_error(ArgumentError)
  end

  it "should return an Array" do
    @parser = Parser.new
    VCR.use_cassette "nokia" do
      @parser.parse_cat('http://www.gsmarena.com/nokia-phones-f-1-2-p1.php').should be_instance_of(Array)
    end
  end

  context "when parsing Nokia" do
    it "should return an Array with Nokia phones urls" do
      known_nokia_url = 'nokia_lumia_1520-5760.php' 
      VCR.use_cassette "nokia" do
        nokia_urls = @parser.parse_cat('http://www.gsmarena.com/nokia-phones-f-1-2-p1.php')
        expect(nokia_urls).to include(known_nokia_url)
      end
    end
  end
end
