---
search:
  boost: 0.5
---

# Playbacks

| Method | Path (Parameters are case-sensitive) | Return Model | Summary |
|:------ |:------------------------------------ |:------------ |:------- |
| GET | [/playbacks/\{playbackId\}](#get) | [Playback](../Asterisk_REST_Data_Models#playback) | Get a playback's details. |
| DELETE | [/playbacks/\{playbackId\}](#stop) | void | Stop a playback. |
| POST | [/playbacks/\{playbackId\}/control](#control) | void | Control a playback. |

---
[//]: # (anchor:get)
## get
### GET /playbacks/\{playbackId\}
Get a playback's details.

### Path parameters
Parameters are case-sensitive.
* playbackId: _string_ - Playback's id

### Error Responses
* 404 - The playback cannot be found

---
[//]: # (anchor:stop)
## stop
### DELETE /playbacks/\{playbackId\}
Stop a playback.

### Path parameters
Parameters are case-sensitive.
* playbackId: _string_ - Playback's id

### Error Responses
* 404 - The playback cannot be found

---
[//]: # (anchor:control)
## control
### POST /playbacks/\{playbackId\}/control
Control a playback.

### Path parameters
Parameters are case-sensitive.
* playbackId: _string_ - Playback's id

### Query parameters
* operation: _string_ - *(required)* Operation to perform on the playback.
  * Allowed values: restart, pause, unpause, reverse, forward

### Error Responses
* 400 - The provided operation parameter was invalid
* 404 - The playback cannot be found
* 409 - The operation cannot be performed in the playback's current state
