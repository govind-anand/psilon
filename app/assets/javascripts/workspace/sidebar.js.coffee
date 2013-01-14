# events involved:
#   subscribed:
#     user-action:project-new
#     user-action:project-create
#     user-action:project-new-cancel
#   published:
#     user-action:project-new
#     user-action:project-create
#     user-action:project-new-cancel

define ->
  class Sidebar

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
                  validate: 'NotEmpty',
                  position: 'label-top'
                },
                {
                  type: 'checkbox',
                  name: 'project[is_public]',
                  label: 'Make public',
                  position: 'label-right'
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
        'projectTree':
          show: ->
            self.panel.setText "Project"
            tree = self.panel.attachTree()
            tree.setImagePath necro.imagePath
            url = "/projects/#{self.currentPid}/files.xml"
            tree.setXMLAutoLoading(url)
            tree.loadXML(url)
          hide: -> this
    switchToView: (view)->
      if @views[view]?
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
