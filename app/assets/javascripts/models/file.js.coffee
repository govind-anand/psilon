define ->
  class File
    @encodePath: (path)-> path.replace /\//g, '*'
    @decodePath: (path)-> path.replace /\*/g, '/'

    getEncPath: -> File.encodePath @getPath()

    setPath: (path)->
      arr = path.split '/'
      @name = arr.slice(-1)[0]
      @parent = arr.slice(0, -1).join '/'

    getPath: -> "#{@parent}/#{@name}"

    getHashURL: -> "#/project/#{@pid}/file/#{@getEncPath()}"

    constructor: (params)->
      if _.isString params
        @setPath(params)
      else
        @pid = Number(params.pid) if params.pid?
        @name = params.name       if params.name?
        @parent = params.parent   if params.parent?
        @setPath(params.path)     if params.path?
