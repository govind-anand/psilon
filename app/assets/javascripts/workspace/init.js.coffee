#= require ./base
#= require ./sidebar
#= require ./app_body

class necro.Workspace
  constructor: ->
    @views = {}
  init: ->
    @layout = new dhtmlXLayoutObject document.body, '2U'
    @layout.attachStatusBar()
    @sbarPanel = @layout.cells('a')
    @bodyPanel = @layout.cells('b')

    @views.sidebar = new necro.Sidebar(@sbarPanel)
    @views.sidebar.init()

    @views.appBody = new necro.AppBody(@bodyPanel)
    @views.appBody.init()
