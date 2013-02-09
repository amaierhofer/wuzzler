Table = new Meteor.Collection("table")

table = -> Table.findOne()
table_id = -> Table.findOne()._id

log = ->
  console.info(arguments...) if console
