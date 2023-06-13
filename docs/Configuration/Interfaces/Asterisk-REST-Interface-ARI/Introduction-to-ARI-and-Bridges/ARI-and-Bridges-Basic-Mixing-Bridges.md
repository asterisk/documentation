---
title: ARI and Bridges: Basic Mixing Bridges
pageid: 29396220
---

Mixing Bridges
==============

In a mixing bridge, Asterisk shares media between all the channels in the bridge. Depending on the attributes the bridge was created with and the types of channels in the bridge, a mixing bridge may attempt to share the media in a variety of ways. They are, in order of best performance to lowest performance:

* Direct packet sharing between devices - when there are two channels in a mixing bridge of similar types, it may be possible to have the media bypass Asterisk completely. In this type of bridge, the channels will pass media directly between each other, and Asterisk will simply monitor the state of the channels. However, because the media is not going through Asterisk, most features - such as recording, speech detection, DTMF, etc. - are not available. The `proxy_media` attribute or the `dtmf_events` attribute will prevent this mixing type from being used.
* Native packet sharing through Asterisk - when there are two channels in a mixing bridge of similar types, but the media cannot flow directly between the devices, Asterisk will attempt to mix the media between the channels by directly passing media from one channel to the other, and vice versa. The media itself is not decoded, and so - much like when the media is directly shared between the devices - Asterisk cannot use many features. The `proxy_media` attribute or the `dtmf_events` attribute will prevent this mixing type from being used.
On This Page* Two party mixing - when there are two channels in a mixing bridge, regardless of the channel type, Asterisk will decode the media from each channel and pass it to the other participant. This mixing technology allows for all the various features of Asterisk to be used on the channels while they are in the bridge, but does not necessarily incur any penalties from transcoding.
* Multi-party mixing - when there are more than two channels in a mixing bridge, Asterisk will transcode the media from each participant into signed linear, mix the media from all participants together into a new media frame, then write the media back out to all participants.

At all times, the bridge will attempt to mix the media in the most performant manner possible. As the situation in the bridge changes, Asterisk will switch the mixing technology to the best mixing technology available.

What Can Happen in a Mixing Bridge
----------------------------------



| Action | Bridge Response |
| --- | --- |
| A bridge is created using `POST /bridges`, and Alice's channel - which supports having media be directly sent to another device - is added to the bridge using `POST /bridges/{bridge_id}/addChannel`. | Asterisk picks the basic two-party mixing technology. We don't know yet what other channel is going to join the bridge - it could be anything! - and so Asterisk picks the best one based on the information it currently has. |
| Bob's channel - which also supports having media be directly sent to another device - also joins the bridge via `POST /bridges/{bridge_id}/addChannel`. | We have two channels in the bridge now, so Asterisk re-evaluates how the media is mixed. Since both channels support having their media be sent directly to each other, and mixing media that way is more performant than the current mixing technology, Asterisk picks the direct media mixing technology and instructs the channels to tell their devices to send the media to each other. |
| Carol's channel - which is a DAHDI channel (poor Carol, calling from the PSTN) - is also added to the bridge via `POST /bridges/{bridge_id}/addChannel`. | Since we now have three channels in the bridge, Asterisk switches the mixing technology to multi-mix. Alice and Bob's media is sent back to Asterisk, and Asterisk mixes the media from Alice, Bob, and Carol together and then sends the new media to each channel. |
| Eventually, Alice hangs up, leaving only Bob and Carol in the bridge. | Since Alice left, Asterisk switches back to the basic two-party mixing technology. We can't use a native mixing technology, as Bob and Carol's channels are incompatible, but we can use a mixing technology that is less expensive than the multi-mix technology. |

Example: Implementing a basic dial
==================================

