define ['amplify'], (amplify)->
  publish: ->
    @logger.info "PUBLISH: ", arguments if @ui?
    amplify.publish.apply this, arguments

  subscribe: ->
    @logger.info "SUBSCRIBE: ", arguments if @ui?
    amplify.subscribe.apply this, arguments

  unsubscribe: ->
    @logger.info "UNSUBSCRIBE: ", arguments if @ui?
    amplify.unsubscribe.apply this, arguments