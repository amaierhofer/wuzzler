changeState = (table) ->
  Session.set('busy', table.busy)
  if table.busy then counter.start() else counter.stop()


status_view =
  busy: -> Session.get('busy')
  status: -> if Session.get('busy') then 'busy' else 'free'
  counter: -> if Session.get('busy') then Session.get('counter')
  username: -> table().user || "anonymous"

actions_view =
  releasable: -> table() && table().user is Meteor.user().username
  busy: -> Session.get('busy')
  events:

    'click button:contains("Release")': =>
      data =
        busy: false
        since: Date.now()
      Table.update(table_id(), data)

    'click button:contains("Now")': =>
      data =
        busy: true
        since: Date.now()
        user: if Meteor.user() then Meteor.user().username else "anonymous"

      Table.update(table_id(), data)

$.extend(Template.status, status_view)
$.extend(Template.actions, actions_view)

Table.find({}).observe
  added: (table) -> changeState(table)
  changed: (table)-> changeState(table)






