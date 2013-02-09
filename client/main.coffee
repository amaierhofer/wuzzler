changeState = (table) ->
  Session.set('busy', table.busy)
  if table.busy then counter.start() else counter.stop()


status_view =
  status: -> if Session.get('busy') then 'busy' else 'free'
  counter: -> if Session.get('busy') then Session.get('counter')

actions_view =
  busy: -> Session.get('busy')
  events:
    'click button:contains("Now")': =>
      Table.update(table_id(), busy: true, since: Date.now())

$.extend(Template.status, status_view)
$.extend(Template.actions, actions_view)


Table.find({}).observe
  added: (table) -> changeState(table)
  changed: (table)-> changeState(table)






