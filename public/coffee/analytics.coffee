window.analytics = {
  isLocal: ->
    window.location.hostname.match(/localhost/)
  track: (event, properties) ->
    mixpanel.track(event, properties) if not @isLocal
}