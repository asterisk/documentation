# WebSocket

## Background

The WebSocket Channel Driver (chan_websocket) is designed to ease the burden on ARI application developers with getting media in and out of Asterisk.  The ARI /channels/externalMedia REST endpoint already has two other channel drivers  available (AudioSocket and RTP) but they require binary packet manipulation (RTP especially) and both require that the app developer handle the timing of sending packets to asterisk.  chan_websocket requires neither.

## Features

* Send and receive media using most Asterisk codecs.
* TLS is supported.
* Send arbitrary packet lengths to Asterisk.  The channel driver will break them up into appropriately sized frames (see notes below though).
* No need to time your own packet transmits.
* Silence is automatically generated when no packets have been received from the app.
* The channel driver can accept incoming websocket connections _from_ your app as well as make outgoing connections _to_ your app.
* Although the driver is targetted at ARI ExternalMedia users, it's not tied to ARI and can be used directly from the Dial dialplan app.

## Connection Types

### Outgoing Connections

Outgoing connections require you to pre-configure a websocket client in the `websocket_client.conf` config file (see details below).  Once done, you can reference the connection in a dial string.

```ini title="Dialplan Example"
[default]
exten = _x.,1,Dial(WebSocket/connection1/c(ulaw))
```

This would connect to your application's websocket server using the client named `connection1` and using the `ulaw` codec.  Right after your server accepts the connection, you'll get a TEXT websocket message `MEDIA_START connection_id:<connection_id> channel:<channel_name> optimal_frame_size:<optimal_frame_size>`. This will allow you to correlate the incoming connection to the specific channel.

### Incoming Connections

Incoming connections must be made to the global Asterisk HTTP server using the `media` URI but you must still "Dial" the channel using the special `INCOMING` connection name.

```ini title="Dialplan Example"
[default]
exten = _x.,1,Dial(WebSocket/INCOMING/c(ulaw)n)
```

The websocket channel will be created immediately and the `MEDIA_WEBSOCKET_CONNECTION_ID` channel variable will be set to an ephemeral connection id which must be used in the URI your application will connect to Asterisk with.  For example `/media/32966726-4388-456b-a333-fdf5dbecc60d`.  When Asterisk accepts the connection, you'll see the same `MEDIA_START` message as above.

Whether inbound or outbound, the default behavior is to automatically answer the channel when the websocket has connected successfully.  If for some reason you want to answer the channel yourself, you can add the `n` parameter to the dialstring and make a REST `channels/<id>/answer` call or send the `ANSWER` command (mentioned below) over the media websocket.

## Protocol

### Media Transfer

Media sent from Asterisk to your application is simply streamed in BINARY websocket messages.  The message size will be whatever the internal Asterisk frame size is.  For ulaw/alaw for instance, Asterisk will send a 160 byte packet every 20ms.  This is the same as RTP except the messages will contain raw media with no RTP or other headers.  You could stream this directly to a file or other service.

Media sent _to_ Asterisk _from_ your app is a bit trickier because chances are that the media you send Asterisk will eventually need to go out to a caller in a format that is both properly framed and properly timed.  I.E. 160 byte blocks every 20 ms for a/ulaw.  Sending short, long or mistimed packets will surely result is poor audio quality.  To relieve your app of the burden of having to do the framing and timing, the channel driver will do it automatically but there are a few rules you have to follow.

When the websocket channel is created, a `MEDIA_WEBSOCKET_OPTIMAL_FRAME_SIZE` channel variable will be set that tells you the amount of data Asterisk needs to create a good 20ms frame using the codec you specified in the dialstring.  This is also reported in the `MEDIA_START` TEXT message. If you send a websocket message with a length that's exactly that size or some even multiple of that size, the channel driver will happily break that message up into the correctly sized frames and send one frame to the Asterisk core every 20ms with no leftover data.  If you send an oddly sized message though, the extra data that won't fill a frame will be dropped.  However...

If you need to send a file or a buffer received from an external source like an AI agent or a file, it's quite possible that the buffer size won't be an even multiple of the optimal size.  In this case, the app can send Asterisk a `START_MEDIA_BUFFERING` TEXT websocket message before sending the media. This tells the channel driver to buffer the data received so it can make full frames even across multiple received BINARY messages.  That process will continue until the app sends Asterisk a `STOP_MEDIA_BUFFERING` TEXT message. When the channel driver receives that, it'll take whatever data is left in the buffer that couldn't make a full frame with, append silence to it to make up a full frame and send that to the core.

