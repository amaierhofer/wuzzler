Table = new Meteor.Collection("table")
table = -> Table.findOne()
counter = new Counter()

log = ->
  console.info(arguments...) if console
