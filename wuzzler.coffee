Table = new Meteor.Collection("table")

if Meteor.isClient
  table = -> Table.findOne() || { busy: false }

  table_view =
    status: -> if table().busy then "besetzt" else "frei"
    is_free: -> !table().busy
    events:
      'click input': ->
        console.log table()
        Table.update(table()._id, busy: !table().busy)

  $.extend(Template.table, table_view)

if Meteor.isServer
  Meteor.startup ->
    if Table.find().count() is 0
      Table.insert(busy: false)

