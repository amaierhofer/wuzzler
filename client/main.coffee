changeState = (table) ->
  Session.set('busy', table.busy)
  if table.busy then counter.start() else counter.stop()

add_view_logic = do ->
  Session.set('selected', [])

  usernames: -> user.username for user in Meteor.users.find({}).fetch()
  isValid: (name) ->
    Meteor.users.findOne({username: name}) and
    name isnt Meteor.user().username and not
    _.contains(Session.get('selected'), name)

  add: (name) ->
    if add_view_logic.isValid(name)
      selected = Session.get('selected')
      selected.push(name)
      Session.set('selected', selected)


add_view =
  names: -> JSON.stringify(add_view_logic.usernames())
  added: -> Session.get('selected')
  events:
    'change #add': (e) -> add_view_logic.add($(e.target).val())

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
$.extend(Template.add, add_view)

Table.find({}).observe
  added: (table) -> changeState(table)
  changed: (table)-> changeState(table)






