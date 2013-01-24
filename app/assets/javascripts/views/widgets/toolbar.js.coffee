define ->

  transformOptions = (options)->
    options.class ?= ""
    if options.pseudo 
      delete options.pseudo
      options.class += ' pseudo-tbar'
    else
      options.class += ' tbar'

  toolbar: ->
    options = if arguments.length > 0 and not _.isFunction(arguments[0])
      arguments[0]
    else {}
    transformOptions(options)
    @div options, arguments[1]