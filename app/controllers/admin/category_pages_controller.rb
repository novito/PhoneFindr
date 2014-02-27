class Admin::CategoryPagesController < ApplicationController
 before_filter :authenticate_admin!

 layout 'admin'

 def new
   @category_page = CategoryPage.new
   @source = Source.find_by_id(params[:source_id])
 end

 def create
   @source = Source.find_by_id(params[:category_page][:source_id])
   @category_page = CategoryPage.new(category_page_params)

   ensure_record_saved(@category_page, 'Category page has been added correctly!')
 end

 def index
   @source = Source.find_by_id(params[:source_id])
   @category_pages = @source.category_pages if @source 
 end

 def show
   @category_page = CategoryPage.find(params[:id])
 end

 def parse
   @category_page = CategoryPage.find(params[:id])
   category_parsing_result = CategoryParsingResult.create(category_page: @category_page, 
                                                          date: DateTime.now) 
   ParseCatWorker.perform_async(category_parsing_result.id, @category_page.id)
 end

 private

 def category_page_params
   params.require(:category_page).permit(:name, :url, :brand_id, :source_id)
 end

 def ensure_record_saved(record, success_message)
   if record.save
     redirect_to admin_category_pages_path, notice: success_message
   else
     flash[:alert] = record.errors.full_messages
     render :new 
   end
 end
end
