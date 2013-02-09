Meteor.startup ->
  if Table.find().count() is 0
    Table.insert(busy: false)
