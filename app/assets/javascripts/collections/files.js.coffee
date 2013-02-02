define ['taffy','models/file','views/widgets/icon'], (TAFFY, File, icon)->

  class Files
    constructor: ->
      @db = TAFFY()
      psi.subscribe 'post:nav:file', this, @fetch
      psi.subscribe 'pre:file:save', this, @save
      psi.subscribe 'pre:file:move', this, @move
      psi.subscribe 'post:file:close', this, (file)->
        dset = @db pid: file.pid, parent: file.parent, name: file.name
        psi.logger.log('dset : ', dset.get())
        dset.remove()

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
          self.db(src.getDBParams()).update(parent: dest.getPath())
          psi.ui.notifier.success "File moved"
          oldPath = src.getPath()
          src.parent = dest.getPath()
          psi.publish 'post:file:move', file: src, oldPath: oldPath

    save: (params)->
      dset = @db(params.file)
      dset.update(content: params.content)
      data = new File dset.get()[0]
      $.ajax
        url: "/projects/#{params.file.pid}/file"
        data: 
          path: data.parent+'/'+data.name
          content: params.content
        type: 'PUT'
        success: ->
          psi.ui.notifier.success "File saved"

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
          psi.publish 'post:file:fetch', new File(data)

    get: (options)->
      dset = @db