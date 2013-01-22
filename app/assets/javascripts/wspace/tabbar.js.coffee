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
          @ul id:'tab-list'
          @a id:'tabbar-scroll-right', class: 'icon', =>
            @raw '&#59230;'
