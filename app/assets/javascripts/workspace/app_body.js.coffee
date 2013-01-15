define ->

  class AppBody

    constructor: (@panel)->
      @_menuConfig =
        codeOnlyEntries: ['saveFile', 'saveFileAs','undo', 'redo']
        contentOnlyEntries: []

    _getTabId: (options)->
      switch options.type or 'content'
        when 'content' then "content:#{options.url}"
        when 'file' then "file:#{options.pid}:#{options.path}"
          
    _getTabInfo: (tabId)->
      arr = tabId.split(':')
      switch(arr[0])
        when 'content' 
          type: 'content'
          url: arr[1]
        when 'file'
          type: 'file'
          pid: arr[1]
          path: arr[2]

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

    configureMenuForCode: ->
      if @menuLoaded
        for entry in @_menuConfig.codeOnlyEntries
          @menu.setItemEnabled(entry)
        for entry in @_menuConfig.contentOnlyEntries
          @menu.setItemDisabled(entry)

    configureMenuForContent: ->
      if @menuLoaded
        for entry in @_menuConfig.contentOnlyEntries
          @menu.setItemEnabled(entry)
        for entry in @_menuConfig.codeOnlyEntries
          @menu.setItemDisabled(entry)

    newFile: ->
    openFile: ->
    saveFile: ->
      tabId = @tabbar.getActiveTab()
      tabInfo = @_getTabInfo tabId
      $.ajax
        type: 'PUT'
        url: "/projects/#{tabInfo.pid}/file"
        data:
          path: tabInfo.path
          content: @tabs[tabId].editor.getValue()
          success: =>
            @tabs[tabId].editor.markClean()
    saveFileAs: ->
    closeActiveTab: ->
    undo: ->
    redo: ->
    showManual: ->
    showAbout: ->
    _setupMenu: ->
      @menu = @panel.attachMenu()
      @menu.setIconsPath '/assets/icons/'
      @menu.loadXML '/assets/menu.xml', =>
        @menuLoaded = true
        activeTab = @tabbar.getActiveTab()
        if @_getTabInfo(activeTab).type == 'file'
          @configureMenuForCode()
        else @configureMenuForContent()
      @menu.attachEvent 'onClick', (id)=> this[id]()

    _setupTabs: ->
      @tabbar = @panel.attachTabbar()
      @tabbar.enableTabCloseButton true
      @tabbar.setImagePath necro.imagePath
      @tabs = {}
      @tabbar.attachEvent 'onTabClose', (id)=>
        if @_getTabInfo(id).type == 'file' and not @tabs[id].editor.isClean()
          return false unless confirm(
            """
            Closing the tab will result in loss of unsaved work. 
            Do you want to proceed?
            """
          )
        delete @tabs[id]

    init: ->
      @_setupMenu()
      @_setupTabs()

      necro.subscribe 'user-action:url-open', (data)=>
        @configureMenuForContent()
        tabId = "content:#{data.url}"
        tabName = data.title
        unless @tabs[tabId]?
          @tabs[tabId] = {state: 'loading'}
          @tabbar.addTab tabId, tabName
          @tabbar.setContentHTML tabId, necro.frags.loader
          $.ajax
            url: data.url
            data:
              path: data.path
            type: 'GET'
            success: (data)=>
              @tabs[tabId] = {state: 'loaded'}
              @tabbar.setContentHTML tabId, data
            error: =>
              @tabs[tabId] = {state: 'failed'}
              @tabbar.setContentHTML tabId, necro.frags.loadFail
        @tabbar.setTabActive(tabId)

      necro.subscribe 'user-action:file-open', (data)=>
        tabId = "file:#{data.pid}:#{data.path}"
        tabName = data.path.split('/').slice(-1)[0]
        unless @tabs[tabId]?
          @tabbar.addTab tabId, tabName
          @tabbar.setContentHTML tabId, necro.frags.loader
          $.ajax
            url: "/projects/#{data.pid}/file"
            data:
              path: data.path
            type: 'GET'
            success: (data)=>
              @configureMenuForCode()
              necro.loadCSS 'codemirror/lib/codemirror'
              necro.loadCSS 'codemirror/theme/solarized'
              necro.loadCSS 'codemirror'
              require ['codemirror/lib/codemirror'], =>
                @_createEditor(tabId, data)
            error: =>
              @tabbar.setContentHTML tabId, necro.frags.loadFail
        @tabbar.setTabActive(tabId)

      necro.publish 'user-action:url-open', {
        url: '/assets/introduction.html',
        title: 'Introduction'
      }
      this
