if Meteor.isClient
  Meteor.startup ->
    Session.set('status', 'frei')
   
  table =
    status: -> Session.get('status')
    is_free: -> Session.get('status') == "frei"
    events:
      'click input': ->
        if Session.get('status') is 'frei'
          Session.set('status','besetzt')
        else
          Session.set('status','frei')

  $.extend(Template.table, table)

