define [
    'space-pen'
  ],(
    View
  )->

    class Body extends View
      initialize: ->
        psi.subscribe 'ui:sidebar-collapsed', =>
          @addClass 'rexpanded'
      @content: ->
        @div id:'workspace-container', =>
          @div id:'tabbar', class: 'tbar', =>
            @a id:'tab-all', class: 'icon', =>
              @raw '&#9776;'
            @a id:'tabbar-scroll-left', class: 'icon', =>
              @raw '&#59229;'
            @ul id:'tab-list'
            @a id:'tabbar-scroll-right', class: 'icon', =>
              @raw '&#59230;'
          @div id:'body-outer-wrapper', =>
            @div id:'body-wrapper'