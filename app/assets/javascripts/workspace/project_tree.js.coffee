define ['./subview'], (Subview)->

  class ProjectTree extends Subview
    constructor: -> super
    show: ->
      @parent.panel.setText "Project"
      tree = @parent.panel.attachTree()
      tree.setImagePath necro.imagePath
      url = "/projects/#{@parent.currentPid}/files.xml"
      tree.setXMLAutoLoading(url)
      tree.loadXML(url)

      tree.attachEvent 'onDblClick', (id)=>
        necro.publish "user-action:file-open", path: id, pid: @parent.currentPid
      this
