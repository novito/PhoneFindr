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

 def destroy
   @source = Source.find_by_id(params[:id])
   @source.destroy
   redirect_to admin_sources_path, notice: 'Source deleted correctly.'
 end

 private

 def source_params
   params.require(:source).permit(:name, :url)
 end

 def ensure_record_saved(record, success_message)
   if record.save
     redirect_to admin_sources_path, notice: success_message
   else
     flash[:alert] = record.errors.full_messages
     render :new 
   end
 end

end
