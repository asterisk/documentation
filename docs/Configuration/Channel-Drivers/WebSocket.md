# WebSocket

## Background

The WebSocket Channel Driver (chan_websocket) is designed to ease the burden on ARI application developers with getting media in and out of Asterisk.  The ARI /channels/externalMedia REST endpoint already has two other channel drivers  available (AudioSocket and RTP) but they require binary packet manipulation (RTP especially) and both require that the app developer handle the timing of sending packets to asterisk.  chan_websocket requires neither.  The new driver will be available starting with Asterisk releases 23.0.0, 22.6.0, 21.11.0 and 20.16.0.

## Features

* Send and receive media using most Asterisk codecs.
* TLS is supported.
* Send arbitrary packet lengths to Asterisk.  The channel driver will break them up into appropriately sized frames (see notes below though).
* No need to time your own packet transmits.
* Silence is automatically generated when no packets have been received from the app.
* The channel driver can accept incoming websocket connections _from_ your app as well as make outgoing connections _to_ your app.
* Although the driver is targetted at ARI ExternalMedia users, it's not tied to ARI and can be used directly from the Dial dialplan app.
* The chan_websocket protocol is implemented using both binary and text WebSocket frames. BINARY frames are used for the actual media transfer and TEXT frames for control events and commands.

## Connection Types

### Outgoing Connections

Outgoing connections require you to pre-configure a websocket client in the `websocket_client.conf` config file (see details below).  Once done, you can reference the connection in a dial string.

```ini title="Dialplan Example"
[default]
exten = _x.,1,Dial(WebSocket/connection1/c(ulaw))
```

This would connect to your application's websocket server using the client named `connection1` and using the `ulaw` codec.  Right after your server accepts the connection, you'll get a websocket `MEDIA_START` event message with details that will allow you to correlate the incoming connection to the specific channel.

### Incoming Connections

Incoming connections must be made to the global Asterisk HTTP server using the `media` URI but you must still "Dial" the channel using the special `INCOMING` connection name.

```ini title="Dialplan Example"
[default]
exten = _x.,1,Dial(WebSocket/INCOMING/c(ulaw)n)
```

The websocket channel will be created immediately and the `MEDIA_WEBSOCKET_CONNECTION_ID` channel variable will be set to an ephemeral connection id which must be used in the URI your application will connect to Asterisk with.  For example `/media/32966726-4388-456b-a333-fdf5dbecc60d`.  When Asterisk accepts the connection, you'll see the same `MEDIA_START` message as above.

Whether inbound or outbound, the default behavior is to automatically answer the channel when the websocket has connected successfully.  If for some reason you want to answer the channel yourself, you can add the `n` parameter to the dialstring and make a REST `channels/<id>/answer` call or send the `ANSWER` command (mentioned below) over the media websocket.

## Media Transfer

Media sent from Asterisk to your application is simply streamed in BINARY websocket frames.  The message size will be whatever the internal Asterisk frame size is.  For ulaw/alaw for instance, Asterisk will send a 160 byte packet every 20ms.  This is the same as RTP except the messages will contain raw media with no RTP or other headers.  You could stream this directly to a file or other service.

Media sent _to_ Asterisk _from_ your app is a bit trickier because chances are that the media you send Asterisk will eventually need to go out to a caller in a format that is both properly framed and properly timed.  I.E. 160 byte blocks every 20 ms for a/ulaw.  Sending short, long or mistimed packets will surely result is poor audio quality.  To relieve your app of the burden of having to do the framing and timing, the channel driver will do it automatically for most codecs but there are a few exceptions and rules you have to follow.

/// warning
There currently is no way for chan_websocket to re-frame or re-time codecs whose data streams contain packet headers or can't be broken up on arbitrary byte/sample boundaries.  For this reason, codecs like opus and speex are handled in ["passthrough mode"](#passthrough-mode) where the application is responsible for correctly framing and timing the media it sends to Asterisk.
///

