define [
    'space-pen'
    './sidebar'
    './header'
    './body'
    './status'
  ],(
    View,
    Sidebar,
    Header
    Body,
    Status
  )->

    class Workspace extends View

      @content: ->
        @div id:'app-wrapper', =>
          @subview 'sidebar', new Sidebar
          @subview 'header', new Header
          @subview 'body', new Body
          @subview 'status', new Status

      init: -> 
        @appendTo @el
        # [TODO][low] Show some loading mask
        # @sidebar.init()
        # @header.init()
        # @body = new Body(@bodyEl).init()
        this
