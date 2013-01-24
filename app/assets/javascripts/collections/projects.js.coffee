define ['taffy'], (TAFFY)->

  class Projects
    getAll: ->
      @db().get()

    load: (options)->
      psi.publish "pre:projects:update"
      $.getJSON '/users/current/projects.json', (data)=>
        @db = TAFFY(data)
        psi.publish "post:projects:update"

    add: (data)->
      psi.publish "pre:projects:create"
      self = this
      $.ajax
        type: 'POST',
        data: {project: data}
        url: '/projects'
        success: (data)->
          if data.success
            psi.ui.notifier.success "Project creation successful"
            psi.publish 'post:project:create'
            self.load()
        error: ->
          psi.ui.notifier.error "Project creation failed"
          psi.publish 'post:fail:project:create'

    current: ->
      if arguments.length == 0
        @_currentProject
      else
        ppid = @_currentProject
        pid = arguments[0]
        @_currentProject = pid
        psi.publish "post:projects:current:change", previousPid: ppid, newPid: pid
        this