When the websocket channel is created, a `MEDIA_WEBSOCKET_OPTIMAL_FRAME_SIZE` channel variable will be set that tells you the amount of data Asterisk needs to create a good 20ms frame using the codec you specified in the dialstring.  This is also reported in the `MEDIA_START` event (See [Control Commands and Events](#control-commands-and-events) below. If you send a websocket message with a length that's exactly that size or some even multiple of that size, the channel driver will happily break that message up into the correctly sized frames and send one frame to the Asterisk core every 20ms with no leftover data.  If you send an oddly sized message though, the extra data that won't fill a frame will be dropped.  However...

If you need to send a file or a buffer received from an external source like an AI agent or a file, it's quite possible that the buffer size won't be an even multiple of the optimal size.  In this case, the app can send Asterisk a `START_MEDIA_BUFFERING` command before sending the media. This tells the channel driver to buffer the data received so it can make full frames even across multiple received BINARY messages.  That process will continue until the app sends Asterisk a `STOP_MEDIA_BUFFERING` command. When the channel driver receives that, it'll take whatever data is left in the buffer that couldn't make a full frame with, append silence to it to make up a full frame and send that to the core.

So why can't Asterisk just do that process all the time and dispense with the TEXT messages?  Well, let's say the app sends a message with an odd amount of data and the channel driver saves off the odd bit.  What happens if you don't send any data for a while?  If 20ms goes by and the channel driver doesn't get any more data what is it supposed to do with the leftover?  If it appends silence to make a full frame and sends it to the core, then the app sends more data after 30ms, the caller will hear a gap in the audio.  If the app does that a lot, it'll be a bad experience for the caller.

### Max Message Size and Flow Control

Chances are that your app will be sending data faster to Asterisk than Asterisk will be sending out to a caller so there are some rules you need to follow to prevent the channel driver from consuming excessive memory.  First...

/// warning
The maximum websocket message size the underlying websocket code can handle is 65500 bytes.  Attempting to send a message greater than that length will result in the websocket being closed and the call hungup!
///

The maximum number of frames the channel driver will keep in its queue waiting to be sent to the core is about 1000.  That's about 20 seconds of audio with a 20ms packetization rate.  When the queue gets to about 900 frames, the channel driver will send a `MEDIA_XOFF` event to the app.  The media the app sent just prior to receiving `MEDIA_XOFF` will be processed in its entirety even if the resulting frames cause the queue to reach 1000 but any data the app sends after that will probably be dropped.  When the queue backlog drops down below about 800 frames, the channel driver will send a `MEDIA_XON` event at which time it's safe to start sending data again.

## Control Commands and Events

Control messages, both events sent by Asterisk to your app and commands sent by your app to Asterisk are transferred as WebSocket TEXT frames.

/// warning
You must ensure that the control messages are sent as WebSocket TEXT frames.  Sending them as BINARY frames will cause them to be treated as media.

All commands are CASE-SENSITIVE.
///

In the original implementation of chan_websocket, commands and events were sent in a simple ASCII text format over WebSocket TEXT frames.  For example:

```
MEDIA_START connection_id:e226e283-c90a-4ea9-9e37-389000b9ef47 channel:WebSocket/connectionid format:ulaw optimal_frame_size:160
```

However, as additional capabilities were added to the driver this proved quite limiting.  Therefore with Asterisk versions 20.18.0, 22.8.0 and 23.2.0, JSON is the preferred format.  The plain text format remains the default but is deprecated and will be removed in the future.  However, some of the new features won't be available with plain text.  You can select which format to use globally in the new chan_websocket.conf file or on a call-by-call basis using the new [`f(<format>)`](#control-format) dialstring parameter.

* Plain text format: All command and events are sent as a simple string on a single line with any parameters appended.

    ```plain title="Example plain-text STOP_MEDIA_BUFFERING command"
    STOP_MEDIA_BUFFERING 61ea9311-d501-46e5-8825-017b342b39f2
    ```

    ```plain title="Example plain-text MEDIA_START event"
    MEDIA_START connection_id:e226e283-c90a-4ea9-9e37-389000b9ef47 channel:WebSocket/connectionid channel_id:pbx1-123456789.999 format:ulaw optimal_frame_size:160 ptime:20
    ```

* JSON format: Commands and events are sent as JSON objects.

    ```json title="Example STOP_MEDIA_BUFFERING command"
    {
        "command": "STOP_MEDIA_BUFFERING",
        "correlation_id": "61ea9311-d501-46e5-8825-017b342b39f2"
    }
    ```

    ```json title="Example MEDIA_START event"
    {
        "event": "MEDIA_START",
        "connection_id": "e226e283-c90a-4ea9-9e37-389000b9ef47",
        "channel": "WebSocket/connectionid",
        "channel_id": "pbx1-123456789.999",
        "format": "ulaw",
        "optimal_frame_size": 160,
        "ptime": 20,
        "channel_variables": {
            "SOME_CHANNEL_VARIABLE": "some value",
            "ANOTHER_CHANNEL_VARIABLE": "some other value"
        }
    }
    ```
    Unlike the plain text format, the JSON object can be pretty-printed across multiple lines however there must be only a single command object in each WebSocket TEXT frame.  Also note that the "channel_variables" only appear in the JSON formatted message because they can't be accurately handled in plain-text.

### Commands

#### `ANSWER`

This will cause the WebSocket channel to be answered.

Parameters: None

#### `HANGUP`

This will cause the WebSocket channel to be hung up and the websocket to be closed.

Parameters: None

#### `START_MEDIA_BUFFERING`[^1^](#fn1)

Indicates to the channel driver that the following media should be buffered to create properly sized and timed frames.

Parameters: None

#### `STOP_MEDIA_BUFFERING <correlation_id>`[^1^](#fn1)

Indicates to the channel driver that buffering is no longer needed and anything remaining in the buffer should have silence appended before sending to the Asterisk core.  When the last frame of this bulk transfer has been sent to the core, the app will receive a `MEDIA_BUFFERING_COMPLETED` notification.  If the optional correlation id was specified in this command, it'll be returned in the notification.  If you send multiple files in quick succession, the id can help you correlate the `MEDIA_BUFFERING_COMPLETED` notification to the `STOP_MEDIA_BUFFERING` command that triggered it.

Parameters:

* correlation_id: An optional id that will be returned in a `MEDIA_BUFFERING_COMPLETED` event.

#### `FLUSH_MEDIA`[^1^](#fn1)

Send this command to the channel driver if you've sent a large amount of media but want to discard any queued but not sent. Flushing the buffer automatically ends any bulk transfer in progress and also resets the paused state so there's no need to send `STOP_MEDIA_BUFFERING` or `CONTINUE_MEDIA` commands. No `MEDIA_BUFFERING_COMPLETED` notification will be sent in this case but you could send a `REPORT_QUEUE_DRAINED` command (see below) before sending the `MEDIA_FLUSH` to get a confirmation that the queue was indeed flushed.  This command could be useful if an automated agent detects the caller is speaking and wants to interrupt a prompt it already replied with.

Parameters: None

#### `PAUSE_MEDIA`[^1^](#fn1)

If you've sent a large amount of media but need to pause it playing to a caller while you decide if you need to flush it or not, you can send a `PAUSE_MEDIA` command.  The channel driver will then start playing silence to the caller but keep the data you've already sent in the queue.  You can still send media to the channel driver while it's paused; it'll just get queued behind whatever was already in the queue.

Parameters: None

#### `CONTINUE_MEDIA`[^1^](#fn1)

If you've previously paused the media, this will cause the channel driver to stop playing silence and resume playing media from the queue from the point you paused it.

Parameters: None

#### `MARK_MEDIA`[^1^](#fn1)

This will cause the channel driver to place a "mark" in the media stream you send to Asterisk.  When that
mark reaches the front of the frame queue, you'll receive a `MEDIA_MARK_PROCESSED` event back. This can help you
determine when media you've sent is actually going to be heard by the connected party.

Parameters:

* correlation_id: An optional id that will be returned in the `MEDIA_MARK_PROCESSED` event.

#### `GET_STATUS`

This will cause the channel driver to send back a `STATUS` message (described below).

Parameters: None

#### `REPORT_QUEUE_DRAINED`

This will cause the channel driver to send back a one-time `QUEUE_DRAINED` notification the next time it detects that there are no more frames to process in the queue.  Not applicable in passthrough mode.

Parameters: None

#### `SET_MEDIA_DIRECTION`[^1^](#fn1)

This will cause the channel driver to set the media direction from the perspective of the application. A direction of "in", "out", or "both" must be specified. If direction is "in", Asterisk will drop any media it receives from the application. If direction is "out", Asterisk will not send any media to the application. If direction is "both", media is sent and received normally. The following commands will generate an error if sent while media direction is "in":

* START_MEDIA_BUFFERING
* STOP_MEDIA_BUFFERING
* MARK_MEDIA
* PAUSE_MEDIA
* CONTINUE_MEDIA

Parameters:

* direction: The value to set the media direction to. Can be "both", "in", or "out". Mandatory.

#### Footnotes:

-  [](){ #fn1 }1: Not applicable in [passthrough mode](#passthrough-mode).


### Events

#### `MEDIA_START`

The channel driver will send this event when it connects to the app or the app connects to it.

Parameters:

* connection_id: A UUID that will be set on the `MEDIA_WEBSOCKET_CONNECTION_ID` channel variable.
* channel: The channel name.
* channel_id: The channel's unique id.
* format: The format set on the channel.
* optimal_frame_size: Sending media to Asterisk of this size, or a multiple of this size, ensures the channel driver can properly retime and reframe the media for the best caller experience.
* ptime: The packetization rate in milliseconds.
* channel_variables[^2^](#fn2): An object containing the variables currently set on the channel.

#### `DTMF_END`

The channel driver will send this event when DTMF_END frames are received from the core.

Parameters:

* channel_id: The channel unique id.
* digit: The DTMF digit pressed.

#### `MEDIA_XOFF`

The channel driver will send this event to the app when the frame queue length reaches the high water (XOFF) level.  The app should then pause sending media.  Any media sent after this has a high probability of being dropped.

Parameters:

* channel_id[^2^](#fn2): The channel unique id.

#### `MEDIA_XON`

The channel driver will send this event when the frame queue length drops below the low water (XON) level.  This indicates that it's safe for the app to start sending media again.

Parameters:

* channel_id[^2^](#fn2): The channel unique id.

#### `STATUS`

The channel driver will send this event in response to a `GET_STATUS` command.

Parameters:

* channel_id: The channel unique id.
* queue_length: The current number of frames waiting to be sent to the Asterisk core.
* xon_level: When the number of queued frames drops below this number, a `MEDIA_XON` event will be sent and new frames sent to Asterisk will no longer be dropped.
* xoff_level: When the number of queued frames rises above this number, a `MEDIA_XOFF` event will be sent and any further frames sent to Asterisk will be dropped.
* queue_full: This will be set to `true` if the xoff_level has been reached and Asterisk is dropping frames.
* bulk_media: A bulk media transfer is in progress.
* media_paused: The media has been paused with a PAUSE_MEDIA command.

#### `MEDIA_BUFFERING_COMPLETED [ <optional_id> ]`

The channel driver will send this event when bulk media has finished being framed, timed and sent to the Asterisk core.

Parameters:

* channel_id: The channel unique id.
* correlation_id: The correlation_id provides in the `STOP_MEDIA_BUFFERING` command, if any.

#### `MEDIA_MARK_PROCESSED`

Indicates that a previous mark queued with the `MARK_MEDIA` command has reached the front of the frame queue.

Parameters:

* channel_id[^2^](#fn2): The channel unique id.
* correlation_id: The correlation_id provides in the `MARK_MEDIA` command, if any.

#### `QUEUE_DRAINED`

The channel driver will send this when it's processed the last frame in the queue and you've asked to be notified with a `REPORT_QUEUE_DRAINED` command.  If no media is received within the next 20ms, a silence frame will be sent to the core.  This is a one-time notification.  You must send additional `REPORT_QUEUE_DRAINED` commands to get more notifications.

Parameters:

* channel_id[^2^](#fn2): The channel unique id.

#### Footnotes:

-  [](){ #fn2 }2: Only available with the JSON control message format.

## Configuration

### websocket_client.conf

All outbound connection configuration is done in the common [websocket_client.conf](/Latest_API/API_Documentation/Module_Configuration/res_websocket_client) file shared with ARI Outbound WebSockets.  That file has detailed information for configuring websocket client connections.  There are a few additional things to know though...

* You only need to configure a connection for outgoing websocket connections. Incoming connections (those with the special `INCOMING` connection id in the dial string) are handled by the internal http/websocket servers.

* chan_websocket can only use `per_call_config` connection types.  `persistent` websocket connections aren't supported for media.

* Never try to use the same websocket connection for both ARI and Media. "Bad things will happen"®

### chan_websocket.conf

Currently, [chan_websocket.conf](/Latest_API/API_Documentation/Module_Configuration/chan_websocket) is only used to set the global control message format (plain-text or json).  Other parameters may be added here in the future.

## Creating the Channel

### Using the [Dial() Dialplan App](/Latest_API/API_Documentation/Dialplan_Applications/Dial/)

The full dial string is as follows:

``` title="Dialstring Syntax"
Dial(WebSocket/<connection_id>/<dialstring_options>[,<timeout>[,<dial_options>]])
```

* **WebSocket**: The channel technology.
* **&lt;connection_id&gt;**: For outgoing connections, this is the name of the pre-defined client connection from websocket_client.conf.  For incoming connections, this must be the special `INCOMING` id.
* **&lt;dialstring_options&gt;**:
    * `c(<codec>)`: If not specified, the first codec from the caller's channel will be used.  Having said that, if your app is expecting a specific codec, you should specify it here or you may be getting audio in a format you don't expect.
    * `n`: Don't auto-answer the WebSocket channel upon successful connection. Set this if you wish to answer the channel yourself. You can then send an `ANSWER` TEXT message on the websocket when you're ready to answer the channel or make a `/channels/<channel_id>/answer` REST call.
    * `f(<format>)`:  [](){ #control-format } Per-call control message format override.
        * plain-text - All control messages and events for this call must be in the legacy plain text format.
        * json - All control messages and events for this call must be in the new JSON format.
    * `p`:  [](){ #passthrough-mode } Passthrough mode - In passthrough mode, the channel driver won't attempt to re-frame or re-time media coming in over the websocket from the remote app.  This can be used for any codec but MUST be used for codecs that use packet headers or whose data stream can't be broken up on arbitrary byte/sample boundaries. In this case, the remote app is fully responsible for correctly framing and timing media sent to Asterisk and the MEDIA text commands that could be sent over the websocket are disabled.  Currently, passthrough mode is automatically set for the opus, speex and g729 codecs.
    * `v(<uri_parameters>)`: Add parameters to the outbound URI. This option allows you to add additional parameters to the outbound URI. The format is: 'v(param1=value1,param2=value2...)'. You must ensure that no parameter name or value contains characters not valid in a URL.  The easiest way to do this is to use the URIENCODE() dialplan function to encode them.  Be aware though that each name and value must be encoded separately.  You can't simply encode the whole string.

* **&lt;timeout&gt;**:  The normal Dial app timeout.
* **&lt;dial_options&gt;**: The normal Dial app options.

Examples:

``` title="Dial() Examples"
; Make an outbound connection using the alaw codec but don't auto-answer the channel
; when the remote application connects.  Also use the "json" control message format.
Dial(WebSocket/connection1/c(alaw)nf(json))

; Make an outbound connection using the opus codec adding the "chan" and "exten"
; parameters to the URI.  Passthrough mode is automatically set for the opus codec.
Dial(WebSocket/connection1/c(opus)v(chan=${URIENCODE(${CHANNEL})},exten=$(URIENCODE(${EXTEN})}))

; Wait for an incoming websocket connection from a remote application and pass media
; using the slin16 codec.
Dial(WebSocket/INCOMING/c(slin16))

; Make an outbound connection using the ulaw codec and a media direction of "in".
Dial(WebSocket/connection1/c(ulaw)d(in))
```

### Using the [ARI `/channels`](/Latest_API/API_Documentation/Asterisk_REST_Interface/Channels_REST_API/) REST APIs

You can also create a WebSocket channel using the normal channel API calls and setting the `endpoint` parameter to the same dial string syntax described in the previous section.

Examples:

``` title="ARI /channel Examples"
POST http://server:8088/ari/channels?endpoint="WebSocket/connection1/c(alaw)v(myurivar=myvalue)"
POST http://server:8088/ari/channels/create?endpoint="WebSocket/INCOMING/c(ulaw)d(both)n"
```

The first example will create and dial the channel then connect to your app using the "media_connection1" websocket_client configuration. The channel will auto answer when the websocket connection is established.  The second example will create the channel but not dial or auto-answer it.  Instead the channel driver will wait for your app to connect to it.  You can then dial and answer it yourself when appropriate.  You can still omit the `n` to have incoming connections auto-answered.

### Using [ARI External Media](/Development/Reference-Information/Asterisk-Framework-and-API-Examples/External-Media-and-ARI) (`/channels/externalMedia`)

You can also create a channel using external media with a transport of `websocket` and an encapsulation of `none`.

A new `transport_data` parameter has been added to externalMedia in Asterisk versions 20.18.0, 22.8.0 and 23.2.0 which allows the caller to add dialstring options.

Example:

``` title="ARI External Media Examples"
POST http://server:8088/ari/channels/externalMedia?transport=websocket&encapsulation=none&external_host=media_connection1&format=ulaw&transport_data=f(json)v(myurivar=myvalue)d(out)
POST http://server:8088/ari/channels/externalMedia?transport=websocket&encapsulation=none&external_host=INCOMING&connection_type=server&format=ulaw&direction=out
```

The first example will create an outbound websocket connection to your app using the "media_connection1" websocket_client configuration with the "json" control message format and "myurivar=myvalue" URI parameters.  The second example will wait for an incoming connection from your app.  Both examples will automatically dial and answer the websocket channel.  The `transport_data` parameter can be used to set dialstring_options like the control message format or the `n` don't answer flag.  Use the normal channel creation APIs if you need even more control.

## Sample Code

Sample Python code demonstrating Asterisk's ARI and Media WebSocket capabilities is available in the GitHub [asterisk-websocket-examples](https://github.com/asterisk/asterisk-websocket-examples) repository.