Dialing can be implemented by using the [`POST - /channels`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+12+Channels+REST+API#Asterisk12ChannelsRESTAPI-originate) operation and putting both the resulting channel and the original Stasis channel in a mixing bridge to allow media to flow between them. An endpoint should be specified along with the originate operation as well as a Stasis application name. This will cause the dialed channel to enter Stasis, where it can be added to a mixing bridge. It's also a good idea to use Stasis application arguments to flag that the dialed channel was dialed using originate in order to handle it differently from the original channel once it enters into the Stasis application.

This example ARI application will do the following:

1. When a channel enters into the Stasis application, a call will be originated to the endpoint specified by the first command line argument to the script.
2. When that channel enters into the Stasis application, a mixing bridge will be created and the two channels will be put in it so that media can flow between them.
3. If either channel hangs up, the other channel will also be hung up.
4. Once the dialed channel exists the Stasis application, the mixing bridge will be destroyed.

Dialplan
--------

For this example, we'll use a Stasis application that species not only the application - `bridge-dial` - but also:

* Whether or not the channel is `inbound` or a `dialed` channel.
* If the channel is `inbound`, the endpoint to dial.

As an example, here is a dialplan that dials the `PJSIP/bob` endpoint:

extensions.confexten => 1000,1,NoOp()
 same => n,Stasis(bridge-dial,inbound,PJSIP/bob)
 same => n,Hangup()Python
------

As is typical for an ARI application, we'll start off by implementing a callback handler for the `StasisStart` event. In this particular case, our callback handler will be called in two conditions:

1. When an inbound channel enters into the `Stasis` dialplan application. In that case, we'll want to initiate the outbound dial.
2. When an outbound channel answers. In that case, we'll want to defer processing to a different callback handler and - in that handler - initiate the bridging of the two channels.

In our `StasisStart` callback handler, we can expect to have two pieces of information passed to the application:

1. The "type" of channel entering the callback handler. In this case, we expect the type to be either `inbound` or `dialed`.
2. If the "type" of channel is `inbound`, we expect the second argument to be the endpoint to dial.

The following code shows the `StasisStart` callback handler for the `inbound` channel. Note that if the "type" is not `inbound`, we defer processing to another callback handler. We also tell the inbound channel to start ringing via the `ring` operation, and initiate an outbound dial by creating a new channel to the endpoint specified. Finally, we subscribe to the `StasisEnd` event for both channels, and instruct them to call a `safe_hangup` function on the opposing channel. This ensures that if either party hangs up, we hang up the person they were talking to. We'll show the implementation of that function shortly.

Be careful of errors!Note that we wrap the origination with a `try / except` block, in case the endpoint provided by the dialplan doesn't exist. When taking in input from a user or from the Asterisk dialplan, it is always good to be mindful of possible errors.

truepy31def stasis\_start\_cb(channel\_obj, ev):
 """Handler for StasisStart"""

 channel = channel\_obj.get('channel')
 channel\_name = channel.json.get('name')
 args = ev.get('args')

 if not args:
 print "Error: {} didn't provide any arguments!".format(channel\_name)
 return

 if args and args[0] != 'inbound':
 # Only handle inbound channels here
 return

 if len(args) != 2:
 print "Error: {} didn't tell us who to dial".format(channel\_name)
 channel.hangup()
 return

 print "{} entered our application".format(channel\_name)
 channel.ring()

 try:
 print "Dialing {}".format(args[1])
 outgoing = client.channels.originate(endpoint=args[1],
 app='bridge-dial',
 appArgs='dialed')
 except requests.HTTPError:
 print "Whoops, pretty sure %s wasn't valid" % args[1]
 channel.hangup()
 return

 channel.on\_event('StasisEnd', lambda \*args: safe\_hangup(outgoing))
 outgoing.on\_event('StasisEnd', lambda \*args: safe\_hangup(channel))The `safe_hangup` function referenced above simply does a "safe" hangup on the channel provided. This is because it is entirely possible for both parties to hang up nearly simultaneously. Since our Python code is running in a separate process from Asterisk, we may be processing the hang up of the first party and instruct Asterisk to hang up the second party when they are already technically hung up! Again, it is always a good idea to view the processing of a communications application in an asynchronous fashion: we live in an asynchronous world, and a user can take an action at any moment in time.

truepy12def safe\_hangup(channel):
 """Safely hang up the specified channel"""
 try:
 channel.hangup()
 print "Hung up {}".format(channel.json.get('name'))
 except requests.HTTPError as e:
 if e.response.status\_code != requests.codes.not\_found:
 raise eWe now have to handle the outbound channel when it answers. Currently, when it answers it will be immediately placed in our Stasis application, which will call the `stasis_start_cb` we previously defined. While we could have some additional `if / else` blocks in that handler, we can also just apply a `StasisStart` callback to the outbound channel after we create it, and handle its entrance separately.

When the outbound channel is answered, we need to do the following:

1. Answer the inbound channel.
2. Create a new mixing bridge.
3. Put both channels into the mixing bridge.
4. Ensure we destroy the mixing bridge when either channel leaves our application.

This is shown in the following code:

truepy67 def outgoing\_start\_cb(channel\_obj, ev):
 """StasisStart handler for our dialed channel"""

 print "{} answered; bridging with {}".format(outgoing.json.get('name'),
 channel.json.get('name'))
 channel.answer()

 bridge = client.bridges.create(type='mixing')
 bridge.addChannel(channel=[channel.id, outgoing.id])

 # Clean up the bridge when done
 channel.on\_event('StasisEnd', lambda \*args:
 safe\_bridge\_destroy(bridge))
 outgoing.on\_event('StasisEnd', lambda \*args:
 safe\_bridge\_destroy(bridge))

 outgoing.on\_event('StasisStart', outgoing\_start\_cb)Note that the `safe_bridge_destroy` function is similar to the `safe_hangup` function, except that it attempts to safely destroy the mixing bridge, as opposed to hanging up the other party.

bridge-dial-python

### bridge-dial.py

The full source code for `bridge-dial.py` is shown below:

basic-dial.pytruepy#!/usr/bin/env python

import logging
import requests
import ari

logging.basicConfig(level=logging.ERROR)

client = ari.connect('http://localhost:8088', 'asterisk', 'asterisk')


def safe\_hangup(channel):
 """Safely hang up the specified channel"""
 try:
 channel.hangup()
 print "Hung up {}".format(channel.json.get('name'))
 except requests.HTTPError as e:
 if e.response.status\_code != requests.codes.not\_found:
 raise e


def safe\_bridge\_destroy(bridge):
 """Safely destroy the specified bridge"""
 try:
 bridge.destroy()
 except requests.HTTPError as e:
 if e.response.status\_code != requests.codes.not\_found:
 raise e


def stasis\_start\_cb(channel\_obj, ev):
 """Handler for StasisStart"""

 channel = channel\_obj.get('channel')
 channel\_name = channel.json.get('name')
 args = ev.get('args')

 if not args:
 print "Error: {} didn't provide any arguments!".format(channel\_name)
 return

 if args and args[0] != 'inbound':
 # Only handle inbound channels here
 return

 if len(args) != 2:
 print "Error: {} didn't tell us who to dial".format(channel\_name)
 channel.hangup()
 return

 print "{} entered our application".format(channel\_name)
 channel.ring()

 try:
 print "Dialing {}".format(args[1])
 outgoing = client.channels.originate(endpoint=args[1],
 app='bridge-dial',
 appArgs='dialed')
 except requests.HTTPError:
 print "Whoops, pretty sure %s wasn't valid" % args[1]
 channel.hangup()
 return

 channel.on\_event('StasisEnd', lambda \*args: safe\_hangup(outgoing))
 outgoing.on\_event('StasisEnd', lambda \*args: safe\_hangup(channel))

 def outgoing\_start\_cb(channel\_obj, ev):
 """StasisStart handler for our dialed channel"""

 print "{} answered; bridging with {}".format(outgoing.json.get('name'),
 channel.json.get('name'))
 channel.answer()

 bridge = client.bridges.create(type='mixing')
 bridge.addChannel(channel=[channel.id, outgoing.id])

 # Clean up the bridge when done
 channel.on\_event('StasisEnd', lambda \*args:
 safe\_bridge\_destroy(bridge))
 outgoing.on\_event('StasisEnd', lambda \*args:
 safe\_bridge\_destroy(bridge))

 outgoing.on\_event('StasisStart', outgoing\_start\_cb)


client.on\_channel\_event('StasisStart', stasis\_start\_cb)

client.run(apps='bridge-dial')

### bridge-dial.py in action

The following shows the output of the `bridge-dial.py` script when a `PJSIP` channel for `alice` enters the application and dials a `PJSIP` channel for `bob`:

PJSIP/Alice-00000001 entered our application
Dialing PJSIP/Bob
PJSIP/Bob-00000002 answered; bridging with PJSIP/Alice-00000001
Hung up PJSIP/Bob-00000002 

JavaScript (Node.js)
--------------------

This example shows how to use anonymous functions to call functions with extra parameters that would otherwise require a closer. This can be done to reduce the number of nested callbacks required to implement the flow of an application. First, we look for an application argument in our `StasisStart` event callback to ensure that we will only originate a call if the channel entering Stasis is a channel that dialed our application extension we defined in the extensions.conf file above. We then play a sound on the channel asking the caller to wait while they are being connected and call the originate() function to process down the application flow:

truejs22function stasisStart(event, channel) {
 // ensure the channel is not a dialed channel
 var dialed = event.args[0] === 'dialed';

 if (!dialed) {
 channel.answer(function(err) {
 if (err) {
 throw err;
 }

 console.log('Channel %s has entered our application', channel.name);

 var playback = client.Playback();
 channel.play({media: 'sound:pls-wait-connect-call'},
 playback, function(err, playback) {
 if (err) {
 throw err;
 }
 });

 originate(channel);
 });
 }
}We then prepare an object with a locally generate Id for the dialed channel and register event callbacks either channels hanging up and the dialed channel entering into the Stasis application. We then originate a call to the endpoint specified by the first command line argument to the script passing in a Stasis application argument of dialed so we can skip the dialed channel when the original StasisStart event callback fires for it:

truejs47function originate(channel) {
 var dialed = client.Channel();

 channel.on('StasisEnd', function(event, channel) {
 hangupDialed(channel, dialed);
 });

 dialed.on('ChannelDestroyed', function(event, dialed) {
 hangupOriginal(channel, dialed);
 });

 dialed.on('StasisStart', function(event, dialed) {
 joinMixingBridge(channel, dialed);
 });

 dialed.originate(
 {endpoint: process.argv[2], app: 'bridge-dial', appArgs: 'dialed'},
 function(err, dialed) {
 if (err) {
 throw err;
 }
 });
}We then handle either channel hanging up by hanging up the other channel. Note that we skip any errors that occur on hangup since it is possible that the channel we are attempting to hang up is the one that has already left and would result in an HTTP error as it is no longer a Statis channel:

truejs73function hangupDialed(channel, dialed) {
 console.log(
 'Channel %s left our application, hanging up dialed channel %s',
 channel.name, dialed.name);

 // hangup the other end
 dialed.hangup(function(err) {
 // ignore error since dialed channel could have hung up, causing the
 // original channel to exit Stasis
 });
}

// handler for the dialed channel hanging up so we can gracefully hangup the
// other end
function hangupOriginal(channel, dialed) {
 console.log('Dialed channel %s has been hung up, hanging up channel %s',
 dialed.name, channel.name);

 // hangup the other end
 channel.hangup(function(err) {
 // ignore error since original channel could have hung up, causing the
 // dialed channel to exit Stasis
 });
}We then handle the StasisStart event for the dialed channel by registered an event callback for the StasisEnd event on the dialed channel, answer that answer, creating a new mixing bridge, and finally calling a function to add the two channels to the new bridge:

truejs99function joinMixingBridge(channel, dialed) {
 var bridge = client.Bridge();

 dialed.on('StasisEnd', function(event, dialed) {
 dialedExit(dialed, bridge);
 });

 dialed.answer(function(err) {
 if (err) {
 throw err;
 }
 });

 bridge.create({type: 'mixing'}, function(err, bridge) {
 if (err) {
 throw err;
 }

 console.log('Created bridge %s', bridge.id);

 addChannelsToBridge(channel, dialed, bridge);
 });
}We then handle the dialed channel exiting the Stasis application by destroying the mixing bridge:

truejs124function dialedExit(dialed, bridge) {
 console.log(
 'Dialed channel %s has left our application, destroying bridge %s',
 dialed.name, bridge.id);

 bridge.destroy(function(err) {
 if (err) {
 throw err;
 }
 });
}Finally, the function that was called earlier by the callback handling the StasisStart event for the dialed channel adds the two channels to the mixing bridge which allows media to flow between the two channels:

truejs137function addChannelsToBridge(channel, dialed, bridge) {
 console.log('Adding channel %s and dialed channel %s to bridge %s',
 channel.name, dialed.name, bridge.id);

 bridge.addChannel({channel: [channel.id, dialed.id]}, function(err) {
 if (err) {
 throw err;
 }
 });
}### bridge-dial.js

The full source code for `bridge-dial.js` is shown below:

bridge-dial.jstruejs/\*jshint node:true\*/
'use strict';

var ari = require('ari-client');
var util = require('util');

// ensure endpoint was passed in to script
if (!process.argv[2]) {
 console.error('usage: node bridge-dial.js endpoint');
 process.exit(1);
}

ari.connect('http://localhost:8088', 'asterisk', 'asterisk', clientLoaded);

// handler for client being loaded
function clientLoaded (err, client) {
 if (err) {
 throw err;
 }

 // handler for StasisStart event
 function stasisStart(event, channel) {
 // ensure the channel is not a dialed channel
 var dialed = event.args[0] === 'dialed';

 if (!dialed) {
 channel.answer(function(err) {
 if (err) {
 throw err;
 }

 console.log('Channel %s has entered our application', channel.name);

 var playback = client.Playback();
 channel.play({media: 'sound:pls-wait-connect-call'},
 playback, function(err, playback) {
 if (err) {
 throw err;
 }
 });

 originate(channel);
 });
 }
 }

 function originate(channel) {
 var dialed = client.Channel();

 channel.on('StasisEnd', function(event, channel) {
 hangupDialed(channel, dialed);
 });

 dialed.on('ChannelDestroyed', function(event, dialed) {
 hangupOriginal(channel, dialed);
 });

 dialed.on('StasisStart', function(event, dialed) {
 joinMixingBridge(channel, dialed);
 });

 dialed.originate(
 {endpoint: process.argv[2], app: 'bridge-dial', appArgs: 'dialed'},
 function(err, dialed) {
 if (err) {
 throw err;
 }
 });
 }

 // handler for original channel hanging up so we can gracefully hangup the
 // other end
 function hangupDialed(channel, dialed) {
 console.log(
 'Channel %s left our application, hanging up dialed channel %s',
 channel.name, dialed.name);

 // hangup the other end
 dialed.hangup(function(err) {
 // ignore error since dialed channel could have hung up, causing the
 // original channel to exit Stasis
 });
 }

 // handler for the dialed channel hanging up so we can gracefully hangup the
 // other end
 function hangupOriginal(channel, dialed) {
 console.log('Dialed channel %s has been hung up, hanging up channel %s',
 dialed.name, channel.name);

 // hangup the other end
 channel.hangup(function(err) {
 // ignore error since original channel could have hung up, causing the
 // dialed channel to exit Stasis
 });
 }

 // handler for dialed channel entering Stasis
 function joinMixingBridge(channel, dialed) {
 var bridge = client.Bridge();

 dialed.on('StasisEnd', function(event, dialed) {
 dialedExit(dialed, bridge);
 });

 dialed.answer(function(err) {
 if (err) {
 throw err;
 }
 });

 bridge.create({type: 'mixing'}, function(err, bridge) {
 if (err) {
 throw err;
 }

 console.log('Created bridge %s', bridge.id);

 addChannelsToBridge(channel, dialed, bridge);
 });
 }

 // handler for the dialed channel leaving Stasis
 function dialedExit(dialed, bridge) {
 console.log(
 'Dialed channel %s has left our application, destroying bridge %s',
 dialed.name, bridge.id);

 bridge.destroy(function(err) {
 if (err) {
 throw err;
 }
 });
 }

 // handler for new mixing bridge ready for channels to be added to it
 function addChannelsToBridge(channel, dialed, bridge) {
 console.log('Adding channel %s and dialed channel %s to bridge %s',
 channel.name, dialed.name, bridge.id);

 bridge.addChannel({channel: [channel.id, dialed.id]}, function(err) {
 if (err) {
 throw err;
 }
 });
 }

 client.on('StasisStart', stasisStart);

 client.start('bridge-dial');
}### bridge-dial.js in action

The following shows the output of the `bridge-dial.js` script when a `PJSIP` channel for `alice` enters the application and dials a PJSIP channel for bob:

Channel PJSIP/alice-00000001 has entered our application
Created bridge 30430e82-83ed-4242-9f37-1bc040f70724
Adding channel PJSIP/alice-00000001 and dialed channel PJSIP/bob-00000002 to bridge 30430e82-83ed-4242-9f37-1bc040f70724
Dialed channel PJSIP/bob-00000002 has left our application, destroying bridge 30430e82-83ed-4242-9f37-1bc040f70724
Dialed channel PJSIP/bob-00000002 has been hung up, hanging up channel PJSIP/alice-00000001
Channel PJSIP/alice-00000001 left our application, hanging up dialed channel undefined