Meteor.startup ->
  log "started: #{new Date()}"
  Table.remove({})
  Table.insert({busy: false, since: Date.now()})

