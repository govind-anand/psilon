define [
    'space-pen'
  ],(
    View
  )->

    class Tabbar extends View

      @content: ->
        @div id:'tabbar', class: 'tbar', =>
          @a id:'tab-all', class: 'icon', =>
            @raw '&#9776;'
          @a id:'tabbar-scroll-left', class: 'icon', =>
            @raw '&#59229;'
          @ul id:'tab-list', outlet: 'tabList'
          @a id:'tabbar-scroll-right', class: 'icon', =>
            @raw '&#59230;'

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

      addEditorTab: (tabId, params)->
        self = this
        path = params.parent + '/' + params.name
        pid = params.pid
        realpath = path.replace(/\*/g, '/')
        @tabs[tabId] = tab = $$ ->
          @div class: 'tab', =>
            @a class: 'rfloat icon tab-close', => @raw '&#10060;'
            @a class: 'tab-label', href:"#/project/#{pid}/file/#{path}", realpath
        tab.data('tabId', tabId)

        @tabs[tabId] = tab
        @tabList.append tab
        this

      removeTab: (tabId)->
        @tabs[tabId].remove()
        delete @tabs[tabId]
        if @activeTab == tabId
          for key, value of @tabs
            @activeTab = key
            arr = key.split(':')
            window.location.hash = "#/project/#{arr[1]}/#{arr[0]}/#{arr[2]}"
            return this

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