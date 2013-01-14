define ->
  class AppBody
    constructor: (@panel)->
    _createEditor: (tabId, data)->
      reqments = []
      for mode in data.modes
        unless mode == 'text'
          reqments.push "codemirror/mode/#{mode}/#{mode}"
      necro.logger.log reqments

      lastMode = data.modes[data.modes.length-1]
      require reqments, =>
        uid = "ed_"+necro.uniqueId()
        @tabbar.setContentHTML(tabId,
          "<div class='editor' id='#{uid}'></div>"
        )
        ele = $("##{uid}").get(0)
        @tabs[tabId] =
          nodeId: uid,
          content: data.content
          editor: CodeMirror(ele,{
            value: data.content
            mode: lastMode
            theme: 'solarized dark'
          })

    init: ->
      @tabbar = @panel.attachTabbar()
      @tabbar.setImagePath(necro.imagePath)
      @tabs = {"content:intro": {state: 'static'}}
      @tabbar.addTab("content:intro", "Introduction")
      @tabbar.setTabActive("content:intro")
      @tabbar.setContentHTML("content:intro", "Lorem ipsum dolor sit amet")

      necro.subscribe 'user-action:file-open', (data)=>
        console.log data
        tabId = "file:#{data.pid}:#{data.path}"
        tabName = data.path.split('/').slice(-1)[0]
        unless @tabs[tabId]?
          @tabbar.addTab(tabId,tabName)
          @tabbar.setContentHTML tabId, necro.frags.loader
          $.ajax
            url: "/projects/#{data.pid}/file"
            data:
              path: data.path
            type: 'GET'
            success: (data)=>
              necro.loadCSS('codemirror/lib/codemirror')
              necro.loadCSS('codemirror/theme/solarized')
              necro.loadCSS('codemirror')
              require ['codemirror/lib/codemirror'], => @_createEditor(tabId, data)
            error: =>
              @tabbar.setContentHTML tabId, necro.frags.loadFail
        @tabbar.setTabActive(tabId)
      this
