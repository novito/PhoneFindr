class Device < ActiveRecord::Base
  belongs_to :device_page

  OS_ANGULAR_RAILS_MAPPING = {'win' => 'Windows', 'ios' => 'iOS', 'android' => 'Android'} 

  def create_from_specs(specs, device_page_id)
    self.device_page_id = device_page_id
    self.name = specs[:name]
    self.operating_system = specs[:features][:os] if specs.has_key?(:features) && specs[:features].has_key?(:os)

    if specs.has_key?(:display)
      if specs[:display].has_key?(:raw_display_type)
        self.raw_display_type = specs[:display][:raw_display_type]
      end
      if specs[:display].has_key?(:raw_display_size)
        self.raw_display_size = specs[:display][:raw_display_size]
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

end
