---
search:
  boost: 0.5
---

# Events

| Method | Path (Parameters are case-sensitive) | Return Model | Summary |
|:------ |:------------------------------------ |:------------ |:------- |
| GET | [/events](#eventwebsocket) | [Message](../Asterisk_REST_Data_Models#message) | WebSocket connection for events. |
| POST | [/events/user/\{eventName\}](#userevent) | void | Generate a user event. |

---
[//]: # (anchor:eventwebsocket)
## eventWebsocket
### GET /events
WebSocket connection for events.

### Query parameters
* app: _string_ - *(required)* Applications to subscribe to.
  * Allows comma separated values.
* subscribeAll: _boolean_ - Subscribe to all Asterisk events. If provided, the applications listed will be subscribed to all events, effectively disabling the application specific subscriptions. Default is 'false'.

---
[//]: # (anchor:userevent)
## userEvent
### POST /events/user/\{eventName\}
Generate a user event.

### Path parameters
Parameters are case-sensitive.
* eventName: _string_ - Event name

### Query parameters
* application: _string_ - *(required)* The name of the application that will receive this event
* source: _string_ - URI for event source (channel:\{channelId\}, bridge:\{bridgeId\}, endpoint:\{tech\}/\{resource\}, deviceState:\{deviceName\}
  * Allows comma separated values.


### Body parameter
* variables: containers - The "variables" key in the body object holds custom key/value pairs to add to the user event. Ex. \{ "variables": \{ "key": "value" \} \}

### Error Responses
* 404 - Application does not exist.
* 422 - Event source not found.
* 400 - Invalid even tsource URI or userevent data.
