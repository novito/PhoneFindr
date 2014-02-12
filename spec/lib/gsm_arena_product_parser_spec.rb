require 'spec_helper'
require 'gsm_arena_product_parser'

describe GsmArenaProductParser do
  let(:parser) { GsmArenaProductParser.new }

  it 'needs a url' do
    expect { parser.parse }.to raise_error(ArgumentError)
  end

  it 'raises an Exception if the URL is not valid' do
    expect { parser.parse('adsadasdas') }.to raise_error(Errno::ENOENT)
  end

  describe '#parse' do
    it 'returns a Hash' do
      VCR.use_cassette 'gsm arena nokia lumia' do
        nokia_lumia_url = 'http://www.gsmarena.com/nokia_lumia_1520-5760.php'
        parser.parse(nokia_lumia_url).should be_instance_of(Hash)
      end
    end

    it 'returns general information about the phone' do
      VCR.use_cassette 'gsm arena nokia lumia' do
        nokia_lumia_url = 'http://www.gsmarena.com/nokia_lumia_1520-5760.php'
        expect(parser.parse(nokia_lumia_url)).to have_key(:general)
      end
    end

    it 'raises an Exception if the URL is not valid' do
      expect { parser.parse('adsadasdas') }.to raise_error(Errno::ENOENT)
    end

    it 'raises an Exception if the URL is empty' do
      expect { parser.parse('') }.to raise_error(Errno::ENOENT)
    end

    context "A phone that is available" do
      it 'returns an available status' do
        VCR.use_cassette 'gsm arena available phone' do
          available_phone = 'http://www.gsmarena.com/nokia_lumia_1520-5760.php'
          specs = parser.parse(available_phone)
          expect(specs[:general][:status][:available]).to be_true
        end
      end
      it 'returns a release date' do
        VCR.use_cassette 'gsm arena available phone' do
          available_phone = 'http://www.gsmarena.com/nokia_lumia_1520-5760.php'
          specs = parser.parse(available_phone)
          expect(specs[:general][:status][:release_date]).to eql(Date.new(2013, 11, 1))
        end
      end
    end

    context "A phone that is not available, but is coming soon" do
      it 'returns an unavailable status' do
        VCR.use_cassette 'gsm arena coming soon phone' do
          coming_soon_phone = 'http://www.gsmarena.com/sony_xperia_e1_dual-5967.php'
          specs = parser.parse(coming_soon_phone)
          expect(specs[:general][:status][:available]).to be_false
        end
      end
    end

  end


end
