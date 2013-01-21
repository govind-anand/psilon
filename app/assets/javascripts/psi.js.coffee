define [
    'jquery'
    'amplify'
    'path'
    'wspace/workspace'
    'wspace/notifier'
    'wspace/routes'
  ], ->

    Workspace = require('wspace/workspace')
    Notifier = require('wspace/notifier')
    routes = require('wspace/routes')

    window.psi = 
      _initRouter: ->
        self = this
        for route, action of routes
          Path.map(route).to ((action)-> ->
            self.publish action, @params
          )(action)
        Path.root('#/')
        Path.listen()

      _initAjax: ->
        $.ajaxSetup
          beforeSend: (xhr)->
            csrfToken = $('meta[name="csrf-token"]').attr('content')
            xhr.setRequestHeader('X-CSRF-Token', csrfToken)

      _initUI: ->
        @ui =
          workspace: new Workspace
          notifier: new Notifier
        $('body').html('')
        @ui.workspace
          .appendTo($('body'))
          .init()
        @ui.notifier.init()

      _initLogger: ->
        efn = ->
        @logger=
          debug: efn
          info: efn
          warn: efn
          error: efn
          log: efn

      init: (enableLogging)->
        @_initLogger()
        @_initAjax()
        @_initUI()
        @_initRouter()
        if (enableLogging)
          require ['wspace/logger'], (Logger)=> @logger = new Logger

      publish: ->
        @logger.info "PUBLISH: ", arguments if @ui?
        amplify.publish.apply this, arguments

      subscribe: ->
        @logger.info "SUBSCRIBE: ", arguments if @ui?
        amplify.subscribe.apply this, arguments

      loadCSS: (path)->
        unless (@_loadedCSS ?= {})[path]?
          $('head').append("<link rel='stylesheet' type='text/css' href='/assets/#{path}.css'>")

      frags:
        loader: "<div class='loader'></div>"
        loadFail: "<div class='load-fail'>Loading Failed!</div>"

      _nextId: 1
      uniqueId: ->
        id = @_nextId
        @_nextId += 1
        return id