define ['taffy'], (TAFFY)->

  class Files

    decodePath: (enPath)->
      enPath.replace /\*/g, '/'

    constructor: ->
      @db = TAFFY()
      psi.subscribe 'post:nav:file', this, @fetch

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
