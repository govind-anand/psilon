#= require amplify
#= require ./notifier

# events involved:
#   subscribed:
#     user-action:project-new
#     user-action:project-create
#     user-action:project-new-cancel
#   published:
#     user-action:project-new
#     user-action:project-create
#     user-action:project-new-cancel

class necro.Sidebar

  constructor: (@panel)->
    self = this

    # Different views for the sidebar
    # Every view should have chainable show and hide methods
    # which will be used to swap in and out the views
    @views =
      'projectCreator':
        show: ->
          self.panel.setText 'Create New Project'
          @form = form = self.panel.attachForm()
          formData = [
            type: 'fieldset'
            name: 'data'
            label: 'New Project'
            inputWidth: 'auto'
            list: [
              {
                type: 'input',
                name: 'project[name]',
                label: 'Name of project',
                validate: 'NotEmpty'
              },
              { type: 'button', name: 'create', value: 'Create'},
              { type: 'button', name: 'cancel', value: 'Cancel'}
            ]
          ]
          form.loadStruct formData, 'json'
          form.attachEvent 'onButtonClick', (name)->
            if name == 'create'
              if form.validate()
                amplify.publish "user-action:project-create", form.getFormData()
            else if name == 'cancel'
              amplify.publish "user-action:project-new-cancel"
          this
        hide: -> this
      'projectList':
        show: ->
          self.panel.setText 'Projects'
          self.panel.attachHTMLString "<div class='loader'></div>"
          $.ajax
            url: '/users/current/projects.html'
            success: (data)->
              self.panel.attachHTMLString data
            error: ->
              self.panel.attachHTMLString "Failed to load content."
          this
        hide: ->
          #@_toolbar.unload()
          # forgo leave panel, title etc. because obviously
          # the next view to be shown will set their values
          this
  switchToView: (view)->
    if @views[view]?
      @currentView?.hide()
      @currentView = @views[view].show()

  init: ->
    @panel.setWidth(250)
    @switchToView('projectList')

    amplify.subscribe 'user-action:project-new', this, ->
      @switchToView('projectCreator')
    amplify.subscribe 'user-action:project-new-cancel', this, ->
      @switchToView('projectList')
    amplify.subscribe 'user-action:project-create', this, (data)->
      $.ajax
        url: '/projects',
        type: 'POST',
        dataType: 'json',
        success: (data)->
          if data.success
            notifier.success "Successfully created project"
        error: ->
          # [TODO] Add some sane error message
          notifier.error "Creation failed."

    $(@panel).on 'click', '.axn-trigger', ->
      action = $(this).attr('data-user-action')
      amplify.publish "user-action:#{action}"
