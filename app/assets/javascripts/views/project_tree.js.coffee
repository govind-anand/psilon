define [
    'space-pen'
    'models/file'
    'jstree/jquery.jstree'
  ],(
    View,
    File
  )->

    class ProjectTree extends View
      initialize: (@pid)->
      @content: ->
        @div id:'project-tree', =>
          @div id:'ptree-container', outlet: 'treeContainer'

      loadTree: ->
        self = this
        pid = @pid
        @treeContainer.on 'move_node.jstree', (params)->
          rslt = arguments[1].rslt
          psi.publish 'pre:file:move'
            src:
              new File
                pid: self.pid
                path: rslt.o.data('path')
            dest:
              new File 
                pid: self.pid
                path: rslt.np.data('path')
        @treeContainer.jstree
          themes:
            theme: 'psilon'
            icons: true
            dots: false
          crrm:
            move:
              check_move: (params)->
                if params.np.data('type') == 'directory'
                  true
                else false
          contextmenu:
            items:
              doSomething:
                label: 'Do something'
                icon: false
                action: ->
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
                      type: item.type
                    data:
                      title: item.path.split('/').slice(-1)[0]
                      attr:
                        href: "#/project/#{pid}/#{item.type}/#{item.path.replace(/\//g, '*')}"
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
          plugins: ["themes","json_data","contextmenu","crrm","dnd"]
        $.vakata.context.cnt.appendTo($("body")).html(" ")

      show: ->
        @loadTree() unless @treeLoaded
        super