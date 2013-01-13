class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => ['workspace']
  def workspace
    render :layout => false
  end
end
