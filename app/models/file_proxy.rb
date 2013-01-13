class FileProxy

  include Authority::Abilities
  self.authorizer_name = 'FileAuthorizer'

  attr_reader :path, :exists, :stat, :project

  def initialize(config)
    @path = config[:path]
    @project = config[:project]
    @exists = File.exists? @path
    if @exists
      @stat = File.stat @path
    end
  end

end
