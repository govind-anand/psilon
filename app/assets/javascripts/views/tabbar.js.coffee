define [
    'space-pen'
    'underscore'
    'views/widgets/icon'
    'models/file'
  ],(
    View,
    _,
    icon,
    File
  )->

    class Tabbar extends View
      _.extend this, icon

      @content: ->
        @div id:'tabbar', class: 'tbar', =>
          @a id:'tab-all', class: 'icon', => @icon 'list'
          @a id:'tabbar-scroll-left', class: 'icon', => @icon 'chevron-left'
          @ul id:'tab-list', outlet: 'tabList'
          @a id:'tabbar-scroll-right', class: 'icon', => @icon 'chevron-right'

      getTabConfig: (tabId)->
        type = tabId.split(':')[0]
        if (type == 'file')
          @parentView.editors[tabId]
        else 
          @parentView.content[tabId]

      initialize: ->
        self = this
        @tabs = {}
        @on 'click', '.tab .tab-close', ->
          psi.publish 'pre:file:close', $(this).parent('.tab').data('tabId')

      addEditorTab: (tabId, file)->
        @tabs[tabId] = tab = $$ ->
          _.extend this, icon
          @div class: 'tab', =>
            @a class: 'rfloat icon tab-close', => @icon 'cross'
            @a
              class: 'tab-label'
              href: file.getHashURL()
              file.getPath()
        tab.data 'tabId', tabId
        @tabList.append tab
        this

      removeTab: (tabId)->
        @tabs[tabId].remove()
        delete @tabs[tabId]
        if @activeTab == tabId
          @activeTab = null
          for key, value of @tabs
            @activeTab = key
            arr = key.split ':'
            arr[2] = File.encodePath arr[2]
            window.location.hash = "#/project/#{arr[1]}/#{arr[0]}/#{arr[2]}"
            return this
          arr = tabId.split ':'
          window.location.hash = "#/project/#{arr[1]}"
          psi.publish 'post:file:close-all'

      markActive: (tabId)->
        @tabs[@activeTab].removeClass('active') if @activeTab?
        @activeTab = tabId
        @tabs[@activeTab].addClass('active')
        this

      switchToTab: (tabId)->
        @getTabConfig(@activeTab).body.hide() if @activeTab?
        @markActive tabId
        @getTabConfig(tabId).body.show()
        this