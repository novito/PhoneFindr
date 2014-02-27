require 'gsm_arena_category_parser'

class ParseCatWorker
  include Sidekiq::Worker
  sidekiq_options queue: "parse_cat"

  def perform(result_id, category_page_id)
    cat_page = CategoryPage.find_by_id(category_page_id)

    cat_parser = GsmArenaCategoryParser.new
    results = cat_parser.parse(cat_page.url) if cat_page

    results.each do |result|
      DevicePage.create(category_parsing_result_id: result_id, url: result)
    end
  end
end