So why can't Asterisk just do that process all the time and dispense with the TEXT messages?  Well, let's say the app sends a message with an odd amount of data and the channel driver saves off the odd bit.  What happens if you don't send any data for a while?  If 20ms goes by and the channel driver doesn't get any more data what is it supposed to do with the leftover?  If it appends silence to make a full frame and sends it to the core, then the app sends more data after 30ms, the caller will hear a gap in the audio.  If the app does that a lot, it'll be a bad experience for ther caller.

### Max Message Size and Flow Control

Chances are that your app will be sending data faster to Asterisk than Asterisk will be sending out to a caller so there are some rules you need to follow to prevent the channel driver from consuming excessive memory.  First...

/// warning
The maximum websocket message size the underlying websocket code can handle is 65500 bytes.  Attempting to send a message greater than that length will result in the websocket being closed and the call hungup!
///

* The maximum number of frames the channel driver will keep in its queue waiting to be sent to the core is about 1000.  That's about 20 seconds of audio with a 20ms packetization rate.  When the queue gets to about 900 frames, the channel driver will send a `MEDIA_XOFF` TEXT message to the app.  The media the app sent just prior to receiving `MEDIA_XOFF` will be processed in its entirety even if the resulting frames cause the queue to reach 1000 but any data the app sends after that will probably be dropped.  When the queue backlog drops down below about 800 frames, the channel driver will send a `MEDIA_XON` TEXT message at which time it's safe to start sending data again.

See the next section for more commands the app can send.

### Control Messages

/// warning
You must ensure that the control messages are sent as TEXT messages.  Sending them as BINARY messages will cause them to be treated as media.

All commands are case-sensitive.
///

Some of the control TEXT messages you can send the driver have already been mentioned but here's the full list:

#### Commands

/// define
`ANSWER`

- This will cause the WebSocket channel to be answered.

`HANGUP`

- This will cause the WebSocket channel to be hung up and the websocket to be closed.

`START_MEDIA_BUFFERING`

- Indicates to the channel driver that the following media should be buffered to create properly sized and timed frames.

`STOP_MEDIA_BUFFERING <optional_id>`

- Indicates to the channel driver that buffering is no longer needed and anything remaining in the buffer should have silence appended before sending to the Asterisk core.  When the last frame of this bulk transfer has been sent to the core, the app will receive a `MEDIA_BUFFERING_COMPLETED` notification.  If the optional id was specified in this command, it'll be returned in the notification.  If you send multiple files in quick succession, the id can help you correlate the `MEDIA_BUFFERING_COMPLETED` notification to the `STOP_MEDIA_BUFFERING` command that triggered it.

`FLUSH_MEDIA`

- Send this command to the channel driver if you've sent a large amount of media but want to discard any queued but not sent. Flushing the buffer automatically ends any bulk transfer in progress and also resets the paused state so there's no need to send `STOP_MEDIA_BUFFERING` or `CONTINUE_MEDIA` commands. No `MEDIA_BUFFERING_COMPLETED` notification will be sent in this case but you could send a `REPORT_QUEUE_DRAINED` command (see below) before sending the `MEDIA_FLUSH` to get a confirmation that the queue was indeed flushed.  This command could be useful if an automated agent detects the caller is speaking and wants to interrupt a prompt it already replied with.

`PAUSE_MEDIA`

- If you've sent a large amount of media but need to pause it playing to a caller while you decide if you need to flush it or not, you can send a `PAUSE_MEDIA` command.  The channel driver will then start playing silence to the caller but keep the data you've already sent in the queue.  You can still send media to the channel driver while it's paused; it'll just get queued behind whatever was already in the queue.

`CONTINUE_MEDIA`

- If you've previously paused the media, this will cause the channel driver to stop playing silence and resume playing media from the queue from the point you paused it.

`GET_STATUS`

- This will cause the channel driver to send back a `STATUS` message (described below).

`REPORT_QUEUE_DRAINED`

- This will cause the channel driver to send back a one-time `QUEUE_DRAINED` notification the next time it detects that there are no more frames to process in the queue.

///

#### Notifications

/// define

`MEDIA_START`

- The channel driver will send this notification when it connects to the app or the app connects to it.<br>
Example: `MEDIA_START connection_id:e226e283-c90a-4ea9-9e37-389000b9ef47 channel:WebSocket/connectionid format:ulaw optimal_frame_size:160`<br>
Not only does this notification contain the optimal frame size and format, it also contains the channel name and connection id which you can use to correlate incoming connections from the driver to channels you've created.

`MEDIA_XOFF`

- The channel driver will send this notification to the app when the frame queue length reaches the high water (XOFF) level.  The app should then pause sending media.  Any media sent after this has a high probability of being dropped.

`MEDIA_XON`

- The channel driver will send this notification when the frame queue length drops below the low water (XON) level.  This indicates that it's safe for the app to start sending media again.

