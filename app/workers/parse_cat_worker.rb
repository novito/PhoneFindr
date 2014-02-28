require 'gsm_arena_category_parser'

class ParseCatWorker
  include Sidekiq::Worker
  sidekiq_options queue: "parse_cat"

  def perform(result_id, category_page_id)
    cat_page = CategoryPage.find_by_id(category_page_id)

    cat_parser = GsmArenaCategoryParser.new
    results = cat_parser.parse(cat_page.url) if cat_page

    if results
      results.each do |result|
        device_page = DevicePage.create(category_parsing_result_id: result_id, url: result)
        ParsePageWorker.perform_async(device_page.id)
      end
    end
  end
end
