define [
    './sidebar'
    './app_body'
  ], (Sidebar, AppBody)->

    class Workspace
      constructor: ->
        @views = {}
      init: ->
        @views.sidebar = new Sidebar($('#sidebar')).init()
        @views.appBody = new AppBody($('#workspace-container'))#.init()
        this