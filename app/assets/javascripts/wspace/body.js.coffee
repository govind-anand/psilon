define [
    'space-pen'
    './tabbar'
  ],(
    View,
    Tabbar
  )->

    class Body extends View
      collapseSidebar: ->
        @addClass 'rexpanded'
      openEditor: (params)->
        psi.loadCSS 'codemirror/lib/codemirror'
        eId = "#{params.pid}:#{params.path}"
        unless @editors[eId]?
          @editors[eId] = 
          body: $$ -> @div class:'editor tab-body'
          @editors[eId].body
            .appendTo(@bodyWrapper)
            .html(psi.frags.loader)
          require ['codemirror/lib/codemirror'], =>
            @editors[eId].cm = CodeMirror @editors[eId].body.html('').get(0)
        @find('.tab-body').hide()
        @editors[eId].body
          .show()
      initialize: ->
        @editors = {}
        psi.subscribe 'ui:sidebar-collapsed', this, @collapseSidebar
        psi.subscribe 'nav:file', this, @openEditor
      @content: ->
        @div id:'workspace-container', =>
          @subview 'tabbar', new Tabbar
          @div id:'body-outer-wrapper', =>
            @div id:'body-wrapper', outlet: 'bodyWrapper'