require 'spec_helper'
require 'gsm_arena_category_parser'

describe GsmArenaCategoryParser do
  let(:parser) { GsmArenaCategoryParser.new }

  it 'needs a url' do
    expect { parser.parse }.to raise_error(ArgumentError)
  end

  it 'raises an Exception if the URL is not valid' do
    expect { parser.parse('adsadasdas') }.to raise_error(Errno::ENOENT)
  end

  it 'returns an Array' do
    VCR.use_cassette 'gsm nokia' do
      gsm_arena_nokia_url = 'http://www.gsmarena.com/nokia-phones-f-1-2-p1.php'
      parser.parse(gsm_arena_nokia_url).should be_instance_of(Array)
    end
  end
  
  it 'returns Nokia phones urls' do
    known_nokia_url = 'http://www.gsmarena.com/nokia_2700_classic-2657.php' 
    VCR.use_cassette 'gsm nokia' do
      expect(parser.parse('http://www.gsmarena.com/nokia-phones-f-1-2-p1.php')).to include(known_nokia_url)
    end
  end
end
