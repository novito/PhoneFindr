class DeviceCategory < ActiveRecord::Base
  validates :name, presence: true
end
