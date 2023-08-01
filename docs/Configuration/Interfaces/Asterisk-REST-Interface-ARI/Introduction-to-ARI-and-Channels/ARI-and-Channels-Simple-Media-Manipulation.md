---
title: ARI and Channels: Simple Media Manipulation
pageid: 29395606
---

60%Simple media playback
=====================

Almost all media is played to a channel using the `POST /channels/{channel_id}/play` operation. This will do the following:

1. Create a new [`Playback`](/Asterisk+12+REST+Data+Models#Asterisk12RESTDataModels-Playback) object for the channel. If a media operation is currently in progress on the channel, the new `Playback` object will be queued up for the channel.
2. The `media` URI passed to the `play` operation will be inspected, and Asterisk will attempt to find the media requested. Currently, the following media schemes are supported:



| URI Scheme | Description |
| --- | --- |
| `sound` | A sound file located on the Asterisk system. You can use the `[/sounds](/Asterisk+12+Sounds+REST+API)` resource to query for available sounds on the system. You can also use specify a media file which is consumed via HTTP (e.g sound:http://foo.com/sound.wav) |
| `recording` | A [`StoredRecording`](/Asterisk+12+REST+Data+Models#Asterisk12RESTDataModels-StoredRecording) stored on the Asterisk system. You can use the [`/recordings/stored`](/Asterisk+12+Recordings+REST+API) resource to query for available `StoredRecording`s on the system. |
| `number` | Play back the specified number. This uses the same mechanism as Asterisk's `[Say](/SayDigits-+SayNumber-+SayAlpha-+and+SayPhonetic+Applications?src=search)` family of applications. |
| `digits` | Play back the specified digits. This uses the same mechanism as Asterisk's `[Say](/SayDigits-+SayNumber-+SayAlpha-+and+SayPhonetic+Applications?src=search)` family of applications. |
| `characters` | Play back the specified characters. This uses the same mechanism as Asterisk's `[Say](/SayDigits-+SayNumber-+SayAlpha-+and+SayPhonetic+Applications?src=search)` family of applications. |
| `tone` | Play a particular tone sequence until stopped. This can be used to play locale specific ringing, stutter, busy, congestion, or other tones to a device. |
3. Once the media operation is started or enqueued, the `Playback` object will be returned to the caller in the `HTTP` response to the request. The caller can use that playback object to manipulate the media operation.



On This Page




!!! tip Specify your own ID!** It is **highly
    recommended that the `POST /channels/{channel_id}/play/{playback_id}` operation be used instead of the `POST /channels/{channel_id}/play` variant. Asterisk lives in an asynchronous world - which is the same world you and I live in. Sometimes, if things happen *very* quickly, you may get notifications over the WebSocket about things you have started before the HTTP response completes!

    When you specify your own ID, you have the ability to tie information coming from events back to whatever operation you initiated - if you so choose to. If you use the non-ID providing variant, Asterisk will happily generate a UUID for your `Playback` object - but then it is up to you to deal with whatever information comes back from the WebSocket.

      
[//]: # (end-tip)



Early Media
-----------

Generally, before a channel has been answered and transitioned to the Up state, media cannot pass between Asterisk and a device. For example, if Asterisk is placing an outbound call to a device, the device may be ringing but no one has picked up a handset yet! In such circumstances, media cannot be successfully played to the ringing device - after all, who could listen to it?

However, with inbound calls, Asterisk is the entity that decides when the path of communication between itself and the device is answered - not the user on the other end. This can be useful when answering the channel may trigger billing times or other mechanisms that we don't want to fire yet. This is called "early media". For the channel technologies that support this, ARI and Asterisk will automatically handle sending the correct indications to the ringing phone before sending it media. The same `play` operation can be used both for "regular" playback of media, as well as for "early media" scenarios.

Example: Playing back tones
===========================

This example ARI application will do the following:

1. When a channel enters into the Stasis application, it will start a playback of a French ringing tone.
2. After 8 seconds, the channel will be answered.
3. After 1 second, the channel will be rudely hung up on - we didn't want to talk to them anyway!

Dialplan
--------

For this example, we need to just drop the channel into Stasis, specifying our application:




---

  
extensions.conf  

```
truetextexten => 1000,1,NoOp()
 same => n,Stasis(channel-tones)
 same => n,Hangup() 

```

Python
------

This example will use a very similar structure as the [`channel-state.py`](https://wiki.asterisk.org/wiki/display/%7Emjordan/Draft%3A+ARI+Channels%3A+Channel+State#Draft:ARIChannels:ChannelState-channel-state.py) example. Instead of performing a `ring` operation in our `StasisStart` handler, we'll instead initiate a playback using the `playWithId` operation on the channel. Note that our URI uses the `tone` scheme, which supports an optional `tonezone` parameter. We specify our `tonezone` as `fr`, so that we get an elegant French ringing tone. Much like the `channel-state.py` example, we then use a Python timer to schedule a callback that will answer the channel. Since we care about both the `channel` and the `playback` initiated on it, we pass both parameters as `*args` parameters to the callback function.

```
truepy46 playback_id = str(uuid.uuid4())
 playback = channel.playWithId(playbackId=playback_id,
 media='tone:ring;tonezone=fr')
 timer = threading.Timer(8, answer_channel, [channel, playback])

```

Since this is a media operation and not *technically* a ringing indication, when we `answer` the channel, the tone playback will not stop! To stop playing back our French ringing tone, we issue a `stop` operation on the `playback` object. This actually maps to a [`DELETE /playbacks/{playback_id}`](/Asterisk+12+Playbacks+REST+API#Asterisk12PlaybacksRESTAPI-stop) operation.

```
truepy26 def answer_channel(channel, playback):
 """Callback that will actually answer the channel"""

 print "Answering channel %s" % channel.json.get('name')
 playback.stop()
 channel.answer()

```

Once answered, we'll schedule another Python timer that will do the actual hanging up of the channel.

### channel-tones.py

The full source code for `channel-tones.py` is shown below:




---

  
channel-tones.py  

```
truepy#!/usr/bin/env python

import ari
import logging
import threading
import uuid

logging.basicConfig(level=logging.ERROR)

client = ari.connect('http://localhost:8088', 'asterisk', 'asterisk')

channel_timers = {}

def stasis_end_cb(channel, ev):
 """Handler for StasisEnd event"""

 print "Channel %s just left our application" % channel.json.get('name')
 timer = channel_timers.get(channel.id)
 if timer:
 timer.cancel()
 del channel_timers[channel.id]

def stasis_start_cb(channel_obj, ev):
 """Handler for StasisStart event"""

 def answer_channel(channel, playback):
 """Callback that will actually answer the channel"""

 print "Answering channel %s" % channel.json.get('name')
 playback.stop()
 channel.answer()

 timer = threading.Timer(1, hangup_channel, [channel])
 channel_timers[channel.id] = timer
 timer.start()

 def hangup_channel(channel):
 """Callback that will actually hangup the channel"""

 print "Hanging up channel %s" % channel.json.get('name')
 channel.hangup()

 channel = channel_obj.get('channel')
 print "Channel %s has entered the application" % channel.json.get('name')

 playback_id = str(uuid.uuid4())
 playback = channel.playWithId(playbackId=playback_id,
 media='tone:ring;tonezone=fr')
 timer = threading.Timer(8, answer_channel, [channel, playback])
 channel_timers[channel.id] = timer
 timer.start()


client.on_channel_event('StasisStart', stasis_start_cb)
client.on_channel_event('StasisEnd', stasis_end_cb)


client.run(apps='channel-tones')

```

### channel-tones.py in action

The following shows the output of the `channel-tones.js` script when a `PJSIP` channel for `alice` enters the application:

```
Channel PJSIP/alice-00000000 has entered the application
Answering channel PJSIP/alice-00000000
Hanging up channel PJSIP/alice-00000000
Channel PJSIP/alice-00000000 just left our application

```

JavaScript (Node.js)
--------------------

This example will use a very similar structure as the `[channel-state.js](https://wiki.asterisk.org/wiki/display/%7Emjordan/Draft%3A+ARI+Channels%3A+Channel+State#Draft:ARIChannels:ChannelState-channel-state.js)` example. Instead of performing a `ring` operation in our `StasisStart` handler, we'll instead initiate a playback using the `play` operation on the channel. Note that our URI uses the `tone` scheme, which supports an optional `tonezone` parameter. We specify our `tonezone` as `fr`, so that we get an elegant French ringing tone. Much like the `channel-state.js` example, we then use a JavaScript timeout to schedule a callback that will answer the channel.

```
truejs21var playback = client.Playback();
channel.play({media: 'tone:ring;tonezone=fr'},
 playback, function(err, newPlayback) {
 if (err) {
 throw err;
 }
});
// answer the channel after 8 seconds
var timer = setTimeout(answer, 8000);
timers[channel.id] = timer;

```

Since this is a media operation and not *technically* a ringing indication, when we `answer` the channel, the tone playback will not stop! To stop playing back our French ringing tone, we issue a `stop` operation on the `playback` object. This actually maps to a [`DELETE /playbacks/{playback_id}`](/Asterisk+12+Playbacks+REST+API#Asterisk12PlaybacksRESTAPI-stop) operation. Notice that we use the fact that the answer callback closes on the original channel and playback variables to access them from the callback.

```
truejs33function answer() {
 console.log(util.format('Answering channel %s', channel.name));
 playback.stop(function(err) {
 if (err) {
 throw err;
 }
 });
 channel.answer(function(err) {
 if (err) {
 throw err;
 }
 });
 // hang up the channel in 1 seconds
 var timer = setTimeout(hangup, 1000);
 timers[channel.id] = timer;
}

```

Once answered, we'll schedule another timeout that will do the actual hanging up of the channel.

### channel-tones.js




The full source code for `channel-tones.js` is shown below:

```javascript title="channel-tones.js" linenums="1"
truejs/*jshint node: true */
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

 var playback = client.Playback();
 channel.play({media: 'tone:ring;tonezone=fr'},
 playback, function(err, newPlayback) {
 if (err) {
 throw err;
 }
 });
 // answer the channel after 8 seconds
 var timer = setTimeout(answer, 8000);
 timers[channel.id] = timer;

 // callback that will answer the channel
 function answer() {
 console.log(util.format('Answering channel %s', channel.name));
 playback.stop(function(err) {
 if (err) {
 throw err;
 }
 });
 channel.answer(function(err) {
 if (err) {
 throw err;
 }
 });
 // hang up the channel in 1 seconds
 var timer = setTimeout(hangup, 1000);
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

 client.on('StasisStart', stasisStart);
 client.on('StasisEnd', stasisEnd);

 client.start('channel-tones');
} 

```

### channel-tones.js in action

The following shows the output of the `channel-tones.js` script when a `PJSIP` channel for `alice` enters the application:

`Channel PJSIP/alice-00000000 has entered the application
Answering channel PJSIP/alice-00000000
Hanging up channel PJSIP/alice-00000000
Channel PJSIP/alice-00000000 just left our application`Example: Playing back a sound file
==================================

This example ARI application will do the following:

1. When a channel enters the Stasis application, initiate a playback of howler monkeys on the channel. Fly my pretties, FLY!
2. If the user has not hung up their phone in panic, it will hang up the channel when the howler monkeys return victorious - or rather, when ARI notifies the application that the playback has finished via the [`PlaybackFinished`](/Asterisk+12+REST+Data+Models#Asterisk12RESTDataModels-PlaybackFinished) event.

Dialplan
--------

For this example, we need to just drop the channel into Stasis, specifying our application:




---

  
extensions.conf  

```
truetextexten => 1000,1,NoOp()
 same => n,Stasis(channel-playback-monkeys)
 same => n,Hangup() 

```

Python
------

Much like the `[channel-tones.py](https://wiki.asterisk.org/wiki/display/%7Emjordan/Draft%3A+ARI+Channels%3A+Performing+a+simple+playback+of+media#Draft:ARIChannels:Performingasimpleplaybackofmedia-channel-tones.py)` example, we'll start off by initiating a playback on the channel. Instead of specifying a `tone` scheme, however, we'll specify a scheme of `sound` with a resource of `tt-monkeys`. Unlike the tones, this media *does* have a well defined ending - the end of the sound file! So we'll subscribe for the `PlaybackFinished` event and tell `ari-py` to call `playback_finished` when our monkeys are done attacking.

```
truepy32  playback_id = str(uuid.uuid4())
 playback = channel.playWithId(playbackId=playback_id,
 media='sound:tt-monkeys')
 playback.on_event('PlaybackFinished', playback_finished)

```

Unfortunately, `ari-py` doesn't let us pass arbitrary data to a callback function in the same fashion as a Python timer. Nuts. Luckily, the `Playback` object has a property, `target_uri`, that tells us which object it just finished playing to. Using that, we can get the `channel` object back from Asterisk so we can hang it up.

```
truepy19 def playback_finished(playback, ev):
 """Callback when the monkeys have finished howling"""

 target_uri = playback.json.get('target_uri')
 channel_id = target_uri.replace('channel:', '')
 channel = client.channels.get(channelId=channel_id)

 print "Monkeys successfully vanquished %s; hanging them up" % channel.json.get('name')
 channel.hangup()

```

Note that unlike the `channel-tones.py` example, this application eschews the use of Python timers and simply responds to ARI events as they happen. This means we don't have to do much in our `StasisEnd` event, and we have to track less state.

### channel-playback-monkeys.py

The full source code for `channel-playback-monkeys.py` is shown below:

```
truepy #!/usr/bin/env python

import ari
import logging
import uuid

logging.basicConfig(level=logging.ERROR)

client = ari.connect('http://localhost:8088', 'asterisk', 'asterisk')

def stasis_end_cb(channel, ev):
 """Handler for StasisEnd event"""

 print "Channel %s just left our application" % channel.json.get('name')

def stasis_start_cb(channel_obj, ev):
 """Handler for StasisStart event"""

 def playback_finished(playback, ev):
 """Callback when the monkeys have finished howling"""

 target_uri = playback.json.get('target_uri')
 channel_id = target_uri.replace('channel:', '')
 channel = client.channels.get(channelId=channel_id)

 print "Monkeys successfully vanquished %s; hanging them up" % channel.json.get('name')
 channel.hangup()

 channel = channel_obj.get('channel')
 print "Monkeys! Attack %s!" % channel.json.get('name')

 playback_id = str(uuid.uuid4())
 playback = channel.playWithId(playbackId=playback_id,
 media='sound:tt-monkeys')
 playback.on_event('PlaybackFinished', playback_finished)


client.on_channel_event('StasisStart', stasis_start_cb)
client.on_channel_event('StasisEnd', stasis_end_cb)


client.run(apps='channel-playback-monkeys')

```

### channel-playback-monkeys.py in action

The following shows the output of the `channel-playback-monkeys`.py script when a `PJSIP` channel for `alice` enters the application:

```
Monkeys! Attack PJSIP/alice-00000000!
Monkeys successfully vanquished PJSIP/alice-00000000; hanging them up
Channel PJSIP/alice-00000000 just left our application

```

JavaScript (Node.js)
--------------------

Much like the `[channel-tones.js](#channel-tones.js)` example, we'll start off by initiating a playback on the channel. Instead of specifying a `tone` scheme, however, we'll specify a scheme of `sound` with a resource of `tt-monkeys`. Unlike the tones, this media *does* have a well defined ending - the end of the sound file! So we'll subscribe for the `PlaybackFinished` event and tell `ari-client` to call `playbackFinished` when our monkeys are done attacking. Notice that we use `client.Playback()` to generate a playback object with a pre-existing Id so we can scope the PlaybackFinished event to the playback we just created.

```
truejs20var playback = client.Playback();
channel.play({media: 'sound:tt-monkeys'},
 playback, function(err, newPlayback) {
 if (err) {
 throw err;
 }
});
playback.on('PlaybackFinished', playbackFinished);

```

Notice that we use the fact that the playbackFinished callback closes over the original channel variable to perform a hangup operation using that object directly.

```
truejs29function playbackFinished(event, completedPlayback) {
 console.log(util.format(
 'Monkeys successfully vanquished %s; hanging them up',
 channel.name));
 channel.hangup(function(err) {
 if (err) {
 throw err;
 }
 });
}

```

Note that unlike the `channel-tones.js` example, this application eschews the use of JavaScript timeouts and simply responds to ARI events as they happen. This means we don't have to do much in our `StasisEnd` event, and we have to track less state.

### channel-playback-monkeys.js

The full source code for `channel-playback-monkeys.js` is shown below:

```
truejs/*jshint node: true */
'use strict';

var ari = require('ari-client');
var util = require('util');

ari.connect('http://localhost:8088', 'asterisk', 'asterisk', clientLoaded);

// handler for client being loaded
function clientLoaded (err, client) {
 if (err) {
 throw err;
 }

 // handler for StasisStart event
 function stasisStart(event, channel) {
 console.log(util.format(
 'Monkeys! Attack %s!', channel.name));

 var playback = client.Playback();
 channel.play({media: 'sound:tt-monkeys'},
 playback, function(err, newPlayback) {
 if (err) {
 throw err;
 }
 });
 playback.on('PlaybackFinished', playbackFinished);

 function playbackFinished(event, completedPlayback) {
 console.log(util.format(
 'Monkeys successfully vanquished %s; hanging them up',
 channel.name));
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
 }

 client.on('StasisStart', stasisStart);
 client.on('StasisEnd', stasisEnd);

 client.start('channel-playback-monkeys');
}

```

### channel-playback-monkeys.js in action

The following shows the output of the `channel-playback-monkeys`.js script when a `PJSIP` channel for `alice` enters the application:

```
Monkeys! Attack PJSIP/alice-00000000!
Monkeys successfully vanquished PJSIP/alice-00000000; hanging them up
Channel PJSIP/alice-00000000 just left our application

```

