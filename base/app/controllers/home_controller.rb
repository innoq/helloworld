class HomeController < ApplicationController

  skip_before_filter :check_login

  def json_home
    respond_to do |format|
      format.json do
        render :json => {:resources => self.resources}
      end
      format.json_home do
        render :json => {:resources => self.resources}
      end
    end
  end

  def register_resources
    raise "Didn't understand JSON Home data" unless params["resources"].is_a?(Hash)
    self.add_resources(params["resources"])
    json_home
  end

  def header
    render "layouts/_header", :layout => false
  end

end
