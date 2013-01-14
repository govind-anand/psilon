# Entry point into Necromancer application
# ----------------------------------------

require.config
  baseUrl: '/assets'
  paths:
    'toastmessage': 'toastmessage/javascript/jquery.toastmessage'
    'codemirror': 'codemirror/lib/codemirror'
    'cm-theme': 'codemirror/theme'
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
    'routie'
    'dhtmlx/dhtmlx'
    'dhtmlx/types/ftypes'
    'workspace/workspace'
    'workspace/notifier'
  ], ->

    # [TODO] Add notes on why CommonJS style is preferred
    Workspace = require('workspace/workspace')
    Notifier = require('workspace/notifier')

    window.necro =
      imagePath: '/assets/dhtmlx/imgs/'

      _initRouteMapper: ->
        routie 'project/:pid', (pid)->
          necro.publish 'user-action:project-open', pid: pid
        routie 'project/:pid/file/:fid', (pid, fid)->
          necro.publish 'user-action:file-open', pid: pid, fid: fid

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
          logger:
            debug: efn
            info: efn
            warn: efn
            error: efn
            log: efn
        @ui.workspace.init()
        @ui.notifier.init()

      init: (enableLogging)->
        @_initRouteMapper()
        @_initAjax()
        @_initUI()
        if (enableLogging)
          require ['workspace/logger'], (Logger)=> @ui.logger = new Logger

      publish: ->
        @ui.logger.info "PUBLISH: ", arguments if @ui?
        amplify.publish.apply this, arguments

      subscribe: ->
        @ui.logger.info "SUBSCRIBE: ", arguments if @ui?
        amplify.subscribe.apply this, arguments

      loadCSS: (path)->
        unless (@_loadedCSS ?= {})[path]?
          $('head').append("<link rel='stylesheet' type='text/css' href=#{path}>")

      frags:
        loader: "<div class='loader'></div>"
        loadFail: "<div class='load-fail'>Loading Failed!</div>"

    $ -> necro.init(true)
