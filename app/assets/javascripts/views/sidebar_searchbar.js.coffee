define [
    'space-pen'
  ], (View)->

    class SidebarSearchbar extends View
      @content: ->
        @div class:'bottombar tbar', =>
          @a 
            id:'sbar-collapse',
            class: 'icon', 
            click: 'collapse',
            =>
              @raw '&#9198;'
          @a id:'search-settings', class: 'icon', => 
            @raw '&#9881;'
          @div id:'sbar-search-wrapper', =>
            @input
            @a class:'search icon', =>
              @raw '&#128269;'
            @a class:'tbox-clear icon', =>
              @raw '&#9003;'