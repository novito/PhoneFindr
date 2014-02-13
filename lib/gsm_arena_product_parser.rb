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
        spec_content = row.css('.nfo').text
        results[category_key] << {spec_key => clean_html(spec_content)}
      end
    end
    
    return results
  end

  def clean_raw_specs(raw_specs)
    specs = {}
    specs[:general] = raw_specs.has_key?('General') ? get_general_spec(raw_specs['General']) : nil
    specs[:display] = raw_specs.has_key?('Display') ? get_display_spec(raw_specs['Display']) : nil

    return specs
  end

  def get_display_spec(raw_display_spec)
    display_spec = {}

    display_spec[:size] = 
      raw_display_spec.detect { |hash| hash.has_key?('Size') } ?
      get_display_size_spec(raw_display_spec.detect { |hash| hash.has_key?('Size') }['Size']) : nil

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

  def get_general_spec(raw_general_spec)
    general_spec = {}

    general_spec[:announced] = 
      raw_general_spec.detect { |hash| hash.has_key?('Announced') } ?
      get_announced_spec(raw_general_spec.detect { |hash| hash.has_key?('Announced') }['Announced']) : nil

    general_spec[:status] = 
      raw_general_spec.detect { |hash| hash.has_key?('Status') } ? 
      get_status_spec(raw_general_spec.detect { |hash| hash.has_key?('Status') }['Status']) : nil

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
    else
      nil
    end
  end

end
