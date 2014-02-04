VCR.configure do |c|
  #the directory where your cassettes will be saved
  c.cassette_library_dir = Rails.root.join("spec", "vcr") 
  # your HTTP request service. You can also use fakeweb, webmock, and more
  c.hook_into :webmock
end
