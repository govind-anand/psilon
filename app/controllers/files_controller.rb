class FilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_project

  def index
    respond_to do |format|
      format.xml do
        puts "---->", params
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
