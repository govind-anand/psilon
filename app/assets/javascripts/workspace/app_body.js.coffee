define ->
  class AppBody
    constructor: (@panel)->
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
              @tabbar.setContentHTML tabId, data.content
            error: =>
              @tabbar.setContentHTML tabId, necro.frags.loadFail
        @tabbar.setTabActive(tabId)
      this
