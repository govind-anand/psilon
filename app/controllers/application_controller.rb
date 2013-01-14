class ApplicationController < ActionController::Base
  protect_from_forgery
  def json_error(errors = nil, status = 406)
    render :json => {:success => false, :errors => errors}, :status => status
  end
  def json_success(data = {})
    render :json => {:success => true}.merge(data)
  end
end
