define [
    'space-pen'
    './sidebar'
    './header'
    #'./body'
    #'./status'
  ],(
    View,
    Sidebar,
    Header
    #Body,
    #Status
  )->

    class Workspace extends View

      @content: ->
        @div id:'app-wrapper', =>
          @subview 'sidebar', new Sidebar
          @subview 'header', new Header
          @div id: 'status', outlet: 'statusEl'
          @div id: 'workspace-container', outlet: 'bodyEl'

      init: -> 
        @appendTo @el
        # [TODO][low] Show some loading mask
        @sidebar.init()
        @header.init()
        #@body = new Body(@bodyEl).init()
        this
