Table = new Meteor.Collection("table")

table = ->
  Session.get('table') && Table.find(Session.get('table')).fetch()[0]

class Counter
  constructor: ->
    @end = Date.now() + (0.1 * 60 * 1000)
    @start()

  start: ->
    @id = Meteor.setInterval(@update, 1000)
    console.log('started: ', @id)
    Session.set('counter', @value())

   update: =>
     console.log('updating: ', @value())
     Session.set('counter', @value())

     @stop() if (@end - @time() < 0)

   value: ->
     Math.round((@end - @time()) / 1000)

   stop: ->
     Table.update(table()._id, busy: false)
     Session.set('counter', null)
     console.log('clearing interval: ', @id)
     Meteor.clearInterval(@id)

   time: ->
     parseInt(new Date().getTime(),10)

if Meteor.isClient
  Session.set('counter', null)
  Table.find().observe
    added: (obj, idx) -> Session.set('table', obj._id)

  table_view =
    status: -> if !Template.table.is_free() then "besetzt" else "frei"
    is_free: -> table() && !table().busy

    countdown: -> Session.get('counter') || ""

    events:
      'click input': =>
        if !table().busy
          @counter = new Counter()
        else
          @counter && @counter.stop()

        Table.update(table()._id, busy: !table().busy)

  $.extend(Template.table, table_view)

if Meteor.isServer
  Meteor.startup ->
    if Table.find().count() is 0
      Table.insert(busy: false)

      

