---
search:
  boost: 0.5
---

# Bridges

| Method | Path (Parameters are case-sensitive) | Return Model | Summary |
|:------ |:------------------------------------ |:------------ |:------- |
| GET | [/bridges](#list) | [List\[Bridge\]](../Asterisk_REST_Data_Models#bridge) | List all active bridges in Asterisk. |
| POST | [/bridges](#create) | [Bridge](../Asterisk_REST_Data_Models#bridge) | Create a new bridge. |
| POST | [/bridges/\{bridgeId\}](#createwithid) | [Bridge](../Asterisk_REST_Data_Models#bridge) | Create a new bridge or updates an existing one. |
| GET | [/bridges/\{bridgeId\}](#get) | [Bridge](../Asterisk_REST_Data_Models#bridge) | Get bridge details. |
| DELETE | [/bridges/\{bridgeId\}](#destroy) | void | Shut down a bridge. |
| POST | [/bridges/\{bridgeId\}/addChannel](#addchannel) | void | Add a channel to a bridge. |
| POST | [/bridges/\{bridgeId\}/removeChannel](#removechannel) | void | Remove a channel from a bridge. |
| POST | [/bridges/\{bridgeId\}/videoSource/\{channelId\}](#setvideosource) | void | Set a channel as the video source in a multi-party mixing bridge. This operation has no effect on bridges with two or fewer participants. |
| DELETE | [/bridges/\{bridgeId\}/videoSource](#clearvideosource) | void | Removes any explicit video source in a multi-party mixing bridge. This operation has no effect on bridges with two or fewer participants. When no explicit video source is set, talk detection will be used to determine the active video stream. |
| POST | [/bridges/\{bridgeId\}/moh](#startmoh) | void | Play music on hold to a bridge or change the MOH class that is playing. |
| DELETE | [/bridges/\{bridgeId\}/moh](#stopmoh) | void | Stop playing music on hold to a bridge. |
| POST | [/bridges/\{bridgeId\}/play](#play) | [Playback](../Asterisk_REST_Data_Models#playback) | Start playback of media on a bridge. |
| POST | [/bridges/\{bridgeId\}/play/\{playbackId\}](#playwithid) | [Playback](../Asterisk_REST_Data_Models#playback) | Start playback of media on a bridge. |
| POST | [/bridges/\{bridgeId\}/record](#record) | [LiveRecording](../Asterisk_REST_Data_Models#liverecording) | Start a recording. |

---
[//]: # (anchor:list)
## list
### GET /bridges
List all active bridges in Asterisk.

---
[//]: # (anchor:create)
## create
### POST /bridges
Create a new bridge. This bridge persists until it has been shut down, or Asterisk has been shut down.

### Query parameters
* type: _string_ - Comma separated list of bridge type attributes (mixing, holding, dtmf_events, proxy_media, video_sfu, video_single).
* bridgeId: _string_ - Unique ID to give to the bridge being created.
* name: _string_ - Name to give to the bridge being created.

---
[//]: # (anchor:createwithid)
## createWithId
### POST /bridges/\{bridgeId\}
Create a new bridge or updates an existing one. This bridge persists until it has been shut down, or Asterisk has been shut down.

### Path parameters
Parameters are case-sensitive.
* bridgeId: _string_ - Unique ID to give to the bridge being created.

### Query parameters
* type: _string_ - Comma separated list of bridge type attributes (mixing, holding, dtmf_events, proxy_media, video_sfu, video_single) to set.
* name: _string_ - Set the name of the bridge.

---
[//]: # (anchor:get)
## get
### GET /bridges/\{bridgeId\}
Get bridge details.

### Path parameters
Parameters are case-sensitive.
* bridgeId: _string_ - Bridge's id

### Error Responses
* 404 - Bridge not found

---
[//]: # (anchor:destroy)
## destroy
### DELETE /bridges/\{bridgeId\}
Shut down a bridge. If any channels are in this bridge, they will be removed and resume whatever they were doing beforehand.

### Path parameters
Parameters are case-sensitive.
* bridgeId: _string_ - Bridge's id

### Error Responses
* 404 - Bridge not found

---
[//]: # (anchor:addchannel)
## addChannel
### POST /bridges/\{bridgeId\}/addChannel
Add a channel to a bridge.

### Path parameters
Parameters are case-sensitive.
* bridgeId: _string_ - Bridge's id

### Query parameters
* channel: _string_ - *(required)* Ids of channels to add to bridge
  * Allows comma separated values.
* role: _string_ - Channel's role in the bridge
* absorbDTMF: _boolean_ - Absorb DTMF coming from this channel, preventing it to pass through to the bridge
* mute: _boolean_ - Mute audio from this channel, preventing it to pass through to the bridge
* inhibitConnectedLineUpdates: _boolean_ - Do not present the identity of the newly connected channel to other bridge members

### Error Responses
* 400 - Channel not found
* 404 - Bridge not found
* 409 - Bridge not in Stasis application; Channel currently recording
* 422 - Channel not in Stasis application

---
[//]: # (anchor:removechannel)
## removeChannel
### POST /bridges/\{bridgeId\}/removeChannel
Remove a channel from a bridge.

### Path parameters
Parameters are case-sensitive.
* bridgeId: _string_ - Bridge's id

### Query parameters
* channel: _string_ - *(required)* Ids of channels to remove from bridge
  * Allows comma separated values.

### Error Responses
* 400 - Channel not found
* 404 - Bridge not found
* 409 - Bridge not in Stasis application
* 422 - Channel not in this bridge

---
[//]: # (anchor:setvideosource)
## setVideoSource
### POST /bridges/\{bridgeId\}/videoSource/\{channelId\}
Set a channel as the video source in a multi-party mixing bridge. This operation has no effect on bridges with two or fewer participants.

### Path parameters
Parameters are case-sensitive.
* bridgeId: _string_ - Bridge's id
* channelId: _string_ - Channel's id

### Error Responses
* 404 - Bridge or Channel not found
* 409 - Channel not in Stasis application
* 422 - Channel not in this Bridge

---
[//]: # (anchor:clearvideosource)
## clearVideoSource
### DELETE /bridges/\{bridgeId\}/videoSource
Removes any explicit video source in a multi-party mixing bridge. This operation has no effect on bridges with two or fewer participants. When no explicit video source is set, talk detection will be used to determine the active video stream.

### Path parameters
Parameters are case-sensitive.
* bridgeId: _string_ - Bridge's id

### Error Responses
* 404 - Bridge not found

---
[//]: # (anchor:startmoh)
## startMoh
### POST /bridges/\{bridgeId\}/moh
Play music on hold to a bridge or change the MOH class that is playing.

### Path parameters
Parameters are case-sensitive.
* bridgeId: _string_ - Bridge's id

### Query parameters
* mohClass: _string_ - Channel's id

### Error Responses
* 404 - Bridge not found
* 409 - Bridge not in Stasis application

---
[//]: # (anchor:stopmoh)
## stopMoh
### DELETE /bridges/\{bridgeId\}/moh
Stop playing music on hold to a bridge. This will only stop music on hold being played via POST bridges/\{bridgeId\}/moh.

### Path parameters
Parameters are case-sensitive.
* bridgeId: _string_ - Bridge's id

### Error Responses
* 404 - Bridge not found
* 409 - Bridge not in Stasis application

---
[//]: # (anchor:play)
## play
### POST /bridges/\{bridgeId\}/play
Start playback of media on a bridge. The media URI may be any of a number of URI's. Currently sound:, recording:, number:, digits:, characters:, and tone: URI's are supported. This operation creates a playback resource that can be used to control the playback of media (pause, rewind, fast forward, etc.)

### Path parameters
Parameters are case-sensitive.
* bridgeId: _string_ - Bridge's id

### Query parameters
* media: _string_ - *(required)* Media URIs to play.
  * Allows comma separated values.
* lang: _string_ - For sounds, selects language for sound.
* offsetms: _int_ - Number of milliseconds to skip before playing. Only applies to the first URI if multiple media URIs are specified.
  * Allowed range: Min: 0; Max: None
* skipms: _int_ - Number of milliseconds to skip for forward/reverse operations.
  * Default: 3000
  * Allowed range: Min: 0; Max: None
* playbackId: _string_ - Playback Id.

### Error Responses
* 404 - Bridge not found
* 409 - Bridge not in a Stasis application

---
[//]: # (anchor:playwithid)
## playWithId
### POST /bridges/\{bridgeId\}/play/\{playbackId\}
Start playback of media on a bridge. The media URI may be any of a number of URI's. Currently sound:, recording:, number:, digits:, characters:, and tone: URI's are supported. This operation creates a playback resource that can be used to control the playback of media (pause, rewind, fast forward, etc.)

### Path parameters
Parameters are case-sensitive.
* bridgeId: _string_ - Bridge's id
* playbackId: _string_ - Playback ID.

### Query parameters
* media: _string_ - *(required)* Media URIs to play.
  * Allows comma separated values.
* lang: _string_ - For sounds, selects language for sound.
* offsetms: _int_ - Number of milliseconds to skip before playing. Only applies to the first URI if multiple media URIs are specified.
  * Allowed range: Min: 0; Max: None
* skipms: _int_ - Number of milliseconds to skip for forward/reverse operations.
  * Default: 3000
  * Allowed range: Min: 0; Max: None

### Error Responses
* 404 - Bridge not found
* 409 - Bridge not in a Stasis application

---
[//]: # (anchor:record)
## record
### POST /bridges/\{bridgeId\}/record
Start a recording. This records the mixed audio from all channels participating in this bridge.

### Path parameters
Parameters are case-sensitive.
* bridgeId: _string_ - Bridge's id

### Query parameters
* name: _string_ - *(required)* Recording's filename
* format: _string_ - *(required)* Format to encode audio in
* maxDurationSeconds: _int_ - Maximum duration of the recording, in seconds. 0 for no limit.
  * Allowed range: Min: 0; Max: None
* maxSilenceSeconds: _int_ - Maximum duration of silence, in seconds. 0 for no limit.
  * Allowed range: Min: 0; Max: None
* ifExists: _string_ - Action to take if a recording with the same name already exists.
  * Default: fail
  * Allowed values: fail, overwrite, append
* beep: _boolean_ - Play beep when recording begins
* terminateOn: _string_ - DTMF input to terminate recording.
  * Default: none
  * Allowed values: none, any, *, #

### Error Responses
* 400 - Invalid parameters
* 404 - Bridge not found
* 409 - Bridge is not in a Stasis application; A recording with the same name already exists on the system and can not be overwritten because it is in progress or ifExists=fail
* 422 - The format specified is unknown on this system
