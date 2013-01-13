class necro.Sidebar
  constructor: (@panel)->
  _setupProjectList: ->
    @panel.setText "Projects"
    @panel.attachURL("/users/current/projects.html")
    @toolbar = @panel.attachToolbar();
    @toolbar.addButton('new_project_button', 0, "New Project")

  init: ->
    @panel.setWidth(250)
    @_setupProjectList()
