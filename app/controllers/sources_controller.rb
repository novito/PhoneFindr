class SourcesController < ApplicationController
 before_filter :authenticate_admin!

 def index
   @sources = Source.all
 end

 def parse
 end
end
