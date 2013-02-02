define [
    'space-pen'
    './tabbar'
    'models/file'
  ],(
    View,
    Tabbar,
    File
  )->

    class Body extends View

      @content: ->
        @div id:'workspace-container', =>
          @subview 'tabbar', new Tabbar
          @div id:'body-outer-wrapper', =>
            @div id:'body-wrapper', outlet: 'bodyWrapper'

      initialize: ->
        @editors = {}
        psi.subscribe 'pre:ui:sidebar:collapse', this, @collapseSidebar
        psi.subscribe 'pre:file:close', this, @closeEditor
        psi.subscribe 'post:file:fetch', this, @openEditor
        psi.subscribe 'pre:editor:save', =>
          eId = @tabbar.activeTab
          if eId? and @editors[eId]?
            psi.publish 'pre:file:save', 
              file: @getFileInfo eId
              content: @editors[eId].cm.getValue()
        psi.subscribe 'pre:file:save_as', this, @saveFileAs

      collapseSidebar: ->
        @addClass 'rexpanded'
        psi.publish 'post:ui:sidebar:collapse'

      createEditor: (eId, file)->
        psi.loadCSS 'codemirror/lib/codemirror'
        body = $$ -> @div class:'editor tab-body'
        body
          .appendTo(@bodyWrapper)
          .html(psi.frags.loader)
        @editors[eId] = body: body
        fdata = psi.registry.files.db(
            pid: file.pid
            parent: file.parent
            name: file.name
          ).get()[0]
        modes = []
        for mode in fdata.modes
          if mode isnt 'text'
            modes.push "codemirror/mode/#{mode}/#{mode}"

        require ['codemirror/lib/codemirror'], =>
          require modes, =>
            @editors[eId].cm = CodeMirror body.html('').get(0), {
              value: fdata.content
              lineNumbers: true
              mode: fdata.modes[fdata.modes.length-1]
            }
        @tabbar.addEditorTab eId, file

      getFileInfo: (eId)->
        arr = eId.split(':')
        return null if arr[0] != 'file'
        parr = arr[2].split('/')

        pid: Number arr[1]
        parent: parr.slice(0, -1).join('/')
        name: parr.slice(-1)[0]

      getEditorId: (file)-> 
        "file:#{file.pid}:#{file.getPath()}"

      openEditor: (file)->
        eId = @getEditorId file
        unless @editors[eId]?
          @createEditor(eId, file)
        @tabbar.switchToTab(eId)
        @find('.tab-body').hide()
        @editors[eId].body.show()

      closeEditor: (eId)->
        @editors[eId].body.remove()
        delete @editors[eId]
        @tabbar.removeTab(eId)
        arr = eId.split(':')
        psi.publish 'post:file:close', new File pid: arr[1], path: arr[2]