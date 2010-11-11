class HomeController < ApplicationController

  skip_before_filter :check_login, :only => [:about, :header]

  def index

  end

  def header
    render "layouts/_header", :layout => false
  end

end
