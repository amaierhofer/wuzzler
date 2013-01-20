
class Counter
  check: ->
    log 'checking', @table()
    if @table() and @table().busy
      @start()

  start: ->
    @end = @table().since + (0.1 * 60 * 1000)
    @id = Meteor.setInterval(@calculate, 1000)
    @calculate()

   calculate: =>
     log 'calculate', @value()
     Session.set('counter', @value() || "NaN")
     @stop() if @value() <= 0

   update: (busy) ->
     log 'update', busy
     if busy then @start() else @stop()

   value: ->
     Math.round((@end - parseInt(new Date().getTime(),10)) / 1000)

   stop: ->
     Session.set('counter', null)
     Meteor.clearInterval(@id)
     Table.update(table()._id, busy: false)

   table: -> window.table()
