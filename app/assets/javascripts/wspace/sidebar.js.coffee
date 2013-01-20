define [
    'space-pen'
  ],(
    View
  )->

    class Sidebar extends View

      @content: ->
        @div id:'sidebar', =>
          @div class:'titlebar tbar', =>
            @div class: 'title-placeholder'
          @div class: 'body', outlet: 'body', =>
          @div class:'bottombar tbar', =>
            @a id:'sbar-collapse',class: 'icon', => 
              @raw '&#9198;'
            @a id:'search-settings', class: 'icon', => 
              @raw '&#9881;'
            @div id:'sbar-search-wrapper', =>
              @input
              @a class:'search icon', =>
                @raw '&#128269;'
              @a class:'tbox-clear icon', =>
                @raw '&#9003;'
