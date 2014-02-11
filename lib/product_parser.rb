require 'open-uri'

class ProductParser 
  def parse(url)
    raise 'Parse method not implemented'
  end

  private

  def get_specs(html)
    raise 'Get specs method not defined'
  end

  def clean_html(str)
    str.gsub!(/\r\n?/, "");
    str = ActionView::Base.full_sanitizer.sanitize(str)
    return str
  end
end
