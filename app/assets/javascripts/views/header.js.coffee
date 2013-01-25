define [
    'space-pen'
    'config/editor_menu'
    'superfish/jquery.easing-sooper'
    'superfish/jquery.sooperfish'
  ],(
    View, editorMenu
  )->

    class Header extends View

      @menu: (items, prefix)->
        for item in items
          @menuItem item, prefix

      @menuItem: (options, prefix)->
        @li 
          id:"#{prefix}_mi_#{options.id}"
          class: 'menu-item'
          'data-evt': options.evt
          =>
            @a options.label
            if options.children?
              @ul => @menu(options.children, prefix)

      @content: ->
        @header =>
          @ul id:'account-options', =>
            @li 'data-option':'account_settings', 'Account Settings'
            @li 'data-option':'logout', 'Logout'
          @h1 =>
            @a href:'/', 'Psilon'
          @ul class: 'hidden mbar sf-menu', outlet: 'editorMenu', =>
            @menu editorMenu, 'emenu'
          @ul class: 'hidden mbar sf-menu', outlet: 'contentMenu'
          @ul id:'ui-options', =>
            @li class:'selected', 'data-option':'light', 'Light'
            @li 'data-option': 'dark', 'Dark'

      initialize: ->
        psi.subscribe 'post:nav:file', =>
          @editorMenu.removeClass('hidden').show()
          @find('.sf-menu').on 'click', '.menu-item', ->
            psi.publish $(this).attr('data-evt')
            false
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