require 'open-uri'

class Parser

  def initialize
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
  
  private

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
