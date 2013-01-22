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

      initialize: ->
        @tabs = {}

      addEditorTab: (tabId, path)->
        self = this
        path = path.replace(/\*/g, '/')
        tab = $$ ->
          @div class: 'tab', path
        tab.data('tabId', tabId)

        @tabs[tabId] = tab
        @tabList.append tab
        tab.click -> self.switchToTab $(this).data('tabId')

      switchToTab: (tabId)->
        $('.tab-body').hide()
        if tabId.split(':')[0] == 'file'
          @parentView.editors[tabId].body.show()
