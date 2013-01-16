# Entry point into Necromancer application
# ----------------------------------------

require.config
  baseUrl: '/assets'
  paths:
    'toastmessage': 'toastmessage/javascript/jquery.toastmessage'
  shim:
    'amplify':
      deps: ['jquery']
    'dhtmlx/types/ftypes':
      deps: ['dhtmlx/dhtmlx']
    'toastmessage':
      deps: ['jquery']

require [
    'jquery'
    'amplify'
    'path'
    'dhtmlx/dhtmlx'
    'dhtmlx/types/ftypes'
    'workspace/workspace'
    'workspace/notifier'
    'workspace/routes'
  ], ->

    # [TODO] Add notes on why CommonJS style is preferred
    Workspace = require('workspace/workspace')
    Notifier = require('workspace/notifier')
    routes = require('workspace/routes')

    window.necro =
      imagePath: '/assets/dhtmlx/imgs/'

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
        efn = ->
        @ui =
          workspace: new Workspace
          notifier: new Notifier
        @logger=
          debug: efn
          info: efn
          warn: efn
          error: efn
          log: efn
        @ui.workspace.init()
        @ui.notifier.init()

      init: (enableLogging)->
        @_initAjax()
        @_initUI()
        @_initRouter()
        if (enableLogging)
          require ['workspace/logger'], (Logger)=> @logger = new Logger

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

    $ -> necro.init(true)
