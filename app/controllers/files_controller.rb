class FilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_project
  before_filter :load_file, :only => [:show, :update, :destroy]

  def show
    render :json => {
      :pid      => @project.id,
      :name     => @file.name,
      :parent   => @file.parent,
      :content  => @file.get_content,
      :modes    => @file.get_mode
    }
  end

  def index
    root = params[:root] || '/'
    respond_to do |format|
      format.json do
        json_success({
          :pid    => @project.id,
          :name   => @project.name,
          :root   => root,
          :files  => @project.files(root)
        })
      end
    end
  end

  def update
    if params.has_key? :content
      unless @file.set_content params[:content]
        #[TODO] Log and notify error to admin
        return json_error :file => "could not be saved"
      end
    end
    if params.has_key? :parent
      unless @file.set_parent params[:parent]
        #[TODO] Log and notify error to admin
        return json_error :file => "could not be moved"
      end
    end
    if params.has_key? :name
      unless @file.set_name params[:name]
        return json_error :file => "Could not be renamed"
      end
    end
    json_success
  end

  def destroy
    if @file.delete
      json_success
    else
      #[TODO] Log and notify error to admin
      json_error :file => "could not be deleted"
    end
  end

  private

  def load_project
    if params.has_key? :project_id
      @project = Project.find params[:project_id]
      if @project.nil?
        json_error :project => "Not found"
        return false
      end
    else
      json_error :project => "Not specified"
      return false
    end
  end

  def load_file
    if params.has_key? :path
      @file = @project.find_file params[:path]
      unless @file.exists
        return json_error :file => "Not found"
      end
    else 
      json_error :file => "Not specified"
      return false
    end
  end
end
