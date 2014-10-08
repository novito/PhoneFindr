require 'product_parser'

class GsmArenaProductParser < ProductParser 
  def parse(url)
    results = {}
    html = Nokogiri::HTML(open(url)) 
    raw_specs = get_raw_specs(html)
    results = clean_raw_specs(raw_specs)

    return results
  end

  private

  def get_raw_specs(html)
    results = {}
    tables = html.css('#specs-list table')
    tables.each do |table|
      category_key = table.css('th').text
      results[category_key] = []
      rows = table.css('tr')

      rows.each do |row|
        spec_key = row.css('.ttl').text
        spec_content = row.css('.nfo')
        results[category_key] << {spec_key => {text: spec_content.text, html: spec_content}}
      end
    end

    # Find phone name 
    results[:name] = get_phone_name(html)
    results[:image_url] = get_image_url(html)

    p 'RESULTS WITH IMAGE ARE'
    p results[:image_url]
    return results
  end

  def get_image_url(html)
    image_element = html.css('#specs-cp-pic img')
    image_element.blank? ? nil : image_element.attribute('src').value 
  end

  def get_phone_name(html)
    return html.css('h1').children.first.text
  end

  def clean_raw_specs(raw_specs)
    specs = {}

    specs[:general] = raw_specs.has_key?('General') ? get_general_spec(raw_specs['General']) : nil
    specs[:body] = raw_specs.has_key?('Body') ? get_body_spec(raw_specs['Body']) : nil
    specs[:display] = raw_specs.has_key?('Display') ? get_display_spec(raw_specs['Display']) : nil
    specs[:camera] = raw_specs.has_key?('Camera') ? get_camera_specs(raw_specs['Camera']) : nil
    specs[:sound] = raw_specs.has_key?('Sound') ? get_sound_specs(raw_specs['Sound']) : nil
    specs[:data] = raw_specs.has_key?('Data') ? get_data_specs(raw_specs['Data']) : nil
    specs[:features] = raw_specs.has_key?('Features') ? get_features_spec(raw_specs['Features']) : nil
    specs[:memory] = raw_specs.has_key?('Memory') ? get_memory_spec(raw_specs['Memory']) : nil
    specs[:battery] = raw_specs.has_key?('Battery') ? get_battery_spec(raw_specs['Battery']) : nil
    specs[:price] = raw_specs.has_key?('Misc') ? get_price_spec(raw_specs['Misc']) : nil
    specs[:name] = raw_specs[:name]
    specs[:image_url] = raw_specs[:image_url]

    return specs
  end

  ##############################################################################
  ##################### PRICE SPECIFICATIONS #################################
  ##############################################################################
  
  def get_price_spec(raw_price_spec)
    raw_price_spec.detect { |hash| hash.has_key?('Price group') } ? 
      find_price_in_html(raw_price_spec.detect { |hash| hash.has_key?('Price group') }['Price group'][:html]) : nil
  end

  def find_price_in_html(html)
    img_child = html.children.detect { |chld| chld.name == 'img' }
    unless img_child.nil?
      if img_child.attributes.has_key?('title')
        match_price = /About (\d+) EUR/.match(img_child.attributes['title'].value)
        unless match_price.nil?
          return { value: match_price[1].to_i, currency: 'EUR', type: 'about' }
        end
      end
    end
  end

  ##############################################################################
  ##################### BATTERY SPECIFICATIONS #################################
  ##############################################################################

  def get_battery_spec(raw_battery_spec)
    battery_spec = {}

    battery_spec[:raw_battery_standby] =
      raw_battery_spec.detect { |hash| hash.has_key?('Stand-by') } ?
      raw_battery_spec.detect { |hash| hash.has_key?('Stand-by') }['Stand-by'][:text] : nil

    battery_spec[:raw_battery_talk_time] =
      raw_battery_spec.detect { |hash| hash.has_key?('Talk time') } ?
      raw_battery_spec.detect { |hash| hash.has_key?('Talk time') }['Talk time'][:text] : nil

    battery_spec[:raw_battery_music_play] =
      raw_battery_spec.detect { |hash| hash.has_key?('Music play') } ?
      raw_battery_spec.detect { |hash| hash.has_key?('Music play') }['Music play'][:text] : nil

    battery_spec[:stand_by] = 
      raw_battery_spec.detect { |hash| hash.has_key?('Stand-by') } ?
      get_battery_time(raw_battery_spec.detect { |hash| hash.has_key?('Stand-by') }['Stand-by'][:text]) : nil

    battery_spec[:talk_time] = 
      raw_battery_spec.detect { |hash| hash.has_key?('Talk time') } ?
      get_battery_time(raw_battery_spec.detect { |hash| hash.has_key?('Talk time') }['Talk time'][:text]) : nil

    return battery_spec
  end

  def get_battery_time(raw_stand_by_spec)
    m = /Up to (\d+) h(?: (\d+) min)?/.match(raw_stand_by_spec)
    return m.nil? ? nil : {duration: m[1].to_i * 60 + m[2].to_i, units: 'minutes', type:'up'}
  end

  ##############################################################################
  ##################### CAMERA SPECIFICATIONS #################################
  ##############################################################################

  def get_camera_specs(raw_camera_spec)
    camera_spec = {}

    camera_spec[:raw_camera_primary] =
      raw_camera_spec.detect { |hash| hash.has_key?('Primary') } ?
      raw_camera_spec.detect { |hash| hash.has_key?('Primary') }['Primary'][:text] : nil

    camera_spec[:raw_camera_features] =
      raw_camera_spec.detect { |hash| hash.has_key?('Features') } ?
      raw_camera_spec.detect { |hash| hash.has_key?('Features') }['Features'][:text] : nil

    camera_spec[:raw_camera_video] =
      raw_camera_spec.detect { |hash| hash.has_key?('Video') } ?
      raw_camera_spec.detect { |hash| hash.has_key?('Video') }['Video'][:text] : nil

    camera_spec[:raw_camera_secondary] =
      raw_camera_spec.detect { |hash| hash.has_key?('Secondary') } ?
      raw_camera_spec.detect { |hash| hash.has_key?('Secondary') }['Secondary'][:text] : nil

    return camera_spec
  end


  ##############################################################################
  ##################### DATA SPECIFICATIONS #################################
  ##############################################################################
  
  def get_data_specs(raw_data_spec)
    data_spec = {}

    data_spec[:raw_data_gprs] =
      raw_data_spec.detect { |hash| hash.has_key?('GPRS') } ?
      raw_data_spec.detect { |hash| hash.has_key?('GPRS') }['GPRS'][:text] : nil

    data_spec[:raw_data_edge] =
      raw_data_spec.detect { |hash| hash.has_key?('EDGE') } ?
      raw_data_spec.detect { |hash| hash.has_key?('EDGE') }['EDGE'][:text] : nil

    data_spec[:raw_data_speed] =
      raw_data_spec.detect { |hash| hash.has_key?('Speed') } ?
      raw_data_spec.detect { |hash| hash.has_key?('Speed') }['Speed'][:text] : nil

    data_spec[:raw_data_wlan] =
      raw_data_spec.detect { |hash| hash.has_key?('WLAN') } ?
      raw_data_spec.detect { |hash| hash.has_key?('WLAN') }['WLAN'][:text] : nil

    data_spec[:raw_data_bluetooth] =
      raw_data_spec.detect { |hash| hash.has_key?('Bluetooth') } ?
      raw_data_spec.detect { |hash| hash.has_key?('Bluetooth') }['Bluetooth'][:text] : nil

    data_spec[:raw_data_usb] =
      raw_data_spec.detect { |hash| hash.has_key?('USB') } ?
      raw_data_spec.detect { |hash| hash.has_key?('USB') }['USB'][:text] : nil

    return data_spec
  end

  ##############################################################################
  ##################### MEMORY SPECIFICATIONS #################################
  ##############################################################################
  
  def get_memory_spec(raw_memory_spec)
    memory_spec = {}

    memory_spec[:raw_memory_internal] =
      raw_memory_spec.detect { |hash| hash.has_key?('Internal') } ?
      raw_memory_spec.detect { |hash| hash.has_key?('Internal') }['Internal'][:text] : nil

    memory_spec[:raw_memory_card_slot] =
      raw_memory_spec.detect { |hash| hash.has_key?('Card slot') } ?
      raw_memory_spec.detect { |hash| hash.has_key?('Card slot') }['Card slot'][:text] : nil

    memory_spec[:internal] = 
      raw_memory_spec.detect { |hash| hash.has_key?('Internal') } ?
      get_memory_internal_spec(raw_memory_spec.detect { |hash| hash.has_key?('Internal') }['Internal'][:text]) : nil

    return memory_spec
  end

  def get_memory_internal_spec(raw_internal_spec)
    # Differentiate with comma to get RAM too
    splitted_memory = raw_internal_spec.split(',')
    internal_storage = nil
    ram_storage = nil

    if splitted_memory[0].include?('RAM')
      ram_storage = get_ram_memory(splitted_memory[0])
    else
      internal_storage = get_internal_storage(splitted_memory[0])
    end

    if splitted_memory.size > 1 && splitted_memory[1].include?('RAM')
      ram_storage = get_ram_memory(splitted_memory[1])
    end

    return {storage: internal_storage, ram: ram_storage}
  end

  def get_ram_memory(ram_string)
    ram_storage = ram_string.match(/(\d+)\s*([MG]B)/)
    unless ram_storage.nil?
      return {size: ram_storage[1].to_i, unit: ram_storage[2]}
    end
  end

  def get_internal_storage(internal_storage_string)
    internal_storage_result = []
    internal_storage = internal_storage_string.scan(/(\d+)(?=(?:\/\d+)*\s*([MG]B))/)

    internal_storage.each do |is|
      internal_storage_result << {size: is[0].to_i, unit: is[1]}
    end

    return internal_storage_result
  end

  ##############################################################################
  ##################### FEATURES SPECIFICATIONS #################################
  ##############################################################################

  def get_features_spec(raw_features_spec)
    features_spec = {}

    features_spec[:os] = 
      raw_features_spec.detect { |hash| hash.has_key?('OS') } ?
      get_features_os_spec(raw_features_spec.detect { |hash| hash.has_key?('OS') }['OS'][:text]) : nil

    features_spec[:raw_features_chipset] = 
      raw_features_spec.detect { |hash| hash.has_key?('Chipset') } ?
      raw_features_spec.detect { |hash| hash.has_key?('Chipset') }['Chipset'][:text] : nil

    features_spec[:raw_features_cpu] = 
      raw_features_spec.detect { |hash| hash.has_key?('CPU') } ?
      raw_features_spec.detect { |hash| hash.has_key?('CPU') }['CPU'][:text] : nil

    features_spec[:raw_features_gpu] = 
      raw_features_spec.detect { |hash| hash.has_key?('GPU') } ?
      raw_features_spec.detect { |hash| hash.has_key?('GPU') }['GPU'][:text] : nil

    features_spec[:raw_features_sensors] = 
      raw_features_spec.detect { |hash| hash.has_key?('Sensors') } ?
      raw_features_spec.detect { |hash| hash.has_key?('Sensors') }['Sensors'][:text] : nil

    features_spec[:raw_features_messaging] = 
      raw_features_spec.detect { |hash| hash.has_key?('Messaging') } ?
      raw_features_spec.detect { |hash| hash.has_key?('Messaging') }['Messaging'][:text] : nil

    features_spec[:raw_features_browser] = 
      raw_features_spec.detect { |hash| hash.has_key?('Browser') } ?
      raw_features_spec.detect { |hash| hash.has_key?('Browser') }['Browser'][:text] : nil

    features_spec[:raw_features_radio] = 
      raw_features_spec.detect { |hash| hash.has_key?('Radio') } ?
      raw_features_spec.detect { |hash| hash.has_key?('Radio') }['Radio'][:text] : nil

    features_spec[:raw_features_gps] = 
      raw_features_spec.detect { |hash| hash.has_key?('GPS') } ?
      raw_features_spec.detect { |hash| hash.has_key?('GPS') }['GPS'][:text] : nil

    features_spec[:raw_features_java] = 
      raw_features_spec.detect { |hash| hash.has_key?('Java') } ?
      raw_features_spec.detect { |hash| hash.has_key?('Java') }['Java'][:text] : nil

    features_spec[:raw_features_colors] = 
      raw_features_spec.detect { |hash| hash.has_key?('Colors') } ?
      raw_features_spec.detect { |hash| hash.has_key?('Colors') }['Colors'][:text] : nil

    return features_spec
  end

  def get_features_os_spec(raw_os)
    return raw_os
  end

  ##############################################################################
  ##################### BODY SPECIFICATIONS #################################
  ##############################################################################
  
  def get_body_spec(raw_body_spec)
    body_spec = {}

    body_spec[:raw_dimensions] = 
      raw_body_spec.detect { |hash| hash.has_key?('Dimensions') } ?
      raw_body_spec.detect { |hash| hash.has_key?('Dimensions') }['Dimensions'][:text] : nil

    body_spec[:raw_weight] = 
      raw_body_spec.detect { |hash| hash.has_key?('Weight') } ?
      raw_body_spec.detect { |hash| hash.has_key?('Weight') }['Weight'][:text] : nil

    return body_spec
  end

  ##############################################################################
  ##################### DISPLAY SPECIFICATIONS #################################
  ##############################################################################

  def get_display_spec(raw_display_spec)
    display_spec = {}

    display_spec[:raw_display_type] =
      raw_display_spec.detect { |hash| hash.has_key?('Type') } ?
      raw_display_spec.detect { |hash| hash.has_key?('Type') }['Type'][:text] : nil

    display_spec[:raw_display_size] =
      raw_display_spec.detect { |hash| hash.has_key?('Size') } ?
      raw_display_spec.detect { |hash| hash.has_key?('Size') }['Size'][:text] : nil

    display_spec[:size] = 
      raw_display_spec.detect { |hash| hash.has_key?('Size') } ?
      get_display_size_spec(raw_display_spec.detect { |hash| hash.has_key?('Size') }['Size'][:text]) : nil

    return display_spec
  end

  ##############################################################################
  ##################### SOUND SPECIFICATIONS #################################
  ##############################################################################

  def get_sound_specs(raw_sound_spec)
    sound_spec = {}
    p 'SOUND SPEC'
    p raw_sound_spec

    sound_spec[:raw_sound_alert_types] =
      raw_sound_spec.detect { |hash| hash.has_key?('Alert types') } ?
      raw_sound_spec.detect { |hash| hash.has_key?('Alert types') }['Alert types'][:text] : nil

    sound_spec[:raw_sound_loudspeaker] =
      raw_sound_spec.detect { |hash| hash.has_key?('Loudspeaker ') } ?
      raw_sound_spec.detect { |hash| hash.has_key?('Loudspeaker ') }['Loudspeaker '][:text] : nil

    sound_spec[:raw_sound_35_mm_jack] = 
      raw_sound_spec.detect { |hash| hash.has_key?('3.5mm jack ') } ?
      raw_sound_spec.detect { |hash| hash.has_key?('3.5mm jack ') }['3.5mm jack '][:text] : nil

    return sound_spec
  end


  def get_display_size_spec(raw_size)
    display_size = {}

    display_size.merge!(get_display_size_resolution_spec(raw_size))
    display_size.merge!(get_display_size_diagonal_spec(raw_size))

    return display_size
  end

  def get_display_size_diagonal_spec(raw_size)
    display_diagonal = /(\d+\.?\d+)\sinch/.match(raw_size)

    return display_diagonal.nil? ? {diagonal: nil} : {diagonal: display_diagonal[1].to_f}
  end

  def get_display_size_resolution_spec(raw_size)
    display_size_resolution = /(\d+)\sx\s(\d+)\spixels/.match(raw_size)

    return display_size_resolution.nil? ? 
      {width: nil, height: nil} : {width: display_size_resolution[1].to_i, height: display_size_resolution[2].to_i}
  end

  ##############################################################################
  ##################### GENERAL SPECIFICATIONS #################################
  ##############################################################################

  def get_general_spec(raw_general_spec)
    general_spec = {}

    general_spec[:announced] = 
      raw_general_spec.detect { |hash| hash.has_key?('Announced') } ?
      get_announced_spec(raw_general_spec.detect { |hash| hash.has_key?('Announced') }['Announced'][:text]) : nil

    general_spec[:status] = 
      raw_general_spec.detect { |hash| hash.has_key?('Status') } ? 
      get_status_spec(raw_general_spec.detect { |hash| hash.has_key?('Status') }['Status'][:text]) : nil

    general_spec[:raw_status] =
      raw_general_spec.detect { |hash| hash.has_key?('Status') } ? 
      get_raw_status_spec(raw_general_spec.detect { |hash| hash.has_key?('Status') }['Status'][:text]) : nil

    general_spec[:sim] =
      raw_general_spec.detect { |hash| hash.has_key?('SIM') } ?
      get_sim_spec(raw_general_spec.detect { |hash| hash.has_key?('SIM') }['SIM'][:text]) : nil

    general_spec[:raw_network_2g] =
      raw_general_spec.detect { |hash| hash.has_key?('2G Network') } ?
      raw_general_spec.detect { |hash| hash.has_key?('2G Network') }['2G Network'][:text] : nil

    general_spec[:raw_network_3g] =
      raw_general_spec.detect { |hash| hash.has_key?('3G Network') } ?
      raw_general_spec.detect { |hash| hash.has_key?('3G Network') }['3G Network'][:text] : nil

    general_spec[:raw_network_4g] =
      raw_general_spec.detect { |hash| hash.has_key?('4G Network') } ?
      raw_general_spec.detect { |hash| hash.has_key?('4G Network') }['4G Network'][:text] : nil

    return general_spec
  end

  def get_announced_spec(raw_announced)
    release_date = raw_announced[/(\d{4},\s*[A-Z][a-z]+)/]
    return release_date.nil? ? nil : Date.parse(release_date)
  end

  def get_status_spec(raw_status)
    status = {}
    status[:available] = get_status_availability(raw_status)
    status[:release_date] = get_release_date(raw_status)
    return status
  end

  def get_raw_status_spec(raw_status)
    return raw_status
  end

  def get_release_date(raw_status)
    release_date = raw_status[/Released\s+(\d{4},\s*[A-Z][a-z]+)/]
    return release_date.nil? ? nil : Date.parse(release_date)
  end
  
  def get_status_availability(raw_status)
    case raw_status.downcase
    when /available/
      true
    when /coming soon/
      false
    when /discontinued/
      false
    else
      nil
    end
  end

  def get_sim_spec(raw_sim)
    return raw_sim
    raw_sim.downcase!
    sim = {}

    #sim[:micro_sim] = raw_sim.include?('micro-sim')
    #sim[:mini_sim] = raw_sim.include?('mini-sim')
    #sim[:dual_sim] = raw_sim.include?('dual-sim') || raw_sim.include?('dual sim')
    #sim[:nano_sim] = raw_sim.include?('nano-sim')

    return sim
  end

end
