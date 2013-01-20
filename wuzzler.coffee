Table = new Meteor.Collection("table")

table = ->
  Table.findOne() || { busy: false }

class Counter
  constructor: ->
    @end = Date.now() + (0.1 * 60 * 1000)
    @start()

  start: ->
    @id = Meteor.setInterval(@update, 1000)
    console.log('started: ', @id)
    Table.update(table()._id, busy: true)

   update: =>
     console.log('updating: ', @value())
     Table.update(table()._id, until: @value())

     @stop() if (@end - @time() < 0)

   value: ->
     Math.round((@end - @time()) / 1000)

   stop: ->
     console.log('clearing interval: ', @id)
     Meteor.clearInterval(@id)
     Table.update(table()._id, busy: false, until: null)


   time: ->
     parseInt(new Date().getTime(),10)

if Meteor.isClient

  new Counter()

  counter_view =
    value: -> table().until

  table_view =
    status: -> if table().busy then "besetzt" else "frei"
    countdown: -> 'asdf'

    is_free: -> !table().busy
    events:
      'click input': ->
        console.log table()
        Table.update(table()._id, busy: !table().busy)

  $.extend(Template.table, table_view)
  $.extend(Template.counter, counter_view)

if Meteor.isServer
  Meteor.startup ->
    if Table.find().count() is 0
      Table.insert(busy: false)

      

