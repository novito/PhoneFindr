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

    return specs
  end

  def get_general_spec(raw_general_spec)
    general_spec = {}

    general_spec[:status] = 
      raw_general_spec.detect { |hash| hash.has_key?('Status') } ? 
      get_status_spec(raw_general_spec.detect { |hash| hash.has_key?('Status') }['Status']) : nil

    return general_spec
  end

  def get_status_spec(raw_status)
    case raw_status.downcase!
    when /available/
      {:available => true}
    when /coming soon/
      {:available => false}
    else
      nil
    end
  end

end
