---
search:
  boost: 0.5
---

# Channels

| Method | Path (Parameters are case-sensitive) | Return Model | Summary |
|:------ |:------------------------------------ |:------------ |:------- |
| GET | [/channels](#list) | [List\[Channel\]](../Asterisk_REST_Data_Models#channel) | List all active channels in Asterisk. |
| POST | [/channels](#originate) | [Channel](../Asterisk_REST_Data_Models#channel) | Create a new channel (originate). |
| POST | [/channels/create](#create) | [Channel](../Asterisk_REST_Data_Models#channel) | Create channel. |
| GET | [/channels/\{channelId\}](#get) | [Channel](../Asterisk_REST_Data_Models#channel) | Channel details. |
| POST | [/channels/\{channelId\}](#originatewithid) | [Channel](../Asterisk_REST_Data_Models#channel) | Create a new channel (originate with id). |
| DELETE | [/channels/\{channelId\}](#hangup) | void | Delete (i.e. hangup) a channel. |
| POST | [/channels/\{channelId\}/continue](#continueindialplan) | void | Exit application; continue execution in the dialplan. |
| POST | [/channels/\{channelId\}/move](#move) | void | Move the channel from one Stasis application to another. |
| POST | [/channels/\{channelId\}/redirect](#redirect) | void | Redirect the channel to a different location. |
| POST | [/channels/\{channelId\}/answer](#answer) | void | Answer a channel. |
| POST | [/channels/\{channelId\}/ring](#ring) | void | Indicate ringing to a channel. |
| DELETE | [/channels/\{channelId\}/ring](#ringstop) | void | Stop ringing indication on a channel if locally generated. |
| POST | [/channels/\{channelId\}/dtmf](#senddtmf) | void | Send provided DTMF to a given channel. |
| POST | [/channels/\{channelId\}/mute](#mute) | void | Mute a channel. |
| DELETE | [/channels/\{channelId\}/mute](#unmute) | void | Unmute a channel. |
| POST | [/channels/\{channelId\}/hold](#hold) | void | Hold a channel. |
| DELETE | [/channels/\{channelId\}/hold](#unhold) | void | Remove a channel from hold. |
| POST | [/channels/\{channelId\}/moh](#startmoh) | void | Play music on hold to a channel. |
| DELETE | [/channels/\{channelId\}/moh](#stopmoh) | void | Stop playing music on hold to a channel. |
| POST | [/channels/\{channelId\}/silence](#startsilence) | void | Play silence to a channel. |
| DELETE | [/channels/\{channelId\}/silence](#stopsilence) | void | Stop playing silence to a channel. |
| POST | [/channels/\{channelId\}/play](#play) | [Playback](../Asterisk_REST_Data_Models#playback) | Start playback of media. |
| POST | [/channels/\{channelId\}/play/\{playbackId\}](#playwithid) | [Playback](../Asterisk_REST_Data_Models#playback) | Start playback of media and specify the playbackId. |
| POST | [/channels/\{channelId\}/record](#record) | [LiveRecording](../Asterisk_REST_Data_Models#liverecording) | Start a recording. |
| GET | [/channels/\{channelId\}/variable](#getchannelvar) | [Variable](../Asterisk_REST_Data_Models#variable) | Get the value of a channel variable or function. |
| POST | [/channels/\{channelId\}/variable](#setchannelvar) | void | Set the value of a channel variable or function. |
| POST | [/channels/\{channelId\}/snoop](#snoopchannel) | [Channel](../Asterisk_REST_Data_Models#channel) | Start snooping. |
| POST | [/channels/\{channelId\}/snoop/\{snoopId\}](#snoopchannelwithid) | [Channel](../Asterisk_REST_Data_Models#channel) | Start snooping. |
| POST | [/channels/\{channelId\}/dial](#dial) | void | Dial a created channel. |
| GET | [/channels/\{channelId\}/rtp_statistics](#rtpstatistics) | [RTPstat](../Asterisk_REST_Data_Models#rtpstat) | RTP stats on a channel. |
| POST | [/channels/externalMedia](#externalmedia) | [Channel](../Asterisk_REST_Data_Models#channel) | Start an External Media session. |

---
[//]: # (anchor:list)
## list
### GET /channels
List all active channels in Asterisk.

---
[//]: # (anchor:originate)
## originate
### POST /channels
Create a new channel (originate). The new channel is created immediately and a snapshot of it returned. If a Stasis application is provided it will be automatically subscribed to the originated channel for further events and updates.

### Query parameters
* endpoint: _string_ - *(required)* Endpoint to call.
* extension: _string_ - The extension to dial after the endpoint answers. Mutually exclusive with 'app'.
* context: _string_ - The context to dial after the endpoint answers. If omitted, uses 'default'. Mutually exclusive with 'app'.
* priority: _long_ - The priority to dial after the endpoint answers. If omitted, uses 1. Mutually exclusive with 'app'.
* label: _string_ - The label to dial after the endpoint answers. Will supersede 'priority' if provided. Mutually exclusive with 'app'.
* app: _string_ - The application that is subscribed to the originated channel. When the channel is answered, it will be passed to this Stasis application. Mutually exclusive with 'context', 'extension', 'priority', and 'label'.
* appArgs: _string_ - The application arguments to pass to the Stasis application provided by 'app'. Mutually exclusive with 'context', 'extension', 'priority', and 'label'.
* callerId: _string_ - CallerID to use when dialing the endpoint or extension.
* timeout: _int_ - Timeout (in seconds) before giving up dialing, or -1 for no timeout.
    * Default: 30
* channelId: _string_ - The unique id to assign the channel on creation.
* otherChannelId: _string_ - The unique id to assign the second channel when using local channels.
* originator: _string_ - The unique id of the channel which is originating this one.
* formats: _string_ - The format name capability list to use if originator is not specified. Ex. "ulaw,slin16".  Format names can be found with "core show codecs".


### Body parameter
* variables: containers - The "variables" key in the body object holds variable key/value pairs to set on the channel on creation. Other keys in the body object are interpreted as query parameters. Ex. \{ "endpoint": "SIP/Alice", "variables": \{ "CALLERID(name)": "Alice" \} \}

### Error Responses
* 400 - Invalid parameters for originating a channel.
* 409 - Channel with given unique ID already exists.

---
[//]: # (anchor:create)
## create
### POST /channels/create
Create channel.

### Query parameters
* endpoint: _string_ - *(required)* Endpoint for channel communication
* app: _string_ - *(required)* Stasis Application to place channel into
* appArgs: _string_ - The application arguments to pass to the Stasis application provided by 'app'. Mutually exclusive with 'context', 'extension', 'priority', and 'label'.
* channelId: _string_ - The unique id to assign the channel on creation.
* otherChannelId: _string_ - The unique id to assign the second channel when using local channels.
* originator: _string_ - Unique ID of the calling channel
* formats: _string_ - The format name capability list to use if originator is not specified. Ex. "ulaw,slin16".  Format names can be found with "core show codecs".


### Body parameter
* variables: containers - The "variables" key in the body object holds variable key/value pairs to set on the channel on creation. Other keys in the body object are interpreted as query parameters. Ex. \{ "endpoint": "SIP/Alice", "variables": \{ "CALLERID(name)": "Alice" \} \}

### Error Responses
* 409 - Channel with given unique ID already exists.

---
[//]: # (anchor:get)
## get
### GET /channels/\{channelId\}
Channel details.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Error Responses
* 404 - Channel not found

---
[//]: # (anchor:originatewithid)
## originateWithId
### POST /channels/\{channelId\}
Create a new channel (originate with id). The new channel is created immediately and a snapshot of it returned. If a Stasis application is provided it will be automatically subscribed to the originated channel for further events and updates.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - The unique id to assign the channel on creation.

### Query parameters
* endpoint: _string_ - *(required)* Endpoint to call.
* extension: _string_ - The extension to dial after the endpoint answers. Mutually exclusive with 'app'.
* context: _string_ - The context to dial after the endpoint answers. If omitted, uses 'default'. Mutually exclusive with 'app'.
* priority: _long_ - The priority to dial after the endpoint answers. If omitted, uses 1. Mutually exclusive with 'app'.
* label: _string_ - The label to dial after the endpoint answers. Will supersede 'priority' if provided. Mutually exclusive with 'app'.
* app: _string_ - The application that is subscribed to the originated channel. When the channel is answered, it will be passed to this Stasis application. Mutually exclusive with 'context', 'extension', 'priority', and 'label'.
* appArgs: _string_ - The application arguments to pass to the Stasis application provided by 'app'. Mutually exclusive with 'context', 'extension', 'priority', and 'label'.
* callerId: _string_ - CallerID to use when dialing the endpoint or extension.
* timeout: _int_ - Timeout (in seconds) before giving up dialing, or -1 for no timeout.
    * Default: 30
* otherChannelId: _string_ - The unique id to assign the second channel when using local channels.
* originator: _string_ - The unique id of the channel which is originating this one.
* formats: _string_ - The format name capability list to use if originator is not specified. Ex. "ulaw,slin16".  Format names can be found with "core show codecs".


### Body parameter
* variables: containers - The "variables" key in the body object holds variable key/value pairs to set on the channel on creation. Other keys in the body object are interpreted as query parameters. Ex. \{ "endpoint": "SIP/Alice", "variables": \{ "CALLERID(name)": "Alice" \} \}

### Error Responses
* 400 - Invalid parameters for originating a channel.
* 409 - Channel with given unique ID already exists.

---
[//]: # (anchor:hangup)
## hangup
### DELETE /channels/\{channelId\}
Delete (i.e. hangup) a channel.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Query parameters
* reason_code: _string_ - The reason code for hanging up the channel for detail use. Mutually exclusive with 'reason'. See detail hangup codes at here. https://docs.asterisk.org/Configuration/Miscellaneous/Hangup-Cause-Mappings/
* reason: _string_ - Reason for hanging up the channel for simple use. Mutually exclusive with 'reason_code'.
    * Allowed values: normal, busy, congestion, no_answer, timeout, rejected, unallocated, normal_unspecified, number_incomplete, codec_mismatch, interworking, failure, answered_elsewhere

### Error Responses
* 400 - Invalid reason for hangup provided
* 404 - Channel not found

---
[//]: # (anchor:continueindialplan)
## continueInDialplan
### POST /channels/\{channelId\}/continue
Exit application; continue execution in the dialplan.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Query parameters
* context: _string_ - The context to continue to.
* extension: _string_ - The extension to continue to.
* priority: _int_ - The priority to continue to.
* label: _string_ - The label to continue to - will supersede 'priority' if both are provided.

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:move)
## move
### POST /channels/\{channelId\}/move
Move the channel from one Stasis application to another.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Query parameters
* app: _string_ - *(required)* The channel will be passed to this Stasis application.
* appArgs: _string_ - The application arguments to pass to the Stasis application provided by 'app'.

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application

---
[//]: # (anchor:redirect)
## redirect
### POST /channels/\{channelId\}/redirect
Redirect the channel to a different location.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Query parameters
* endpoint: _string_ - *(required)* The endpoint to redirect the channel to

### Error Responses
* 400 - Endpoint parameter not provided
* 404 - Channel or endpoint not found
* 409 - Channel not in a Stasis application
* 422 - Endpoint is not the same type as the channel
* 412 - Channel in invalid state

---
[//]: # (anchor:answer)
## answer
### POST /channels/\{channelId\}/answer
Answer a channel.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:ring)
## ring
### POST /channels/\{channelId\}/ring
Indicate ringing to a channel.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:ringstop)
## ringStop
### DELETE /channels/\{channelId\}/ring
Stop ringing indication on a channel if locally generated.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:senddtmf)
## sendDTMF
### POST /channels/\{channelId\}/dtmf
Send provided DTMF to a given channel.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Query parameters
* dtmf: _string_ - DTMF To send.
* before: _int_ - Amount of time to wait before DTMF digits (specified in milliseconds) start.
* between: _int_ - Amount of time in between DTMF digits (specified in milliseconds).
    * Default: 100
* duration: _int_ - Length of each DTMF digit (specified in milliseconds).
    * Default: 100
* after: _int_ - Amount of time to wait after DTMF digits (specified in milliseconds) end.

### Error Responses
* 400 - DTMF is required
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:mute)
## mute
### POST /channels/\{channelId\}/mute
Mute a channel.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Query parameters
* direction: _string_ - Direction in which to mute audio
    * Default: both
    * Allowed values: both, in, out

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:unmute)
## unmute
### DELETE /channels/\{channelId\}/mute
Unmute a channel.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Query parameters
* direction: _string_ - Direction in which to unmute audio
    * Default: both
    * Allowed values: both, in, out

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:hold)
## hold
### POST /channels/\{channelId\}/hold
Hold a channel.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:unhold)
## unhold
### DELETE /channels/\{channelId\}/hold
Remove a channel from hold.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:startmoh)
## startMoh
### POST /channels/\{channelId\}/moh
Play music on hold to a channel. Using media operations such as /play on a channel playing MOH in this manner will suspend MOH without resuming automatically. If continuing music on hold is desired, the stasis application must reinitiate music on hold.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Query parameters
* mohClass: _string_ - Music on hold class to use

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:stopmoh)
## stopMoh
### DELETE /channels/\{channelId\}/moh
Stop playing music on hold to a channel.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:startsilence)
## startSilence
### POST /channels/\{channelId\}/silence
Play silence to a channel. Using media operations such as /play on a channel playing silence in this manner will suspend silence without resuming automatically.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:stopsilence)
## stopSilence
### DELETE /channels/\{channelId\}/silence
Stop playing silence to a channel.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:play)
## play
### POST /channels/\{channelId\}/play
Start playback of media. The media URI may be any of a number of URI's. Currently sound:, recording:, number:, digits:, characters:, and tone: URI's are supported. This operation creates a playback resource that can be used to control the playback of media (pause, rewind, fast forward, etc.)

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Query parameters
* media: _string_ - *(required)* Media URIs to play.
    * Allows comma separated values.
* lang: _string_ - For sounds, selects language for sound.
* offsetms: _int_ - Number of milliseconds to skip before playing. Only applies to the first URI if multiple media URIs are specified.
* skipms: _int_ - Number of milliseconds to skip for forward/reverse operations.
    * Default: 3000
* playbackId: _string_ - Playback ID.

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:playwithid)
## playWithId
### POST /channels/\{channelId\}/play/\{playbackId\}
Start playback of media and specify the playbackId. The media URI may be any of a number of URI's. Currently sound:, recording:, number:, digits:, characters:, and tone: URI's are supported. This operation creates a playback resource that can be used to control the playback of media (pause, rewind, fast forward, etc.)

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id
* playbackId: _string_ - Playback ID.

### Query parameters
* media: _string_ - *(required)* Media URIs to play.
    * Allows comma separated values.
* lang: _string_ - For sounds, selects language for sound.
* offsetms: _int_ - Number of milliseconds to skip before playing. Only applies to the first URI if multiple media URIs are specified.
* skipms: _int_ - Number of milliseconds to skip for forward/reverse operations.
    * Default: 3000

### Error Responses
* 404 - Channel not found
* 409 - Channel not in a Stasis application
* 412 - Channel in invalid state

---
[//]: # (anchor:record)
## record
### POST /channels/\{channelId\}/record
Start a recording. Record audio from a channel. Note that this will not capture audio sent to the channel. The bridge itself has a record feature if that's what you want.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Query parameters
* name: _string_ - *(required)* Recording's filename
* format: _string_ - *(required)* Format to encode audio in
* maxDurationSeconds: _int_ - Maximum duration of the recording, in seconds. 0 for no limit
    * Allowed range: Min: 0; Max: None
* maxSilenceSeconds: _int_ - Maximum duration of silence, in seconds. 0 for no limit
    * Allowed range: Min: 0; Max: None
* ifExists: _string_ - Action to take if a recording with the same name already exists.
    * Default: fail
    * Allowed values: fail, overwrite, append
* beep: _boolean_ - Play beep when recording begins
* terminateOn: _string_ - DTMF input to terminate recording
    * Default: none
    * Allowed values: none, any, *, #

### Error Responses
* 400 - Invalid parameters
* 404 - Channel not found
* 409 - Channel is not in a Stasis application; the channel is currently bridged with other hcannels; A recording with the same name already exists on the system and can not be overwritten because it is in progress or ifExists=fail
* 422 - The format specified is unknown on this system

---
[//]: # (anchor:getchannelvar)
## getChannelVar
### GET /channels/\{channelId\}/variable
Get the value of a channel variable or function.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Query parameters
* variable: _string_ - *(required)* The channel variable or function to get

### Error Responses
* 400 - Missing variable parameter.
* 404 - Channel or variable not found
* 409 - Channel not in a Stasis application

---
[//]: # (anchor:setchannelvar)
## setChannelVar
### POST /channels/\{channelId\}/variable
Set the value of a channel variable or function.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Query parameters
* variable: _string_ - *(required)* The channel variable or function to set
* value: _string_ - The value to set the variable to

### Error Responses
* 400 - Missing variable parameter.
* 404 - Channel not found
* 409 - Channel not in a Stasis application

---
[//]: # (anchor:snoopchannel)
## snoopChannel
### POST /channels/\{channelId\}/snoop
Start snooping. Snoop (spy/whisper) on a specific channel.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Query parameters
* spy: _string_ - Direction of audio to spy on
    * Default: none
    * Allowed values: none, both, out, in
* whisper: _string_ - Direction of audio to whisper into
    * Default: none
    * Allowed values: none, both, out, in
* app: _string_ - *(required)* Application the snooping channel is placed into
* appArgs: _string_ - The application arguments to pass to the Stasis application
* snoopId: _string_ - Unique ID to assign to snooping channel

### Error Responses
* 400 - Invalid parameters
* 404 - Channel not found

---
[//]: # (anchor:snoopchannelwithid)
## snoopChannelWithId
### POST /channels/\{channelId\}/snoop/\{snoopId\}
Start snooping. Snoop (spy/whisper) on a specific channel.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id
* snoopId: _string_ - Unique ID to assign to snooping channel

### Query parameters
* spy: _string_ - Direction of audio to spy on
    * Default: none
    * Allowed values: none, both, out, in
* whisper: _string_ - Direction of audio to whisper into
    * Default: none
    * Allowed values: none, both, out, in
* app: _string_ - *(required)* Application the snooping channel is placed into
* appArgs: _string_ - The application arguments to pass to the Stasis application

### Error Responses
* 400 - Invalid parameters
* 404 - Channel not found

---
[//]: # (anchor:dial)
## dial
### POST /channels/\{channelId\}/dial
Dial a created channel.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Query parameters
* caller: _string_ - Channel ID of caller
* timeout: _int_ - Dial timeout
    * Allowed range: Min: 0; Max: None

### Error Responses
* 404 - Channel cannot be found.
* 409 - Channel cannot be dialed.

---
[//]: # (anchor:rtpstatistics)
## rtpstatistics
### GET /channels/\{channelId\}/rtp_statistics
RTP stats on a channel.

### Path parameters
Parameters are case-sensitive.
* channelId: _string_ - Channel's id

### Error Responses
* 404 - Channel cannot be found.

---
[//]: # (anchor:externalmedia)
## externalMedia
### POST /channels/externalMedia
Start an External Media session. Create a channel to an External Media source/sink.

### Query parameters
* channelId: _string_ - The unique id to assign the channel on creation.
* app: _string_ - *(required)* Stasis Application to place channel into
* external_host: _string_ - *(required)* Hostname/ip:port of external host
* encapsulation: _string_ - Payload encapsulation protocol
    * Default: rtp
    * Allowed values: rtp, audiosocket
* transport: _string_ - Transport protocol
    * Default: udp
    * Allowed values: udp, tcp
* connection_type: _string_ - Connection type (client/server)
    * Default: client
    * Allowed values: client
* format: _string_ - *(required)* Format to encode audio in
* direction: _string_ - External media direction
    * Default: both
    * Allowed values: both
* data: _string_ - An arbitrary data field


### Body parameter
* variables: containers - The "variables" key in the body object holds variable key/value pairs to set on the channel on creation. Other keys in the body object are interpreted as query parameters. Ex. \{ "endpoint": "SIP/Alice", "variables": \{ "CALLERID(name)": "Alice" \} \}

### Error Responses
* 400 - Invalid parameters
* 409 - Channel is not in a Stasis application; Channel is already bridged
