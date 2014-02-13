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
    
######## GENERAL SPECS ###########################
    #
    describe 'general specs of the phone' do
      context "A phone that is available" do
        it 'returns an available status' do
          VCR.use_cassette 'gsm arena available phone' do
            available_phone = 'http://www.gsmarena.com/nokia_lumia_1520-5760.php'
            specs = parser.parse(available_phone)
            expect(specs[:general][:status][:available]).to be_true
          end
        end

        it 'returns an announced date' do
          VCR.use_cassette 'gsm arena available phone' do
            available_phone = 'http://www.gsmarena.com/nokia_lumia_1520-5760.php'
            specs = parser.parse(available_phone)
            expect(specs[:general][:announced]).to eql(Date.new(2013, 10, 1))
          end
        end

        it 'returns a release date' do
          VCR.use_cassette 'gsm arena available phone' do
            available_phone = 'http://www.gsmarena.com/nokia_lumia_1520-5760.php'
            specs = parser.parse(available_phone)
            expect(specs[:general][:status][:release_date]).to eql(Date.new(2013, 11, 1))
          end
        end
      end # end context of a phone that is available

      context "A phone that is not available, but is coming soon" do
        it 'returns an unavailable status' do
          VCR.use_cassette 'gsm arena coming soon phone' do
            coming_soon_phone = 'http://www.gsmarena.com/sony_xperia_e1_dual-5967.php'
            specs = parser.parse(coming_soon_phone)
            expect(specs[:general][:status][:available]).to be_false
          end
        end

        it 'returns an announced date' do
          VCR.use_cassette 'gsm arena coming soon phone' do
            coming_soon_phone = 'http://www.gsmarena.com/sony_xperia_e1_dual-5967.php'
            specs = parser.parse(coming_soon_phone)
            expect(specs[:general][:announced]).to eql(Date.new(2014, 1, 1))
          end
        end
      end

      context "A phone that is discontinued" do
        it 'returns an unavailable status' do
          VCR.use_cassette 'gsm arena discontinued phone' do
            discontinued_phone = 'http://www.gsmarena.com/htc_s310-1695.php'
            specs = parser.parse(discontinued_phone)
            expect(specs[:general][:status][:available]).to be_false
          end
        end

        it 'returns an announced date' do
          VCR.use_cassette 'gsm arena discontinued phone' do
            discontinued_phone = 'http://www.gsmarena.com/htc_s310-1695.php'
            specs = parser.parse(discontinued_phone)
            expect(specs[:general][:announced]).to eql(Date.new(2006, 9, 1))
          end
        end
      end

      describe 'SIM specs' do
        context 'a phone that has dual sim and micro sim' do
          it 'returns that it has a dual sim and a micro sim' do
            VCR.use_cassette 'gsm arena dual sim with micro sim phone' do
              dual_sim_micro_sim_phone = 'http://www.gsmarena.com/nokia_asha_503_dual_sim-5796.php'
              specs = parser.parse(dual_sim_micro_sim_phone)

              expect(specs[:general][:sim][:dual_sim]).to be_true
              expect(specs[:general][:sim][:micro_sim]).to be_true
            end
          end
        end

        context 'a phone that has a mini sim' do
          it 'returns that it has a mini sim' do
            VCR.use_cassette 'gsm arena mini sim phone' do
              mini_sim_phone = 'http://www.gsmarena.com/vodafone_155-4969.php'
              specs = parser.parse(mini_sim_phone)

              expect(specs[:general][:sim][:mini_sim]).to be_true
            end
          end
        end

        context 'a phone that has nano sim' do
          it 'returns that it has a nano sim' do
            VCR.use_cassette 'gsm arena nano sim phone' do
              nano_sim_phone = 'http://www.gsmarena.com/apple_iphone_5-4910.php'
              specs = parser.parse(nano_sim_phone)

              expect(specs[:general][:sim][:nano_sim]).to be_true
            end
          end
        end

        context 'a phone that has no sim' do
          it 'returns all the sim types as nil' do
            VCR.use_cassette 'gsm arena no sim phone' do
              no_sim_phone = 'http://www.gsmarena.com/toshiba_excite_pro-5500.php'
              specs = parser.parse(no_sim_phone)

              expect(specs[:general][:sim][:nano_sim]).to be_false
              expect(specs[:general][:sim][:micro_sim]).to be_false
              expect(specs[:general][:sim][:mini_sim]).to be_false
              expect(specs[:general][:sim][:dual_sim]).to be_false
            end
          end
        end
      end

    end

######## DISPLAY SPECS ###########################
    describe 'display specs' do
      it 'returns resolution of the screen' do
        VCR.use_cassette 'gsm arena coming soon phone' do
          coming_soon_phone = 'http://www.gsmarena.com/sony_xperia_e1_dual-5967.php'
          specs = parser.parse(coming_soon_phone)

          expect(specs[:display][:size][:width]).to eql(480)
          expect(specs[:display][:size][:height]).to eql(800)
        end
      end

      it 'returns diagonal of the screen' do
        VCR.use_cassette 'gsm arena coming soon phone' do
          coming_soon_phone = 'http://www.gsmarena.com/sony_xperia_e1_dual-5967.php'
          specs = parser.parse(coming_soon_phone)

          expect(specs[:display][:size][:diagonal]).to eql(4.0)
        end
      end
    end

    
  end #end parse method
end
