define ['taffy'], (TAFFY)->

  class Files

    decodePath: (enPath)->
      enPath.replace /\*/g, '/'

    constructor: ->
      @db = TAFFY()
      psi.subscribe 'post:nav:file', this, @fetch
      psi.subscribe 'pre:file:save', this, @save

    save: (params)->
      dset = @db(params.file)
      dset.update(content: params.content)
      data = dset.get()[0]
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
          path: @decodePath(options.path)
        success: (data)=>
          dset = @db pid: data.pid, name: data.name, parent: data.parent
          if dset.count > 0
            dset.update(data)
          else
            @db.insert(data)
          psi.publish 'post:file:fetch', data

    get: (options)->
      dset = @db
