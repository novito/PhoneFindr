class Device < ActiveRecord::Base
  belongs_to :device_page

  def create_from_specs(specs, device_page_id)
    p "Specs are"
    p specs
    self.device_page_id = device_page_id
    self.name = specs[:name]
    self.operating_system = specs[:features][:os] if specs.has_key?(:features) && specs[:features].has_key?(:os)
    if specs.has_key?(:general) && 
      specs[:general].has_key?(:status) && 
      specs[:general][:status].has_key?(:available) 

      self.available = specs[:general][:status][:available] 
    end

    p "SELF IS"
    p self
    self.save!
  end
end
