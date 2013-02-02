define [
    'space-pen'
    'underscore'
    'models/file'
    'jstree/jquery.jstree'
    'context_menu/jquery.context_menu'
  ],(
    View,
    _,
    File
  )->

    class ProjectTree extends View
      @content: ->
        @div id:'project-tree', =>
          @div id:'ptree-container', outlet: 'treeContainer'

      initialize: (@pid)->
        @nodeMap = {}
        psi.subscribe 'post:file:move', this, (params)->
          file = params.file
          oldPath = params.oldPath
          path = file.getPath()
          li = @findNode oldPath
          @nodeMap[path] = @nodeMap[oldPath]
          delete @nodeMap[oldPath]
          if li?
            psi.logger.debug 'Found moved node :', li
            li.data path: path
            a = li.find('a')
            a.attr href: params.file.getHashURL()
          else
            psi.logger.debug 'Moved node not found in tree :', params

      findNode: (path)->
        return null unless @nodeMap[path]?
        @treeContainer.find("##{@nodeMap[path]}").parent('li')

      # Characters allowed in ids include characters, numbers, colon, hiphen
      # period, underscore
      encPath: (path)-> path.replace(/\//g, '*')

      loadTree: ->
        self = this
        pid = @pid
        psi.loadCSS('context_menu/jquery.context_menu')
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
        @treeContainer.contextMenu
          selector: 'a'
          callback: -> psi.logger.log('context menu : ', arguments)
          items:
            rename: {name: 'Rename'}
            move: {name: 'Move'}
            delete: {name: 'Delete'}
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
          json_data:
            ajax:
              url: "/projects/#{pid}/files.json"
              data: (el)-> 
                root = $(el).data('path')
                if root? then {root: root} else null
              success: (data)->
                children = []
                for item in data.files
                  f = new File _.extend item, pid: pid
                  fid = _.uniqueId 'tnode_'
                  child =
                    metadata:
                      path: f.getPath()
                      type: f.type
                    data:
                      title: f.name
                      attr:
                        href: f.getHashURL()
                        id: fid
                  if item.type == 'file' 
                    child.data.icon = '/assets/icons/page.png'
                  else
                    child.data.icon = '/assets/icons/folder.png'
                    child.state = 'closed'
                  children.push child
                  self.nodeMap[f.getPath()] = fid

                if data.root == '/'
                  self.parentView.setTitle "Project : #{data.name}"
                  data: data.name
                  children: children
                else
                  children
          plugins: ["themes","json_data","crrm","dnd"]
        $.vakata.context.cnt.appendTo($("body")).html(" ")

      show: ->
        @loadTree() unless @treeLoaded
        super