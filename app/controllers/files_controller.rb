class FilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_project

  def show
    unless params.has_key? :path
      json_error "Path not specified"
      return false
    end
    file = @project.find_file params[:path]
    render :json => {
      :name => file.name,
      :parent => file.parent,
      :content => file.content
    }
  end

  def index
    respond_to do |format|
      format.xml do
        if params.has_key? 'id'
          @id = params[:id]
          render 'subtree'
        else
          render 'index'
        end
      end
      format.json do
        json_success :files => @project.files
      end
    end
  end

  private

  def load_project
    if params.has_key? :project_id
      @project = Project.find params[:project_id]
      if @project.nil?
        json_error "Project not found"
        return false
      end
    else
      json_error "Project not specified"
      return false
    end
  end

  true
end
