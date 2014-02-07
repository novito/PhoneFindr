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

  it "should raise an Exception if the URL is not valid" do
    expect { @parser.parse_cat('adsadasdas') }.to raise_error(Errno::ENOENT)
  end

  context "when parsing Nokia" do
    it "should return an Array with Nokia phones urls" do
      known_nokia_url = 'http://www.gsmarena.com/nokia_2700_classic-2657.php' 
      VCR.use_cassette "nokia" do
        expect(@parser.parse_cat('http://www.gsmarena.com/nokia-phones-f-1-2-p1.php')).to include(known_nokia_url)
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

  it "should return general information about the phone" do
    VCR.use_cassette "nokia specific page" do
      expect(@parser.parse_page(@url)).to have_key('General')
    end
  end
  
  it "should raise an Exception if the URL is not valid" do
    expect { @parser.parse_page('adsadasdas') }.to raise_error(Errno::ENOENT)
  end

  it "should raise an Exception if the URL is empty" do
    expect { @parser.parse_page('') }.to raise_error(Errno::ENOENT)
  end
end
