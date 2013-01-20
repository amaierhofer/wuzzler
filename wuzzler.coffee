Table = new Meteor.Collection("table")
table = -> Table.findOne()
counter = new Counter()


if Meteor.isClient
  Table.find().observe
    added: -> counter.check()
    changed: -> counter.check()

  table_view =
    status: -> if table() && table().busy then "besetzt" else "frei"
    is_free: -> table() && !table().busy
    countdown: ->  Session.get('counter') || ""
    events:
      'click input': =>
        Table.update(table()._id, busy: !table().busy, since: Date.now())

  $.extend(Template.table, table_view)

if Meteor.isServer
  Meteor.startup ->
    if Table.find().count() is 0
      Table.insert(busy: false)

      

