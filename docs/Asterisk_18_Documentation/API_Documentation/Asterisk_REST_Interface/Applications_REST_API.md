---
search:
  boost: 0.5
---

# Applications

| Method | Path (Parameters are case-sensitive) | Return Model | Summary |
|:------ |:------------------------------------ |:------------ |:------- |
| GET | [/applications](#list) | [List\[Application\]](../Asterisk_REST_Data_Models#application) | List all applications. |
| GET | [/applications/\{applicationName\}](#get) | [Application](../Asterisk_REST_Data_Models#application) | Get details of an application. |
| POST | [/applications/\{applicationName\}/subscription](#subscribe) | [Application](../Asterisk_REST_Data_Models#application) | Subscribe an application to a event source. |
| DELETE | [/applications/\{applicationName\}/subscription](#unsubscribe) | [Application](../Asterisk_REST_Data_Models#application) | Unsubscribe an application from an event source. |
| PUT | [/applications/\{applicationName\}/eventFilter](#filter) | [Application](../Asterisk_REST_Data_Models#application) | Filter application events types. |

---
[//]: # (anchor:list)
## list
### GET /applications
List all applications.

---
[//]: # (anchor:get)
## get
### GET /applications/\{applicationName\}
Get details of an application.

### Path parameters
Parameters are case-sensitive.
* applicationName: _string_ - Application's name

### Error Responses
* 404 - Application does not exist.

---
[//]: # (anchor:subscribe)
## subscribe
### POST /applications/\{applicationName\}/subscription
Subscribe an application to a event source. Returns the state of the application after the subscriptions have changed

### Path parameters
Parameters are case-sensitive.
* applicationName: _string_ - Application's name

### Query parameters
* eventSource: _string_ - *(required)* URI for event source (channel:\{channelId\}, bridge:\{bridgeId\}, endpoint:\{tech\}\[/\{resource\}\], deviceState:\{deviceName\}
    * Allows comma separated values.

### Error Responses
* 400 - Missing parameter.
* 404 - Application does not exist.
* 422 - Event source does not exist.

---
[//]: # (anchor:unsubscribe)
## unsubscribe
### DELETE /applications/\{applicationName\}/subscription
Unsubscribe an application from an event source. Returns the state of the application after the subscriptions have changed

### Path parameters
Parameters are case-sensitive.
* applicationName: _string_ - Application's name

### Query parameters
* eventSource: _string_ - *(required)* URI for event source (channel:\{channelId\}, bridge:\{bridgeId\}, endpoint:\{tech\}\[/\{resource\}\], deviceState:\{deviceName\}
    * Allows comma separated values.

### Error Responses
* 400 - Missing parameter; event source scheme not recognized.
* 404 - Application does not exist.
* 409 - Application not subscribed to event source.
* 422 - Event source does not exist.

---
[//]: # (anchor:filter)
## filter
### PUT /applications/\{applicationName\}/eventFilter
Filter application events types. Allowed and/or disallowed event type filtering can be done. The body (parameter) should specify a JSON key/value object that describes the type of event filtering needed. One, or both of the following keys can be designated:

"allowed" - Specifies an allowed list of event types
"disallowed" - Specifies a disallowed list of event types

Further, each of those key's value should be a JSON array that holds zero, or more JSON key/value objects. Each of these objects must contain the following key with an associated value:

"type" - The type name of the event to filter

The value must be the string name (case sensitive) of the event type that needs filtering. For example:

\{ "allowed": \[ \{ "type": "StasisStart" \}, \{ "type": "StasisEnd" \} \] \}

As this specifies only an allowed list, then only those two event type messages are sent to the application. No other event messages are sent.

The following rules apply:

* If the body is empty, both the allowed and disallowed filters are set empty.
* If both list types are given then both are set to their respective values (note, specifying an empty array for a given type sets that type to empty).
* If only one list type is given then only that type is set. The other type is not updated.
* An empty "allowed" list means all events are allowed.
* An empty "disallowed" list means no events are disallowed.
* Disallowed events take precedence over allowed events if the event type is specified in both lists.

### Path parameters
Parameters are case-sensitive.
* applicationName: _string_ - Application's name


### Body parameter
* filter: object - Specify which event types to allow/disallow

### Error Responses
* 400 - Bad request.
* 404 - Application does not exist.
