define ['config/ico_map'], (icoMap)->

  transformOptions = (options)->
    options.class ?= ""
    if options.icon
      if (options.isSocial)
        delete options.isSocial
        options.class += " icon2"
      else
        options.class += " icon"

  icoBtn: ->
    options = if arguments.length > 0 and not _.isFunction(arguments[0])
      arguments[0]
    else
    cb = null
    transformOptions(options)
    if (options.icon)
      cb = ((icon)=> => @raw(icoMap[icon]))(options.icon)
      delete options.icon
    @a options, cb
