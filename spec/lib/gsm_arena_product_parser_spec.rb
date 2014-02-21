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

################################################## 
######## GENERAL SPECS ###########################
################################################## 
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

################################################## 
######## DISPLAY SPECS ###########################
################################################## 

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

################################################## 
######## FEATURES SPECS ###########################
################################################## 
    
    describe 'features specs' do
      context 'a phone that has an operating system' do
        it 'returns operating system of the phone' do
          VCR.use_cassette 'gsm arena windows phone' do
            windows_phone = 'http://www.gsmarena.com/nokia_lumia_2520-5702.php'
            specs = parser.parse(windows_phone)

            expect(specs[:features][:os]).to eql('Microsoft Windows RT')
          end
        end
      end

      context 'a phone that doesnt have an operating system' do
        it 'returns a nil operating system' do
          VCR.use_cassette 'gsm arena non operating system phone' do
            non_os_phone = 'http://www.gsmarena.com/nokia_3110-23.php'
            specs = parser.parse(non_os_phone)

            expect(specs[:features][:os]).to be_nil
          end
        end
      end
    end

################################################## 
######## Memory SPECS ###########################
################################################## 
  

    describe 'battery specs' do
      it 'returns the stand by and talk time in minutes' do
        VCR.use_cassette 'gsm arena stand by in hours and talk time in hours & minutes' do
            talk_time_minutes_phone = 'http://www.gsmarena.com/nokia_108_dual_sim-5703.php'
            specs = parser.parse(talk_time_minutes_phone)

            expect(specs[:battery][:stand_by]).to eq({duration: 600*60, units:'minutes', type:'up'})
            expect(specs[:battery][:talk_time]).to eq({duration: 13*60 + 40, units:'minutes', type:'up'})
        end
      end

      it 'returns the first stand by and talk time in minutes if there are many' do
        VCR.use_cassette 'gsm arena many talk time and stand by phone' do
          many_talk_time_phone = 'http://www.gsmarena.com/xolo_a500s_ips-5839.php'
          specs = parser.parse(many_talk_time_phone)

          expect(specs[:battery][:stand_by]).to eq({duration: 492*60, units:'minutes', type:'up'})
          expect(specs[:battery][:talk_time]).to eq({duration: 10*60, units:'minutes', type:'up'})
        end
      end

      it 'returns nil if there is no data for battery specs' do
        VCR.use_cassette 'gsm arena no data for battery specs' do
          no_battery_data_phone = 'http://www.gsmarena.com/acer_liquid_glow_e330-4589.php'
          specs = parser.parse(no_battery_data_phone)

          expect(specs[:battery][:stand_by]).to be_nil
          expect(specs[:battery][:talk_time]).to be_nil
        end
      end
    end

################################################## 
######## Price SPECS ###########################
################################################## 

    describe 'price specs' do
      it 'returns a price' do
        VCR.use_cassette 'gsm arena nokia lumia' do
          nokia_lumia = 'http://www.gsmarena.com/nokia_lumia_1520-5760.php'
          specs = parser.parse(nokia_lumia)

          expect(specs[:price]).to eq({value: 430, currency: 'EUR', type: 'about'})
        end
      end
    end

################################################## 
######## Memory SPECS ###########################
################################################## 

    describe 'memory specs' do
      context 'a phone with a single memory' do
        it 'returns a single memory storage number' do
          VCR.use_cassette 'gsm arena phone single memory' do
            single_memory_phone = 'http://www.gsmarena.com/motorola_moto_g_dual_sim-5978.php'
            specs = parser.parse(single_memory_phone)

            expect(specs[:memory][:internal][0]).to eq({size:8, unit: 'GB'})
          end
        end
      end

      context 'a phone which just have RAM memory' do
        it 'returns no internal memory' do
          VCR.use_cassette 'gsm arena phone just RAM' do
            just_ram_phone = 'http://www.gsmarena.com/nokia_108_dual_sim-5703.php'
            specs = parser.parse(just_ram_phone)

            expect(specs[:memory][:internal]).to be_nil
          end

        end
      end

      context 'a phone with multiple memory' do
        it 'returns multiple memory storage numbers' do
          VCR.use_cassette 'gsm arena phone multiple memory' do
            multiple_memory_phone = 'http://www.gsmarena.com/motorola_moto_g_dual_sim-5978.php'
            specs = parser.parse(multiple_memory_phone)

            expect(specs[:memory][:internal][0]).to eq({size:8, unit: 'GB'})
            expect(specs[:memory][:internal][1]).to eq({size:16, unit: 'GB'})
          end
        end

        # Cases like this: 16 GB (RM-940 only)/32 GB, 2 GB RAM
        it 'returns multiple memory storage numbers, even if there is other text in between those' do
          VCR.use_cassette 'gsm arena phone multiple memory dirty text' do
            multiple_memory_phone = 'http://www.gsmarena.com/nokia_lumia_1520-5760.php'
            specs = parser.parse(multiple_memory_phone)

            expect(specs[:memory][:internal][0]).to eq({size:16, unit: 'GB'})
            expect(specs[:memory][:internal][1]).to eq({size:32, unit: 'GB'})
          end
        end
      end

    end

  end #end parse method
end


