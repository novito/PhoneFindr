require 'gsm_arena_product_parser'

class ParsePageWorker 
  include Sidekiq::Worker
  sidekiq_options queue: "parse_cat"
  sidekiq_options :retry => false

  def perform(device_page_id)
    device_page = DevicePage.find_by_id(device_page_id) 

    page_parser = GsmArenaProductParser.new
    specs = page_parser.parse(device_page.url) if device_page 

    device = Device.new
    device.create_from_specs(specs, device_page_id) if specs
  end
end
