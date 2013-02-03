define ['taffy','models/file','views/widgets/icon'], (TAFFY, File, icon)->

  class Files
    constructor: ->
      @db = TAFFY()
      psi.subscribe 'post:nav:file', this, @fetch
      psi.subscribe 'pre:file:save', this, @save
      psi.subscribe 'pre:file:move', this, @move
      psi.subscribe 'pre:file:delete', this, @delete
      psi.subscribe 'pre:file:rename', this, @rename
      psi.subscribe 'pre:directory:rename', this, @rename
      psi.subscribe 'post:file:close', this, (file)->
        dset = @db pid: file.pid, parent: file.parent, name: file.name
        psi.logger.log('dset : ', dset.get())
        dset.remove()

    delete: (params)->
      file = params.file
      $.ajax
        url: "/projects/#{file.pid}/file"
        type: 'DELETE'
        data:
          path: file.getPath()
        success: =>
          @db(file.getDBParams()).remove()
          psi.ui.notifier.success "File deleted"
          psi.publish 'post:file:delete'

    move: (params)->
      self= this
      src = params.src
      dest = params.dest
      psi.logger.info 'Moving file...'
      $.ajax
        url: "/projects/#{src.pid}/file"
        type: 'PUT'
        data:
          path: src.getPath()
          parent: dest.getPath()
        success: ->
          self.db(src.getDBParams()).update parent: dest.getPath()
          psi.ui.notifier.success "File moved"
          oldPath = src.getPath()
          src.parent = dest.getPath()
          psi.publish 'post:file:move', file: src, oldPath: oldPath

    rename: (params)->
      file = params.file
      newName = params.newName
      $.ajax
        url: "/projects/#{file.pid}/file"
        type: 'PUT'
        data:
          path: file.getPath()
          name: params.newName
        success: =>
          @db(file.getDBParams()).update name: newName
          psi.ui.notifier.success "File Renamed"
          oldName = file.name
          file.name = newName
          psi.publish 'post:file:rename', file: file, oldName: oldName

    save: (params)->
      dset = @db(params.file)
      dset.update(content: params.content)
      data = new File dset.get()[0]
      $.ajax
        url: "/projects/#{params.file.pid}/file"
        data: 
          path: data.getPath()
          content: params.content
        type: 'PUT'
        success: ->
          psi.ui.notifier.success "File saved"
          psi.publish 'post:file:save', file: data

    fetch: (options)->
      $.ajax
        url: "/projects/#{options.pid}/file"
        data: 
          path: File.decodePath(options.path)
        success: (data)=>
          dset = @db pid: data.pid, name: data.name, parent: data.parent
          if dset.count > 0
            dset.update(data)
          else
            @db.insert(data)
          psi.publish 'post:file:fetch', file: new File(data)