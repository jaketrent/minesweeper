window.analytics = {
  inited: false
  init: ->
    mixpanel.init("6d2b0175b1df82ef449fde0b29c68bec");
  isLocal: ->
    window.location.hostname.match(/localhost/)
  track: (event, properties) ->
    @init if (!@inited) 
    mixpanel.track(event, properties) if not @isLocal
}