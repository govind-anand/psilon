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

      createEditor: (eId, params)->
        psi.loadCSS 'codemirror/lib/codemirror'
        body = $$ -> @div class:'editor tab-body'
        body
          .appendTo(@bodyWrapper)
          .html(psi.frags.loader)
        @editors[eId] = body: body
        require ['codemirror/lib/codemirror'], =>
          @editors[eId].cm = CodeMirror body.html('').get(0), {
            lineNumbers: true
          }
        @tabbar.addEditorTab eId, params.path

      openEditor: (params)->
        eId = "file:#{params.pid}:#{params.path}"
        unless @editors[eId]?
          @createEditor(eId, params)
        @tabbar.switchToTab(eId)
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