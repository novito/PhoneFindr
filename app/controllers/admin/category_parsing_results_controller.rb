class Admin::CategoryParsingResultsController < ApplicationController
 before_filter :authenticate_admin!

 layout 'admin'

 def show
   @cat_parsing_result = CategoryParsingResult.find_by_id(params[:id])
 end

end
