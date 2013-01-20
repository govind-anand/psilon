define [
    'space-pen'
  ],(
    View
  )->

    class Header extends View
      @content: ->
        @header =>
          @ul id:'account-options', =>
            @li 'data-option':'account_settings', 'Account Settings'
            @li 'data-option':'logout', 'Logout'
          @ul id:'ui-options', =>
            @li class:'selected', 'data-option':'light', 'Light'
            @li 'data-option': 'dark', 'Dark'
          @h1 'Psilon'
      init: ->