if Meteor.isClient
  Template.hello.greeting = -> 'welcome to wuzzler.'

  Template.hello.events
    'click #input': ->
      console.log 'pushed the button'

if Meteor.isServer
  Meteor.startup ->

