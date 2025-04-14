# Channel State

A channel's state reflects the current state of the path of communication between Asterisk and a device. What state a channel is in also affects what operations are allowed on it and/or how certain operations will affect a device.

While there are many states a channel can be in, the following are the most common:

* **Down** - a path of communication exists or used to exist between Asterisk and the device, but no media can flow between the two.
* **Ringing** - the device is ringing. Media may or may not be able to flow from Asterisk to the device.
* **Up** - the device has been answered. When in the up state, media can flow bidirectionally between Asterisk and the device.

!!! note More Channel States
    Certain channel technologies, such as DAHDI analog channels, may have additional channel states (such as "Pre-ring" or "Dialing Offhook"). When handling channel state, consult the [Channel data model](/Latest_API/API_Documentation/Asterisk_REST_Interface/Asterisk_REST_Data_Models/#channel) for all possible values.

[//]: # (end-note)

## Indicating Ringing

Asterisk can inform a device that it should start playing a ringing tone back to the caller using the [`POST /channels/{channel_id}/ring`](/Latest_API/API_Documentation/Asterisk_REST_Interface/Channels_REST_API/#ring) operation. Likewise, ringing can be stopped using the [`DELETE /channels/{channel_id}/ring`](/Latest_API/API_Documentation/Asterisk_REST_Interface/Channels_REST_API/#ringstop) operation. Note that indicating ringing typically does not actually transmit media from Asterisk to the device in question - Asterisk merely signals the device to ring. It is up to the device itself to actually play something back for the user.

## Answering a Channel

When a channel isn't answered, Asterisk has typically not yet informed the device how it will communicate with it. Answering a channel will cause Asterisk to complete the path of communication, such that media flows bi-directionally between the device and Asterisk.

You can answer a channel using the [`POST /channels/{channel_id}/answer`](/Latest_API/API_Documentation/Asterisk_REST_Interface/Channels_REST_API/#answer) operation.

## Hanging up a channel

You can hang up a channel using the [`DELETE /channels/{channel_id}`](/Latest_API/API_Documentation/Asterisk_REST_Interface/Channels_REST_API/#hangup) operation. When this occurs, the path of communication between Asterisk and the device is terminated, and the channel will leave the Stasis application. Your application will be notified of this via a [StasisEnd](/Latest_API/API_Documentation/Asterisk_REST_Interface/Asterisk_REST_Data_Models/#stasisend) event.

The same is true if the device initiates the hang up. In the same fashion, the path of communication between Asterisk and the device is terminated, the channel is hung up, and your application is informed that the channel is leaving your application via a [StasisEnd](/Latest_API/API_Documentation/Asterisk_REST_Interface/Asterisk_REST_Data_Models/#stasisend) event.

Generally, once a channel leaves your application, you won't receive any more events about the channel. There are times, however, when you may be subscribed to all events coming from a channel - regardless if that channel is in your application or not. In that case, a [ChannelDestroyed](/Latest_API/API_Documentation/Asterisk_REST_Interface/Asterisk_REST_Data_Models/#channeldestroyed) event will inform you when the channel is well and truly dead.

## Example: Manipulating Channel State

For this example, we're going to write an ARI application that will do the following:

1. Wait for a channel to enter its Stasis application.
2. When a channel enters its Stasis application, it will indicate ringing to the channel. If the channel wasn't already ringing, it will now!
3. After a few seconds, it will answer the channel.
4. Once the channel is answered, we'll start silence on the channel so that the user feels a comfortable whishing noise. Then, after a few more seconds, we'll hangup the channel.
5. If at any point in time the phone hangs up first, we'll gracefully handle that.

### Dialplan

For this example, we need to just drop the channel into Stasis, specifying our application:

extensions.conf  

```text title="extensions.conf" linenums="1"
exten => 1000,1,NoOp()
 same => n,Stasis(channel-state)
 same => n,Hangup() 

```

### Python

This example will use the [ari-py](https://github.com/asterisk/ari-py) library. The basic structure is very similar to the [channel-dump Python example](/Configuration/Interfaces/Asterisk-REST-Interface-ARI/Introduction-to-ARI-and-Channels) - see that example for more information on the basics of setting up an ARI connection using this library.

To start, once our ARI client has been set up, we will want to register handlers for three different events - `StasisStart`, `ChannelStateChange`, and `StasisEnd`.

1. The bulk of the work will be done in `StasisStart`, which is called when the channel enters our application. For the most part, this will involve setting up Python timers to initiate actions on the channel.
2. The `ChannelStateChange` handler will merely print out the channel state changes for us, which is informative as it will tell us when the channel is answered.
3. Finally, the `StasisEnd` event will clean up for us by cancelling any pending timers that we initiated. This will get called when the channel leaves our application - which will happen when the user hangs up the channel, or when we hang up the channel.

We can store the timers that we've set up for a channel using a dictionary of channel IDs to timer instances:

```python linenums="1"
channel_timers = {}

```

And we can register for our three events:

```python linenums="1"
client.on_channel_event('StasisStart', stasis_start_cb)
client.on_channel_event('ChannelStateChange', channel_state_change_cb)
client.on_channel_event('StasisEnd', stasis_end_cb)

```

The `StasisStart` event is the most interesting part.

1. First, we tell the channel to ring, and after two seconds, to answer the channel:

```python linenums="1"
channel.ring()
# Answer the channel after 2 seconds
timer = threading.Timer(2, answer_channel, [channel])
channel_timers[channel.id] = timer
timer.start()
```

If we didn't have that there, then the caller would probably just have dead space to listen to! Not very enjoyable. We store the timer in the `channel_timers` dictionary so that our `StasisEnd` event can cancel it for us if the user hangs up the phone.
2. Once we're in the `answer_channel` handler, we answer the channel and start silence on the channel. That (hopefully) gives them a slightly more ambient silence noise. Note that we'll go ahead and declare `answer_channel` as a nested function inside our `StasisStart` handler, `stasis_start_cb`:

```python linenums="1"
def stasis_start_cb(channel_obj, ev):
    """Handler for StasisStart event"""

def answer_channel(channel):
    """Callback that will actually answer the channel"""
    print("Answering channel %s" % channel.json.get('name'))
    channel.answer()
    channel.startSilence()
```
3. After we've answered the channel, we kick off another Python timer to hang up the channel in 4 seconds. When that timer fires, it will call `hangup_channel`. This does the final action on the channel by hanging it up. Again, we'll declare `hangup_channel` as a nested function inside our `StasisStart` handler:

```python linenums="1"
def hangup_channel(channel):
    """Callback that will actually hangup the channel"""
    print("Hanging up channel %s" % channel.json.get('name'))
    channel.hangup()
```
When we create a timer - such as when we started ringing on the channel - we stored it in our `channel_timers` dictionary. In our `StasisEnd` event handler, we'll want to cancel any pending timers. Otherwise, our timers may fire and try to perform an action on channel that has already left our Stasis application, which is a good way to get an HTTP error response code.

```python linenums="1"
def stasis_end_cb(channel, ev):
    """Handler for StasisEnd event"""
    print("Channel %s just left our application" % channel.json.get('name'))

    # Cancel any pending timers
    timer = channel_timers.get(channel.id)
    if timer:
        timer.cancel()
    del channel_timers[channel.id]
```

Finally, we want to print out the state of the channel in the `ChannelStateChanged` handler. This will tell us exactly when our channel has been answered:

```python linenums="1"
def channel_state_change_cb(channel, ev):
    """Handler for changes in a channel's state"""
    print("Channel %s is now: %s" % (channel.json.get('name'),
        channel.json.get('state')))
```

#### channel-state.py

The full source code for `channel-state.py` is shown below:

```python title="channel-state.py" linenums="1"
#!/usr/bin/env python

import ari
import logging
import threading

logging.basicConfig(level=logging.ERROR)

client = ari.connect('http://localhost:8088', 'asterisk', 'asterisk')

channel_timers = {}

def stasis_end_cb(channel, ev):
    """Handler for StasisEnd event"""
    print("Channel %s just left our application" % channel.json.get('name'))

    # Cancel any pending timers
    timer = channel_timers.get(channel.id)
    if timer:
        timer.cancel()
    del channel_timers[channel.id]

def stasis_start_cb(channel_obj, ev):
 """Handler for StasisStart event"""

def answer_channel(channel):
    """Callback that will actually answer the channel"""
    print("Answering channel %s" % channel.json.get('name'))
    channel.answer()
    channel.startSilence()

    # Hang up the channel in 4 seconds
    timer = threading.Timer(4, hangup_channel, [channel])
    channel_timers[channel.id] = timer
    timer.start()

def hangup_channel(channel):
    """Callback that will actually hangup the channel"""

    print("Hanging up channel %s" % channel.json.get('name'))
    channel.hangup()

    channel = channel_obj.get('channel')
    print("Channel %s has entered the application" % channel.json.get('name'))

    channel.ring()
    # Answer the channel after 2 seconds
    timer = threading.Timer(2, answer_channel, [channel])
    channel_timers[channel.id] = timer
    timer.start()

def channel_state_change_cb(channel, ev):
    """Handler for changes in a channel's state"""
    print("Channel %s is now: %s" % (channel.json.get('name'),
                                     channel.json.get('state')))

    client.on_channel_event('StasisStart', stasis_start_cb)
    client.on_channel_event('ChannelStateChange', channel_state_change_cb)
    client.on_channel_event('StasisEnd', stasis_end_cb)

    client.run(apps='channel-state')

```

#### channel-state.py in action

Here, we see the output from the `channel-state.py` script when a PJSIP channel for endpoint 'alice' enters into the application:

```
Channel PJSIP/alice-00000001 has entered the application
Answering channel PJSIP/alice-00000001
Channel PJSIP/alice-00000001 is now: Up
Hanging up channel PJSIP/alice-00000001
Channel PJSIP/alice-00000001 just left our application

```

### JavaScript (Node.js)

This example will use the [ari-client](https://github.com/asterisk/node-ari-client) library.

To start, once our ARI client has been set up, we will want to register callbakcs for three different events - `StasisStart`, `ChannelStateChange`, and `StasisEnd`.

1. The bulk of the work will be done in `StasisStart`, which is called when the channel enters our application. For the most part, this will involve setting up JavaScript timeouts to initiate actions on the channel.
2. The `ChannelStateChange` handler will merely print out the channel state changes for us, which is informative as it will tell us when the channel is answered.
3. Finally, the `StasisEnd` event will clean up for us by cancelling any pending timeouts that we initiated. This will get called when the channel leaves our application - which will happen when the user hangs up the channel, or when we hang up the channel.

We can store the timeouts that we've set up for a channel using an object of channel IDs to timer instances:

```javascript linenums="1"
timers = {}
```

And we can register for our three events:

```javascript linenums="1"
client.on_channel_event('StasisStart', stasis_start_cb)
client.on_channel_event('ChannelStateChange', channel_state_change_cb)
client.on_channel_event('StasisEnd', stasis_end_cb)
```

The `StasisStart` event is the most interesting part.

1. First, we tell the channel to ring, and after two seconds, to answer the channel:

```javascript linenums="1"
channel.ring(function(err) {
	if (err) {
		throw err;
	}
});
// answer the channel after 2 seconds
var timer = setTimeout(answer, 2000);
timers[channel.id] = timer;
```

If we didn't have that there, then the caller would probably just have dead space to listen to! Not very enjoyable. We store the timer in the `timers` object so that our `StasisEnd` event can cancel it for us if the user hangs up the phone.
2. Once we're in the `answer` callback, we answer the channel and start silence on the channel. That (hopefully) gives them a slightly more ambient silence noise:

```javascript linenums="1"
// callback that will answer the channel
function answer() {
	console.log(util.format('Answering channel %s', channel.name));
	channel.answer(function(err) {
		if (err) {
			throw err;
		}
	});
	channel.startSilence(function(err) {
		if (err) {
			throw err;
		}
	});
	// hang up the channel in 4 seconds
	var timer = setTimeout(hangup, 4000);
	timers[channel.id] = timer;
}

```
3. After we've answered the channel, we kick off another timer to hang up the channel in 4 seconds. When that timer fires, it will call `the hangup callback`. This does the final action on the channel by hanging it up:

```javascript linenums="1"
// callback that will hangup the channel
function hangup() {
	console.log(util.format('Hanging up channel %s', channel.name));
	channel.hangup(function(err) {
		if (err) {
			throw err;
		}
	});
}
```
When we create a timer - such as when we started ringing on the channel - we stored it in our `timers` object. In our `StasisEnd` event handler, we'll want to cancel any pending timers. Otherwise, our timers may fire and try to perform an action on channel that has already left our Stasis application, which is a good way to get an HTTP error response code.

```javascript linenums="1"
// handler for StasisEnd event
function stasisEnd(event, channel) {
	console.log(util.format(
		'Channel %s just left our application', channel.name));
	var timer = timers[channel.id];
	if (timer) {
		clearTimeout(timer);
		delete timers[channel.id];
	}
}

```

Finally, we want to print out the state of the channel in the `ChannelStateChanged` callback. This will tell us exactly when our channel has been answered:

```javascript linenums="1"
// handler for ChannelStateChange event
function channelStateChange(event, channel) {
	console.log(util.format(
		'Channel %s is now: %s', channel.name, channel.state));
}

```

#### channel-state.js

The full source code for `channel-state.js` is shown below:

```javascript title="channel-state.js" linenums="1"
/*jshint node: true */
'use strict';

var ari = require('ari-client');
var util = require('util');

var timers = {};
ari.connect('http://localhost:8088', 'asterisk', 'asterisk', clientLoaded);

// handler for client being loaded
function clientLoaded (err, client) {
	if (err) {
		throw err;
	}

	// handler for StasisStart event
	function stasisStart(event, channel) {
		console.log(util.format(
			'Channel %s has entered the application', channel.name));

		channel.ring(function(err) {
			if (err) {
				throw err;
			}
		});
		// answer the channel after 2 seconds
		var timer = setTimeout(answer, 2000);
		timers[channel.id] = timer;

		// callback that will answer the channel
		function answer() {
			console.log(util.format('Answering channel %s', channel.name));
			channel.answer(function(err) {
				if (err) {
					throw err;
				}
			});
			channel.startSilence(function(err) {
				if (err) {
					throw err;
				}
			});
			// hang up the channel in 4 seconds
			var timer = setTimeout(hangup, 4000);
			timers[channel.id] = timer;
		}

		// callback that will hangup the channel
		function hangup() {
			console.log(util.format('Hanging up channel %s', channel.name));
			channel.hangup(function(err) {
				if (err) {
					throw err;
				}
			});
		}
	}

	// handler for StasisEnd event
	function stasisEnd(event, channel) {
		console.log(util.format(
			'Channel %s just left our application', channel.name));
		var timer = timers[channel.id];
		if (timer) {
			clearTimeout(timer);
			delete timers[channel.id];
		}
	}

	// handler for ChannelStateChange event
	function channelStateChange(event, channel) {
		console.log(util.format(
			'Channel %s is now: %s', channel.name, channel.state));
	}

	client.on('StasisStart', stasisStart);
	client.on('StasisEnd', stasisEnd);
	client.on('ChannelStateChange', channelStateChange);

	client.start('channel-state');
}

```

#### channel-state.js in action

Here, we see the output from the `channel-state.js` script when a PJSIP channel for endpoint 'alice' enters into the application:

```
Channel PJSIP/alice-00000001 has entered the application
Answering channel PJSIP/alice-00000001
Channel PJSIP/alice-00000001 is now: Up
Hanging up channel PJSIP/alice-00000001
Channel PJSIP/alice-00000001 just left our application

```
