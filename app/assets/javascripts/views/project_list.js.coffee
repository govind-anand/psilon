define [
    'space-pen'
    'underscore'
    'config/ico_map'
    'views/widgets/toolbar'
    'views/widgets/buttons'
  ],(
    View,
    _,
    icoMap,
    toolbar, buttons
  )->

    class ProjectList extends View

      _.extend this, toolbar, buttons

      @content: ->
        @div id: 'project-list', =>
          @toolbar pseudo: true, =>
            @icoBtn icon: 'numbered-list', click: 'showProjects'
            @icoBtn icon: 'squared-plus', click: 'createProject'
            @icoBtn icon: 'upload'
            @icoBtn icon: 'github', isSocial: true
            @icoBtn icon: 'dropbox', isSocial: true
            @icoBtn icon: 'download'
          @div class: 'body', outlet: 'body'

      initialize: ->
        @title = "Projects"
        psi.subscribe "post:projects:update", =>
          @showProjects()

      _renderList: (list)->
        $$ -> @ul => 
          for item in list
            @li =>
              @a href: "#/project/#{item.id}", =>
                @div class: 'icon lfloat', =>
                  @raw '&#10002;'
                @text item.name

      mask: ->
        @body.html psi.frags.loader

      showProjects: ->
        @body.html ''
        projects = psi.registry.projects.getAll()
        if projects.length > 0
          @body.html @_renderList(projects)
        else
          @body.html $$ -> @div class:'vacancy-msg', "No projects found"

      createProject: ->
        @mask()
        require ['views/project_creator'], (ProjectCreator)=>
          @body.html('').append(new ProjectCreator)