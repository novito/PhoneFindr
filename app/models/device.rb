require 'csv'
class Device < ActiveRecord::Base
  belongs_to :device_page

  OS_ANGULAR_RAILS_MAPPING = {'win' => 'Windows', 'ios' => 'iOS', 'android' => 'Android'} 

  def create_from_specs(specs, device_page_id)
    p 'specs are'
    p specs
    self.device_page_id = device_page_id
    self.name = specs[:name]
    self.image_url = specs[:image_url]
    self.raw_price = specs[:price][:value] if specs.has_key?(:price) && !specs[:price].nil? && specs[:price].has_key?(:value)
    self.operating_system = specs[:features][:os] if specs.has_key?(:features) && specs[:features].has_key?(:os)

    if specs.has_key?(:display)
      if specs[:display].has_key?(:raw_display_type)
        self.raw_display_type = specs[:display][:raw_display_type]
      end
      if specs[:display].has_key?(:raw_display_size)
        self.raw_display_size = specs[:display][:raw_display_size]
      end
    end

    if specs.has_key?(:battery)
      if specs[:battery].has_key?(:raw_battery_standby)
        self.raw_battery_standby = specs[:battery][:raw_battery_standby]
      end
      if specs[:battery].has_key?(:raw_battery_talk_time)
        self.raw_battery_talk_time = specs[:battery][:raw_battery_talk_time]
      end
      if specs[:battery].has_key?(:raw_battery_music_play)
        self.raw_battery_music_play = specs[:battery][:raw_battery_music_play]
      end
    end

    if specs.has_key?(:features)
      if specs[:features].has_key?(:raw_features_chipset)
        self.raw_features_chipset = specs[:features][:raw_features_chipset]
      end
      if specs[:features].has_key?(:raw_features_cpu)
        self.raw_features_cpu = specs[:features][:raw_features_cpu]
      end
      if specs[:features].has_key?(:raw_features_gpu)
        self.raw_features_gpu = specs[:features][:raw_features_gpu]
      end
      if specs[:features].has_key?(:raw_features_sensors)
        self.raw_features_sensors = specs[:features][:raw_features_sensors]
      end
      if specs[:features].has_key?(:raw_features_messaging)
        self.raw_features_messaging = specs[:features][:raw_features_messaging]
      end
      if specs[:features].has_key?(:raw_features_browser)
        self.raw_features_browser = specs[:features][:raw_features_browser]
      end
      if specs[:features].has_key?(:raw_features_radio)
        self.raw_features_radio = specs[:features][:raw_features_radio]
      end
      if specs[:features].has_key?(:raw_features_gps)
        self.raw_features_gps = specs[:features][:raw_features_gps]
      end
      if specs[:features].has_key?(:raw_features_java)
        self.raw_features_java = specs[:features][:raw_features_java]
      end
      if specs[:features].has_key?(:raw_features_colors)
        self.raw_features_colors = specs[:features][:raw_features_colors]
      end
    end

    if specs.has_key?(:camera)
      if specs[:camera].has_key?(:raw_camera_primary)
        self.raw_camera_primary = specs[:camera][:raw_camera_primary]
      end
      if specs[:camera].has_key?(:raw_camera_features)
        self.raw_camera_features = specs[:camera][:raw_camera_features]
      end
      if specs[:camera].has_key?(:raw_camera_video)
        self.raw_camera_video = specs[:camera][:raw_camera_video]
      end
      if specs[:camera].has_key?(:raw_camera_secondary)
        self.raw_camera_secondary = specs[:camera][:raw_camera_secondary]
      end
    end

    if specs.has_key?(:data)
      if specs[:data].has_key?(:raw_data_gprs)
        self.raw_data_gprs = specs[:data][:raw_data_gprs]
      end
      if specs[:data].has_key?(:raw_data_edge)
        self.raw_data_edge = specs[:data][:raw_data_edge]
      end
      if specs[:data].has_key?(:raw_data_speed)
        self.raw_data_speed = specs[:data][:raw_data_speed]
      end
      if specs[:data].has_key?(:raw_data_wlan)
        self.raw_data_wlan = specs[:data][:raw_data_wlan]
      end
      if specs[:data].has_key?(:raw_data_bluetooth)
        self.raw_data_bluetooth = specs[:data][:raw_data_bluetooth]
      end
      if specs[:data].has_key?(:raw_data_usb)
        self.raw_data_usb = specs[:data][:raw_data_usb]
      end
    end

    if specs.has_key?(:sound)
      if specs[:sound].has_key?(:raw_sound_alert_types)
        self.raw_sound_alert_types = specs[:sound][:raw_sound_alert_types]
      end
      if specs[:sound].has_key?(:raw_sound_loudspeaker)
        self.raw_sound_loudspeaker = specs[:sound][:raw_sound_loudspeaker]
      end
      if specs[:sound].has_key?(:raw_sound_35_mm_jack)
        self.raw_sound_35_mm_jack = specs[:sound][:raw_sound_35_mm_jack]
      end
    end

    if specs.has_key?(:memory)
      if specs[:memory].has_key?(:raw_memory_card_slot)
        self.raw_memory_card_slot = specs[:memory][:raw_memory_card_slot]
      end
      if specs[:memory].has_key?(:raw_memory_internal)
        self.raw_memory_internal = specs[:memory][:raw_memory_internal]
      end
    end

    if specs.has_key?(:body)
      if specs[:body].has_key?(:raw_dimensions)
        self.raw_dimensions = specs[:body][:raw_dimensions]
      end
      if specs[:body].has_key?(:raw_weight)
        self.raw_weight = specs[:body][:raw_weight]
      end
    end

    if specs.has_key?(:general) 
      if specs[:general].has_key?(:status) && 
      specs[:general][:status].has_key?(:available) 
      self.available = specs[:general][:status][:available] 
      end

      if specs[:general].has_key?(:raw_status)
        self.raw_status = specs[:general][:raw_status]
      end

      if specs[:general].has_key?(:announced)
        self.announced = specs[:general][:announced]
      end

      if specs[:general].has_key?(:sim)
        self.raw_sim = specs[:general][:sim]
      end

      if specs[:general].has_key?(:raw_network_2g)
        self.raw_network_2g = specs[:general][:raw_network_2g]
      end

      if specs[:general].has_key?(:raw_network_2g)
        self.raw_network_2g = specs[:general][:raw_network_2g]
      end

      if specs[:general].has_key?(:raw_network_3g)
        self.raw_network_3g = specs[:general][:raw_network_3g]
      end

      if specs[:general].has_key?(:raw_network_4g)
        self.raw_network_4g = specs[:general][:raw_network_4g]
      end

    end

    self.save!
  end

  def self.main_survey(params)
    if params.has_key?('os')
      by_os(params['os'])
    end
    if params.has_key?('longHour') && !params['longHour'].empty?
      by_long_hour(params['longhour'])
    end
  end

  def self.by_os(os)
    return where(OS_ANGULAR_RAILS_MAPPING['os'])

  end

  def self.to_csv(options = {})
    CSV.generate(force_quotes: true) do |csv|
      csv << ['id', 'name', 'image url', 'price',
              '2G Network', '3G Network', '4G Network',
              'SIM', 'Announced', 'Status', 'Dimensions',
              'Weight', 'Type', 'Size', 'Alert types',
              'Loudspeaker', '3.5mm jack', 'Card slot', 'Internal',
              'GPRS', 'EDGE', 'Speed', 'WLAN',
              'Bluetooth', 'USB', 'Primary', 'Features',
              'Video', 'Secondary', 'OS', 'Chipset',
              'CPU', 'GPU', 'Sensors', 'Messaging',
              'Browser', 'Radio', 'GPS', 'Java',
              'Colors', 'Stand-by', 'Talk time', 'Music Play']

      all.each do |device|
        csv << [device.id, device.name, device.image_url, device.raw_price,
                device.raw_network_2g, device.raw_network_3g, device.raw_network_4g,
                device.raw_sim, device.announced, device.raw_status, device.raw_dimensions,
                device.raw_weight, device.raw_display_type, device.raw_display_size, device.raw_sound_alert_types,
                device.raw_sound_loudspeaker, device.raw_sound_35_mm_jack, device.raw_memory_card_slot, device.raw_memory_internal,
                device.raw_data_gprs, device.raw_data_edge, device.raw_data_speed, device.raw_data_wlan,
                device.raw_data_bluetooth, device.raw_data_usb, device.raw_camera_primary, device.raw_camera_features,
                device.raw_camera_video, device.raw_camera_secondary, device.operating_system, device.raw_features_chipset,
                device.raw_features_cpu, device.raw_features_gpu, device.raw_features_sensors, device.raw_features_messaging,
                device.raw_features_browser, device.raw_features_radio, device.raw_features_gps, device.raw_features_java,
                device.raw_features_colors, device.raw_battery_standby, device.raw_battery_talk_time, device.raw_battery_music_play]

      end
    end
  end

end
