define [
    'space-pen'
  ], (View)->

    class Status extends View
      @content: ->
        @div id:'status'