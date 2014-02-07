require 'open-uri'

class Parser

  def initialize
    @general_keys = ['2G Network', '3G Network', '4G Network', 'SIM', 'Announced', 'Status']
  end

  def parse_cat(url)
    current_page = 1
    num_pages = 1

    current_url = url
    html = Nokogiri::HTML(open(current_url)) 
    num_pages = find_n_pages(html)
    anchors = []

    while current_page <= num_pages 
      html.css('.makers li a').each { |anchor| anchors << build_absolute_url(url, anchor['href']) }

      current_page += 1
      if current_page <= num_pages
        current_url.gsub!(/p\d\.php/, 'p' + current_page.to_s + '.php')
        puts current_url
        html = Nokogiri::HTML(open(current_url)) 
      end
    end

    return anchors
  end

  def parse_page(url)
    results = {}
    html = Nokogiri::HTML(open(url)) 
    results = get_specs(html)

    return results
  end
  
  private

  def get_specs(html)
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

  def clean_html(str)
    str.gsub!(/\r\n?/, "");
    str = ActionView::Base.full_sanitizer.sanitize(str)
    return str
  end

  def find_n_pages(base_page)
    return base_page.css('.nav-pages a').size
  end

  def build_absolute_url(main_url, product_url)
    uri = URI.parse(product_url)
    unless uri.host
      product_url = URI.join( main_url, product_url ).to_s
    end
    return product_url
  end

end
