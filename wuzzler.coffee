Table = new Meteor.Collection("table")

table = ->
  Session.get('table') && Table.find(Session.get('table')).fetch()[0]

class Counter
  constructor: ->
    @end = table().since + (0.1 * 60 * 1000)
    @start()

  start: ->
    @id = Meteor.setInterval(@update, 1000)
    @update()

   update: =>
     Session.set('counter', @value())
     @stop() if @value() <= 0

   value: ->
     Math.round((@end - parseInt(new Date().getTime(),10)) / 1000)

   stop: ->
     Session.set('counter', null)
     Meteor.clearInterval(@id)
     # Table.update(table()._id, busy: false)


     

if Meteor.isClient
  Session.set('counter', null)
  Table.find().observe
    added: (obj, idx) ->
      Session.set('table', obj._id)
      new Counter() if obj.busy


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

        Table.update(table()._id, busy: !table().busy, since: Date.now())

  $.extend(Template.table, table_view)

if Meteor.isServer
  Meteor.startup ->
    if Table.find().count() is 0
      Table.insert(busy: false)

      

