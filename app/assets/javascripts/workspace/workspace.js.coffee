define [
    './sidebar'
    './app_body'
  ], (Sidebar, AppBody)->

    class Workspace
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

        @views.sidebar = new Sidebar(@sbarPanel).init()
        @views.appBody = new AppBody(@bodyPanel).init()
        this
