require 'fileutils'

class FileProxy

  include Authority::Abilities
  self.authorizer_name = 'FileAuthorizer'

  attr_reader :path, :exists, :stat, :project

  def abs_path
    File.join(@project.root, @path)
  end

  def initialize(config)
    @path = config[:path]
    @project = config[:project]
    abs_path = self.abs_path
    @exists = File.exists? abs_path
    if @exists
      @stat = File.stat abs_path
    end
  end

  def as_json(options = {})
    attrs = {}
    attrs[:path] = @path
    attrs[:exists] = @exists
    if @exists
      attrs[:type] = if @stat.directory? then :directory else :file end
    end
    attrs
  end

  def name
    @path.split('/')[-1]
  end

  def parent
    @path.split('/')[0...-1].join('/')
  end

  def set_parent(path)
    begin
      FileUtils.mv abs_path, File.join(@project.root, path)
      @path = path
    rescue Errno::EACCES
      @errors = {:permission => "denied"}
      return false
    end
    true
  end

  def delete
    begin
      if @stat.directory?
        FileUtils.rm_rf abs_path
      else
        File.delete abs_path
      end
    rescue Errno::EACCES
      @error = {:permission => "denied"}
    end
  end

  def get_content
    if @exists
      begin
        File.open self.abs_path, 'r' do |f|
          f.flock File::LOCK_SH
          return f.read
        end
      rescue Errno::EACCES
        @errors = {:permission => "denied"}
        return false
      rescue Exception
        return false
      end
    else
      @errors = { :path => "Does not exist" }
      return false
    end
  end

  def set_content(data)
    begin
      File.open self.abs_path, 'w' do |f|
        f.flock File::LOCK_EX
        f.write data
        f.flush
        f.truncate f.pos
      end
    rescue Errno::EACCES
      @errors = {:permission => "denied"}
      return false
    rescue Exception
      return false
    end
  end

  def get_mode()
    # [TODO] Store it in a database
    name = self.name
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
      ['text']
    end
  end
end
