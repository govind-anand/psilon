define [
    'space-pen'
  ],(
    View
  )->

    class ProjectList extends View

      @content: ->
        @div id:'project-list', =>
          @div class: 'pseudo-tbar', =>
            @a 
              class:'icon'
              id: 'plist_list'
              title: 'Show project list'
              click: 'loadProjects'
              => @raw '&#57349;'
            @a 
              class: 'icon'
              id: 'plist_add_p'
              title: 'Create new project'
              click: 'createProject'
              => @raw '&#8862;'
            @a class: 'icon', => @raw '&#128228;'
            @a class: 'icon2', => @raw '&#62208;'
            @a class: 'icon2', => @raw '&#62256;'
            @a class: 'icon', => @raw '&#128229;'
          @div class: 'body', outlet: 'body'

      initialize: ->
        @title = "Projects"

      renderList: (list)->
        $$ -> @ul => 
          for item in list
            @li =>
              @a href: "#/project/#{item.id}", =>
                @div class: 'icon lfloat', =>
                  @raw '&#10002;'
                @text item.name

      loadProjects: ->
        @body.html psi.frags.loader
        $.getJSON '/users/current/projects.json', (projects)=>
          @body.html ''
          if projects? and projects.length > 0
            @body.html('').append @renderList(projects)
          else
            @body.append $$ ->
              @div class:'vacancy-msg', "No projects found"

      createProject: ->
        require ['wspace/project_creator'], (ProjectCreator)=>
          @body.html('').append(new ProjectCreator)