`STATUS`

- The channel driver will send this notification in response to a `GET_STATUS` command.<br>Example: `STATUS queue_length:43 xon_level:800 xoff_level:900 queue_full:false bulk_media:true media_paused:false`

`MEDIA_BUFFERING_COMPLETED [ <optional_id> ]`

- The channel driver will send this mesage when bulk media has finished being framed, timed and sent to the Asterisk core. If an optional id was supplied on the `STOP_MEDIA_BUFFERING` command, it will be returned in this message.

`QUEUE_DRAINED`

- The channel driver will send this when it's processed the last frame in the queue and you've asked to be notified with a `REPORT_QUEUE_DRAINED` command.  If no media is received within the next 20ms, a silence frame will be sent to the core.  This is a one-time notification.  You must send additional `REPORT_QUEUE_DRAINED` commands to get more notifications.

///

## Configuration

All configuration is done in the common [websocket_client.conf](/Latest_API/API_Documentation/Module_Configuration/res_websocket_client) file shared with ARI Outbound WebSockets.  That file has detailed information for configuring websocket client connections.  There are a few additional things to know though...

* You only need to configure a connection for outgoing websocket connections. Incoming connections (those with the special `INCOMING` connection id in the dial string) are handled by the internal http/websocket servers.

* chan_websocket can only use `per_call_config` connection types.  `persistent` websocket connections aren't supported for media.

* Never try to use the same websocket connection for both ARI and Media. "Bad things will happen"®

## Creating the Channel

### Using the [Dial() Dialplan App](/Latest_API/API_Documentation/Dialplan_Applications/Dial/)

The full dial string is as follows:

``` title="Dialstring Syntax"
Dial(WebSocket/<connection_id>/<options>[,<timeout>[,<dial_options>]])
```

* **WebSocket**: The channel technology.
* **&lt;connection_id&gt;**: For outgoing connections, this is the name of the pre-defined client connection from websocket_client.conf.  For incoming connections, this must be the special `INCOMING` id.
* **&lt;options&gt;**:
    * `c(<codec>)`: If not specified, the first codec from the caller's channel will be used.  Having said that, if your app is expecting a specific codec, you should specify it here or you may be getting audio in a format you don't expect.
    * `n`: Don't auto-answer the WebSocket channel upon successful connection. Set this if you wish to answer the channel yourself. You can then send an `ANSWER` TEXT message on the websocket when you're ready to answer the channel or make a `/channels/<channel_id>/answer` REST call.

Examples:

``` title="Dial() Examples"
Dial(WebSocket/connection1/c(alaw)n)
Dial(WebSocket/INCOMING/c(slin16))
```

### Using the [ARI `/channels`](/Latest_API/API_Documentation/Asterisk_REST_Interface/Channels_REST_API/) REST APIs

You can also create a WebSocket channel using the normal channel API calls and setting the `endpoint` parameter to the same dial string syntax described in the previous section.

Examples:

``` title="ARI /channel Examples"
POST http://server:8088/ari/channels?endpoint="WebSocket/connection1/c(alaw)"
POST http://server:8088/ari/channels/create?endpoint="WebSocket/INCOMING/c(ulaw)n"
```

The first example will create and dial the channel then connect to your app using the "media_connection1" websocket_client configuration. The channel will auto answer when the websocket connection is established.  The second example will create the channel but not dial or auto-answer it.  Instead the channel driver will wait for your app to connect to it.  You can then dial and answer it yourself when appropriate.  You can still omit the `n` to have incoming connections auto-answered.

### Using [ARI External Media](/Development/Reference-Information/Asterisk-Framework-and-API-Examples/External-Media-and-ARI) (`/channels/externalMedia`)

You can also create a channel using external media with a transport of `websocket` and an encapsulation of `none`.

Example:

``` title="ARI External Media Examples"
POST http://server:8088/ari/channels/externalMedia?transport=websocket&encapsulation=none&external_host=media_connection1&format=ulaw
POST http://server:8088/ari/channels/externalMedia?transport=websocket&encapsulation=none&external_host=INCOMING&connection_type=server&format=ulaw
```

The first example will create an outbound websocket connection to your app using the "media_connection1" websocket_client configuration.  The second example will wait for an incoming connection from your app.  Both examples will automatically dial and answer the websocket channel.  There's no option to suppress either.  Use the normal channel creation APIs if you need to handle them yourself.

## Sample Code

Sample Python code demonstrating Asterisk's ARI and Media WebSocket capabilities is available in the GitHub [asterisk-websocket-examples](https://github.com/asterisk/asterisk-websocket-examples) repository.
