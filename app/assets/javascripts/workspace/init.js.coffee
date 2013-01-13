#= require ./base
#= require ./sidebar
#= require ./app_body

class necro.Workspace
  constructor: ->
    @views = {}
  init: ->
    @layout = new dhtmlXLayoutObject document.body, '3T'
    @layout.attachStatusBar()
    @headerPanel = @layout.cells('a')
    @headerPanel.hideHeader()
    @headerPanel.setHeight(30)
    @headerPanel.attachHTMLString("<header class='main'><h1>Necromancer</h1></header>")
    @sbarPanel = @layout.cells('b')
    @bodyPanel = @layout.cells('c')

    @views.sidebar = new necro.Sidebar(@sbarPanel)
    @views.sidebar.init()

    @views.appBody = new necro.AppBody(@bodyPanel)
    @views.appBody.init()
