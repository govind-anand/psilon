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

  def get_content
    if @exists
      begin
        File.open self.abs_path, 'r' do |f|
          f.flock File::LOCK_SH
          return f.read
        end
      rescue Errno::EACCES
        @rrors = {:permission => "denied"}
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
end
