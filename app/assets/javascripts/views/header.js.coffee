define [
    'space-pen'
    'superfish/jquery.easing-sooper'
    'superfish/jquery.sooperfish'
  ],(
    View
  )->

    class Header extends View
      @content: ->
        @header =>
          @ul id:'account-options', =>
            @li 'data-option':'account_settings', 'Account Settings'
            @li 'data-option':'logout', 'Logout'
          @h1 =>
            @a href:'/', 'Psilon'
          @ul class: 'hidden mbar sf-menu', outlet: 'editorMenu', =>
            @li =>
              @a 'File'
              @ul =>
                @li => @a 'Save'
                @li => @a 'Save As'
                @li => @a 'Open Recent'
                @li.separator
                @li => @a 'close'
            @li =>
              @a 'Edit'
              @ul =>
                @li => @a 'Undo'
                @li => @a 'Redo'
                @li.separator
                @li => @a 'Indent'
                @li.separator
                @li => @a 'Preferences'
            @li =>
              @a 'Project'
              @ul =>
                @li => @a 'Settings'
                @li => @a 'Share'
            @li =>
              @a 'Favourites'
              @ul =>
                @li => @a 'Files'
                @li => @a 'Folders'
                @li => @a 'Recently visited'
            @li =>
              @a 'Tools'
              @ul =>
                @li => @a 'Extensions'
            @li =>
              @a 'Help'
              @ul =>
                @li => @a 'Video tutorials'
                @li => @a 'Manual'
                @li => @a 'Tutorials'
          @ul class: 'hidden mbar sf-menu', outlet: 'contentMenu'
          @ul id:'ui-options', =>
            @li class:'selected', 'data-option':'light', 'Light'
            @li 'data-option': 'dark', 'Dark'

      init: ->
      initialize: ->
        psi.subscribe 'post:nav:file', =>
          @editorMenu.removeClass('hidden').show()
          @contentMenu.addClass('hidden')
          unless @_editorMenuLoaded
            @editorMenu.sooperfish()
            @_editorMenuLoaded = true
        psi.subscribe 'post:nav:content', =>
          @editorMenu.addClass('hidden')
          @contentMenu.removeClass('hidden').show()
          unless @_contentMenuLoaded
            @contentMenu.sooperfish()
            @_contentMenuLoaded = true