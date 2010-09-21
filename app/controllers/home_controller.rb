class HomeController < ApplicationController
  before_filter :setup_context, :only => 'dashboard'
end
