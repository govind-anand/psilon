define [
    'space-pen'
    './project_list'
    './project_tree'
    './sidebar_searchbar'
  ],(
    View,
    ProjectList,
    ProjectTree,
    SidebarSearchbar
  )->

    class Sidebar extends View

      @content: ->
        @div id:'sidebar', =>
          @div class:'titlebar tbar', =>
            @div class: 'title-placeholder', outlet: 'title'
          @div class: 'body', outlet: 'body'
          @subview 'sidebarSearchbar', new SidebarSearchbar

      initialize: ->
        @views = {}
        psi.subscribe 'post:nav:app-root', this, @openProjectList
        psi.subscribe 'post:nav:project-root', this, @openProjectTree
        psi.subscribe 'post:nav:file', this, @openProjectTree

      collapse: ->
        @hide 'fast', -> 
          psi.publish 'post:ui:sidebar:collapse'
        this

      setTitle: (title)-> 
        @title.html(title)
        this

      openProjectTree: (data)->
        require ["views/project_tree"], (V)=>
          viewName = "project_tree:#{data.pid}"
          unless @views[viewName]?
            v = @views[viewName] = new V(data.pid)
            v.appendTo @body
            v.parentView = this
          @switchToView viewName

      switchToView: (view)->
        if @views[view] isnt @currentView
          @currentView?.hide?()
          @currentView = @views[view].show?()
          @title.html @currentView.title
        this

      openProjectList: ->
        require ["views/project_list"], (V)=>
          unless @views['project_list']?
            v = @views['project_list'] = new V
            v.appendTo @body
            v.parentView = this
          @switchToView 'project_list'
          psi.registry.projects.load()