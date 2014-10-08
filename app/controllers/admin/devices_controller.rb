class Admin::DevicesController < ApplicationController
 before_filter :authenticate_admin!

 layout 'admin'

 def index
   if params[:brand]
     @devices = Device.includes(device_page: [{:category_parsing_result => [{:category_page => :brand}]}]).where("brands.name = ?", params[:brand])
   else
     @devices = Device.all
   end
   respond_to do |format|
     format.html
     format.csv { send_data @devices.to_csv }
   end
 end

end
