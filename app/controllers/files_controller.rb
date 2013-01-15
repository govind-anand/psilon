class FilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_project

  def get_mode(name)
    # [TODO] Store it in a database
    ext_mode_map = {
      'cpp'    => ['clike'],
      'c'      => ['clike'],
      'c++'    => ['clike'],
      'coffee' => ['coffeescript'],
      'css'    => ['css'],
      'diff'   => ['diff'],
      'haxe'   => ['haxe'],
      'js'     => ['javascript'],
      'less'   => ['less'],
      'lua'    => ['lua'],
      'md'     => ['markdown'],
      'sql'    => ['mysql'],
      'php'    => ['php'],
      'py'     => ['python'],
      'rb'     => ['ruby'],
      'rst'    => ['rst'],
      'sh'     => ['shell'],
      'yaml'   => ['yaml'],
      'html'   => ['css','javascript','xml','htmlmixed']
    }
    ext = name.split('.')[-1]
    if ext_mode_map.has_key? ext
      ext_mode_map[ext]
    else
      'text'
    end
  end

  def show
    unless params.has_key? :path
      json_error "Path not specified"
      return false
    end
    file = @project.find_file params[:path]
    render :json => {
      :name => file.name,
      :parent => file.parent,
      :content => file.get_content,
      :modes => self.get_mode(file.name)
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

  def update
    file = @project.find_file(params[:path])
    unless file.exists
      json_error :file => "Not found"
    end
    if params.has_key? :content
      unless file.set_content(params[:content])
        json_error :file => "could not be saved"
      end
    end
    json_success
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
