counter = do ->
  intervalId = 0
  set = (val) -> Session.set('counter', val)
  get = -> Session.get('counter')

  start: ->
    if intervalId is 0
      set(2)
      counter.update()
      intervalId = setInterval(counter.update, 1000)

  update: ->
    if get() > 0 then set(get() - 1) else counter.stop()

  stop: ->
    if intervalId isnt 0
      clearInterval(intervalId)
      intervalId = 0
      Table.update(table_id(), busy: false)
