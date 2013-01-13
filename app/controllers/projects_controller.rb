class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  layout false

  def index
    if params.has_key? :user_id
      if params[:user_id] == 'current'
        @projects = current_user.projects
      else
        # Load project list of specified user
      end
    else
      # Load project list of current_user
    end

    respond_to do |format|
      format.html
      format.xml  { render :xml => @projects  }
      format.json { render :json => @projects }
    end
  end

end
