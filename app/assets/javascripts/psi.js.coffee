# Global mediator : Provides a single point of access to the models, collections
# top level views and major utilities

define [

    # Third party libraries:
    'jquery'
    'path'
    'underscore'

    # Collections:
    'collections/files'
    'collections/projects'

    # Views:
    'views/workspace'
    'views/notifier'

    # Configurations:
    'config/routes'

    # Utilities:
    'utils/pubsub'
    'utils/frags'

  ], (
    $, Path, _,           # Third party libraries
    Files, Projects,      # Collections
    Workspace, Notifier,  # Views
    routes,               # configurations
    pubsub, frags         # utilities
  )->

    class PSI

      constructor: (options)->
        @logger = options.logger
        @frags = frags
        _.extend this, pubsub

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

      _initRegistry: ->
        @registry =
          projects: new Projects
          files: new Files

      init: (enableLogging)->
        @_initRegistry()
        @_initAjax()
        @_initUI()
        @_initRouter()

      loadCSS: (path)->
        unless (@_loadedCSS ?= {})[path]?
          $('head').append("<link rel='stylesheet' type='text/css' href='/assets/#{path}.css'>")