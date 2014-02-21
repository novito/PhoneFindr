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
    
    return results
  end

  def clean_raw_specs(raw_specs)
    specs = {}

    specs[:general] = raw_specs.has_key?('General') ? get_general_spec(raw_specs['General']) : nil
    specs[:display] = raw_specs.has_key?('Display') ? get_display_spec(raw_specs['Display']) : nil
    specs[:features] = raw_specs.has_key?('Features') ? get_features_spec(raw_specs['Features']) : nil
    specs[:memory] = raw_specs.has_key?('Memory') ? get_memory_spec(raw_specs['Memory']) : nil
    specs[:battery] = raw_specs.has_key?('Battery') ? get_battery_spec(raw_specs['Battery']) : nil
    specs[:price] = raw_specs.has_key?('Misc') ? get_price_spec(raw_specs['Misc']) : nil

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
  ##################### MEMORY SPECIFICATIONS #################################
  ##############################################################################
  
  def get_memory_spec(raw_memory_spec)
    memory_spec = {}

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

    return features_spec
  end

  def get_features_os_spec(raw_os)
    return raw_os
  end

  ##############################################################################
  ##################### DISPLAY SPECIFICATIONS #################################
  ##############################################################################

  def get_display_spec(raw_display_spec)
    display_spec = {}

    display_spec[:size] = 
      raw_display_spec.detect { |hash| hash.has_key?('Size') } ?
      get_display_size_spec(raw_display_spec.detect { |hash| hash.has_key?('Size') }['Size'][:text]) : nil

    return display_spec
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

    general_spec[:sim] =
      raw_general_spec.detect { |hash| hash.has_key?('SIM') } ?
      get_sim_spec(raw_general_spec.detect { |hash| hash.has_key?('SIM') }['SIM'][:text]) : nil

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
    raw_sim.downcase!
    sim = {}

    sim[:micro_sim] = raw_sim.include?('micro-sim')
    sim[:mini_sim] = raw_sim.include?('mini-sim')
    sim[:dual_sim] = raw_sim.include?('dual-sim') || raw_sim.include?('dual sim')
    sim[:nano_sim] = raw_sim.include?('nano-sim')

    return sim
  end

end
