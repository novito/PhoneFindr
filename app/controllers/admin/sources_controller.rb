class Admin::SourcesController < ApplicationController
 before_filter :authenticate_admin!

 layout 'admin'

 def index
   @sources = Source.all
 end

 def new
   @source = Source.new
 end

 def create
   @source = Source.new(source_params)

   ensure_record_saved(@source, 'Source has been created!')
 end

 private

 def source_params
   params.require(:source).permit(:name, :url)
 end

 def ensure_record_saved(record, success_message)
   if record.save
     redirect_to admin_sources_path, notice: success_message
   else
     redirect_to admin_sources_path, alert: record.errors.full_messages
   end
 end

end
