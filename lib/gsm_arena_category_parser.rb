require 'category_parser'

class GsmArenaCategoryParser < CategoryParser
  def parse(url)
    current_page = 1
    num_pages = 1

    current_url = url
    html = Nokogiri::HTML(open(current_url)) 
    num_pages = find_n_pages(html)
    anchors = []

    # @TODO remove this on production parsing ~ We want to get all the page
    #num_pages = 1

    while current_page <= num_pages 
      html.css('.makers li a').each do |anchor|
        begin
          anchors << build_absolute_url(url, anchor['href']) 
        rescue
          next
        end
      end

      current_page += 1
      if current_page <= num_pages
        current_url.gsub!(/p\d\.php/, 'p' + current_page.to_s + '.php')
        html = Nokogiri::HTML(open(current_url)) 
      end
    end

    return anchors
  end

  private

  def find_n_pages(base_page)
    n_pages = base_page.css('.nav-pages a').size

    if !n_pages.blank? && n_pages == 0
      n_pages = 1
    end

    n_pages
  end

  def build_absolute_url(main_url, product_url)
    uri = URI.parse(product_url)
    unless uri.host
      product_url = URI.join(main_url, product_url).to_s
    end
    return product_url
  end

end
