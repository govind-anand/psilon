# events involved:
#   subscribed:
#     user-action:project-new
#     user-action:project-create
#     user-action:project-new-cancel
#   published:
#     user-action:project-new
#     user-action:project-create
#     user-action:project-new-cancel

define [
    './project_creator'
    './project_list'
    './project_tree'
  ],(ProjectCreator, ProjectList, ProjectTree)->

    class Sidebar

      constructor: (@panel)->
        @views =
          'projectCreator': new ProjectCreator { parent: this }
          'projectList': new ProjectList { parent: this }
          'projectTree': new ProjectTree { parent: this }

      switchToView: (view)->
        if @views[view]? and @views[view] isnt @currentView
          @currentView?.hide()
          @currentView = @views[view].show()

      init: ->
        @panel.setWidth(250)
        @switchToView('projectList')

        necro.subscribe 'user-action:project-new', this, ->
          @switchToView('projectCreator')
        necro.subscribe 'user-action:project-new-cancel', this, ->
          @switchToView('projectList')
        necro.subscribe 'user-action:project-create', this, (data)->
          @panel.attachHTMLString "<div class='loader'></div>"
          $.ajax
            url: '/projects',
            type: 'POST',
            data: data
            dataType: 'json',
            success: (data)=>
              if data.success
                necro.ui.notifier.success "Successfully created project"
                @switchToView 'projectList'
            error: =>
              # [TODO] Add some sane error message
              necro.ui.notifier.error "Creation failed."
              @switchToView 'projectCreator'
        necro.subscribe 'user-action:project-open', this, (data)->
          @currentPid = data.pid
          @switchToView 'projectTree'

        $(@panel).on 'click', '.axn-trigger', ->
          action = $(this).attr('data-user-action')
          necro.publish "user-action:#{action}"
        this
