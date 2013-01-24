define ['jquery'], ($)->

  isFn = $.isFunction

  class Logger
    constructor: ->
      if window.console
        if isFn Function.prototype.bind
          # Preserve the ability to print line numbers
          @log   = console.log.bind console   if isFn console.log
          @debug = console.debug.bind console if isFn console.debug
          @info  = console.info.bind console  if isFn console.info
          @warn  = console.warn.bind console  if isFn console.warn
          @error = console.error.bind console if isFn console.error
        else
          @log   = $.proxy console.log, console   if isFn console.log
          @debug = $.proxy console.debug, console if isFn console.debug
          @info  = $.proxy console.info, console  if isFn console.info
          @warn  = $.proxy console.warn, console  if isFn console.warn
          @error = $.proxy console.error, console if isFn console.error

        @log ?= ->

        for t in ['debug','info','warn','error']
          this[t] ?= @log

      else
        # [TODO] Support logging via external window
        @debug = @info = @warn = @error = @log = ->
