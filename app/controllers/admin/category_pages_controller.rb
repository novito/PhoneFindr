class Admin::CategoryPagesController < ApplicationController
 before_filter :authenticate_admin!

 layout 'admin'

 def new
 end
end
