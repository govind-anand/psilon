define [
    'space-pen'
    'jstree/jquery.jstree'
  ],(
    View
  )->

    class ProjectTree extends View
      initialize: (@pid)->
      @content: ->
        @div id:'project-tree', =>
          @div id:'ptree-container'

      loadTree: ->
        self = this
        pid = @pid
        @find('#ptree-container').jstree
          themes:
            theme: 'psilon'
            icons: true
            dots: false
          json_data:
            ajax:
              url: "/projects/#{pid}/files.json"
              data: (el)-> 
                root = $(el).data('path')
                if root? then {root: root} else null
              success: (data)->
                children = []
                for item in data.files
                  child =
                    metadata:
                      path: item.path
                    data:
                      title: item.path.split('/').slice(-1)[0]
                      attr:
                        href: "#/project/#{pid}/#{item.type}/#{item.path.replace(/\//, '*')}"
                  if item.type == 'file' 
                    child.data.icon = '/assets/icons/page.png'
                  else
                    child.data.icon = '/assets/icons/folder.png'
                    child.state = 'closed'
                  children.push child

                if data.root == '/'
                  self.parentView.setTitle "Project : #{data.name}"
                  data: data.name
                  children: children
                else
                  children
          plugins: ["themes","json_data"]

      show: ->
        @loadTree() unless @treeLoaded
        super