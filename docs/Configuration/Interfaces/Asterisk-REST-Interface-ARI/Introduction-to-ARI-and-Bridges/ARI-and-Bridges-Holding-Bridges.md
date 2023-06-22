---
title: ARI and Bridges: Holding Bridges
pageid: 29396218
---

Holding Bridges
===============

Holding bridges are a special type of bridge in Asterisk. The purpose of a holding bridge is to provide a consistent way to place channels when you want the person on the other end of the channel to wait. Asterisk will mix the media to the channel depending on the type of **role** the channel has within the bridge. Two types of roles are supported:

* `participant` - the default role for channels in a holding bridge. Media from the bridge is played directly to the channels; however, media from the channels is not played to any other participant.
* `announcer` - if a channel joins a holding bridge as an announcer, the bridge will not play media to the channel. However, all media from the channel will be played to all `participant` channels in the bridge simultaneously.

Adding a channel as a participant
---------------------------------

To add a channel as a participant to a holding bridge, you can either not specify a `role` (as the `participant` role is the default role for holding bridges), or you can specify the `participant` role directly:




---

  
  


```

POST /bridges/{bridge\_id}/addChannel?channel=12345
POST /bridges/{bridge\_id}/addChannel?channel=12345&role=participant

```


On This PageAdding a channel as an announcer
--------------------------------

To add a channel as an announcer to a holding bridge, you must specify a role of `announcer`:




---

  
  


```

POST /bridges/{bridge\_id}/addChannel?channel=56789&role=announcer

```




!!! tip When is an Announcer channel useful?
    If you want to simply play back a media file to all participants in a holding bridge, e.g., "your call is important to us, please keep waiting", you can simply initiate a `/play` operation on the holding bridge itself. That will perform a playback to all participants in the same fashion as an announcer channel.

    An announcer channel is particularly useful when there is someone actually on the other end of the channel, as opposed to a pre-recorded message. For example, you may have a call queue supervisor who wants to let everyone who is waiting for an agent that response times are especially long, but to hold on for a bit longer. Jumping into the holding bridge as an announcer adds a small bit of humanity to the dreaded call queue experience!

      
[//]: # (end-tip)



### Music on hold, media playback, recording, and other such things

When dealing with holding bridges, given the particular media rules and channel roles involves, there are some additional catches that you have to be aware when manipulating the bridge:

1. Playing music on hold to the bridge will play it for all participants, as well playing media to the bridge. However, you can only do **one** of those operations - you cannot play media to a holding bridge while you are simultaneously playing music on hold to the bridge. Initiating a `/play` operation on a holding bridge should only be done after stopping the music on hold; likewise, starting music on hold on a bridge with a `/play` operation currently in progress will fail.
2. Recording a holding bridge - while possible - is not terribly interesting. Participant media is dropped - so at best, you'll only record the entertainment that was played to the participants.

### There can be only one!

You cannot have an announcer channel in a holding bridge at the same time that you perform a `play` operation or have music on hold playing to the bridge. Holding bridges do **not** mix the media between announcers. Since media from the `play` operation has to go to all participants, as does your announcer channel's media, the holding bridge will become quite confused about your application's intent.

Example: Infinite wait area
===========================

Now that we all know that holding bridges are perfect for building what many callers fear - the dreaded waiting area of doom - let's make one! This example ARI application will do the following:

1. When a channel enters into the Stasis application, it will be put into a existing holding bridge or a newly created one if none exist.
2. Music on hold will be played on the bridge.
3. Periodically, the `thnk-u-for-patience` sound will be played to the bridge thanking the users for their patience, which they will need since this holding bridge will never progress beyond this point!
4. When a channel leaves a holding bridge, if no other channels remain, the bridge will be destroyed.

This example will use a similar structure to the bridge-hold python example. Unlike that example, however, it will use some form of a timer to perform our periodic announcement to the holding bridge, and when all the channels have left the infinite wait area, we'll destroy the holding bridge (cleaning up resources is always good!)

Dialplan
--------

For this example, we need to just drop the channel into Stasis, specifying our application:




---

  
extensions.conf  


```

exten => 1000,1,NoOp()
 same => n,Stasis(bridge-infinite-wait)
 same => n,Hangup()

```


Python
------

When a channel enters our Stasis application, we first look for an existing holding bridge or create one if none is found. When we create a new bridge, we start music on hold in the bridge and create a timer that will call a callback after 30 seconds. That callback temporarily stops the music on hold, and starts a play operation on the bridge that thanks everyone for their patience. When the play operation finishes, it resumes music on hold.




---

  
  


```

truepy11# find or create a holding bridge
holding\_bridge = None

# Announcer timer
announcer\_timer = None

def find\_or\_create\_bridge():
 """Find our infinite wait bridge, or create a new one

 Returns:
 The one and only holding bridge
 """

 global holding\_bridge
 global announcer\_timer

 if holding\_bridge:
 return holding\_bridge

 bridges = [candidate for candidate in client.bridges.list() if
 candidate.json['bridge\_type'] == 'holding']
 if bridges:
 bridge = bridges[0]
 print "Using bridge %s" % bridge.id
 else:
 bridge = client.bridges.create(type='holding')
 bridge.startMoh()
 print "Created bridge %s" % bridge.id

 def play\_announcement(bridge):
 """Play an announcement to the bridge"""

 def on\_playback\_finished(playback, ev):
 """Handler for the announcement's PlaybackFinished event"""
 global announcer\_timer
 global holding\_bridge

 holding\_bridge.startMoh()

 announcer\_timer = threading.Timer(30, play\_announcement,
 [holding\_bridge])
 announcer\_timer.start()

 bridge.stopMoh()
 print "Letting the everyone know we care..."
 thanks\_playback = bridge.play(media='sound:thnk-u-for-patience')
 thanks\_playback.on\_event('PlaybackFinished', on\_playback\_finished)

 holding\_bridge = bridge
 holding\_bridge.on\_event('ChannelLeftBridge', on\_channel\_left\_bridge)
 # After 30 seconds, let everyone in the bridge know that we care
 announcer\_timer = threading.Timer(30, play\_announcement, [holding\_bridge])
 announcer\_timer.start()
 return bridge

```


The function that does this work, `find_or_create_bridge`, is called from our `StasisStart` event handler. The bridge that it returns will have the new channel added to it.




---

  
  


```

truepy87def stasis\_start\_cb(channel\_obj, ev):
 """Handler for StasisStart event"""
 
 bridge = find\_or\_create\_bridge()

 channel = channel\_obj.get('channel')
 print "Channel %s just entered our application, adding it to bridge %s" % (
 channel.json.get('name'), holding\_bridge.id)
 
 channel.answer()
 bridge.addChannel(channel=channel.id)
 

```


In the `find_or_create_bridge` function, we also subscribed for the `ChannelLeftBridge` event. We'll add a callback handler for this in that function as well. When the channel leaves the bridge, we'll check to see if there are no more channels in the bridge and - if so - destroy the bridge.




---

  
  


```

truepy59 def on\_channel\_left\_bridge(bridge, ev):
 """Handler for ChannelLeftBridge event"""
 global holding\_bridge
 global announcer\_timer

 channel = ev.get('channel')
 channel\_count = len(bridge.json.get('channels'))

 print "Channel %s left bridge %s" % (channel.get('name'), bridge.id)
 if holding\_bridge.id == bridge.id and channel\_count == 0:
 if announcer\_timer:
 announcer\_timer.cancel()
 announcer\_timer = None
 
 print "Destroying bridge %s" % bridge.id
 holding\_bridge.destroy()
 holding\_bridge = None



```


### bridge-infinite-wait.py

The full source code for `bridge-infinite-wait.py` is shown below:




---

  
bridge-infinite-wait.py  


```

truepy#!/usr/bin/env python

import ari
import logging
import threading
 
logging.basicConfig(level=logging.ERROR)
 
client = ari.connect('http://localhost:8088', 'asterisk', 'asterisk')
 
# find or create a holding bridge
holding\_bridge = None

# Announcer timer
announcer\_timer = None

def find\_or\_create\_bridge():
 """Find our infinite wait bridge, or create a new one

 Returns:
 The one and only holding bridge
 """

 global holding\_bridge
 global announcer\_timer

 if holding\_bridge:
 return holding\_bridge

 bridges = [candidate for candidate in client.bridges.list() if
 candidate.json['bridge\_type'] == 'holding']
 if bridges:
 bridge = bridges[0]
 print "Using bridge %s" % bridge.id
 else:
 bridge = client.bridges.create(type='holding')
 bridge.startMoh()
 print "Created bridge %s" % bridge.id

 def play\_announcement(bridge):
 """Play an announcement to the bridge"""

 def on\_playback\_finished(playback, ev):
 """Handler for the announcement's PlaybackFinished event"""
 global announcer\_timer
 global holding\_bridge

 holding\_bridge.startMoh()

 announcer\_timer = threading.Timer(30, play\_announcement,
 [holding\_bridge])
 announcer\_timer.start()

 bridge.stopMoh()
 print "Letting the everyone know we care..."
 thanks\_playback = bridge.play(media='sound:thnk-u-for-patience')
 thanks\_playback.on\_event('PlaybackFinished', on\_playback\_finished)

 def on\_channel\_left\_bridge(bridge, ev):
 """Handler for ChannelLeftBridge event"""
 global holding\_bridge
 global announcer\_timer

 channel = ev.get('channel')
 channel\_count = len(bridge.json.get('channels'))

 print "Channel %s left bridge %s" % (channel.get('name'), bridge.id)
 if holding\_bridge.id == bridge.id and channel\_count == 0:
 if announcer\_timer:
 announcer\_timer.cancel()
 announcer\_timer = None
 
 print "Destroying bridge %s" % bridge.id
 holding\_bridge.destroy()
 holding\_bridge = None

 holding\_bridge = bridge
 holding\_bridge.on\_event('ChannelLeftBridge', on\_channel\_left\_bridge)

 # After 30 seconds, let everyone in the bridge know that we care
 announcer\_timer = threading.Timer(30, play\_announcement, [holding\_bridge])
 announcer\_timer.start()

 return bridge


def stasis\_start\_cb(channel\_obj, ev):
 """Handler for StasisStart event"""
 
 bridge = find\_or\_create\_bridge()

 channel = channel\_obj.get('channel')
 print "Channel %s just entered our application, adding it to bridge %s" % (
 channel.json.get('name'), holding\_bridge.id)
 
 channel.answer()
 bridge.addChannel(channel=channel.id)
 
def stasis\_end\_cb(channel, ev):
 """Handler for StasisEnd event"""
 
 print "Channel %s just left our application" % channel.json.get('name')
 
client.on\_channel\_event('StasisStart', stasis\_start\_cb)
client.on\_channel\_event('StasisEnd', stasis\_end\_cb)
 
client.run(apps='bridge-infinite-wait')


```


 

### bridge-infinite-wait.py in action




---

  
  


```

Created bridge 950c4805-c33c-4895-ad9a-2798055e4939
Channel PJSIP/alice-00000000 just entered our application, adding it to bridge 950c4805-c33c-4895-ad9a-2798055e4939
Letting the everyone know we care...
Channel PJSIP/alice-00000000 left bridge 950c4805-c33c-4895-ad9a-2798055e4939
Destroying bridge 950c4805-c33c-4895-ad9a-2798055e4939
Channel PJSIP/alice-00000000 just left our application

```


JavaScript (Node.js)
--------------------

When a channel enters our Stasis application, we first look for an existing holding bridge or create one if none is found. When we create a new bridge, we start music on hold in the bridge and create a timer that will call a callback after 30 seconds. That callback temporarily stops the music on hold, and starts a play operation on the bridge that thanks everyone for their patience. When the play operation finishes, it resumes music on hold.

In all cases, we add the channel to the bridge via the `joinBridge` function.




---

  
  


```

truejs18 console.log('Channel %s just entered our application', channel.name);

 // find or create a holding bridge
 client.bridges.list(function(err, bridges) {
 if (err) {
 throw err;
 }

 var bridge = bridges.filter(function(candidate) {
 return candidate.bridge\_type === 'holding';
 })[0];

 if (bridge) {
 console.log('Using bridge %s', bridge.id);
 joinBridge(bridge);
 } else {
 client.bridges.create({type: 'holding'}, function(err, newBridge) {
 if (err) {
 throw err;
 } 
 console.log('Created bridge %s', newBridge.id);
 newBridge.startMoh(function(err) {
 if (err) {
 throw err;
 }
 });
 joinBridge(newBridge);

 timer = setTimeout(play\_announcement, 30000);

 // callback that will let our users know how much we care
 function play\_announcement() {
 console.log('Letting everyone know we care...');
 newBridge.stopMoh(function(err) {
 if (err) {
 throw err;
 }

 var playback = client.Playback();
 newBridge.play({media: 'sound:thnk-u-for-patience'},
 playback, function(err, playback) {
 if (err) {
 throw err;
 }
 });
 playback.once('PlaybackFinished', function(event, playback) {
 newBridge.startMoh(function(err) {
 if (err) {
 throw err;
 }
 });
 timer = setTimeout(play\_announcement, 30000);
 });
 });
 }
 });
 }

```


The joinBridge function involves registered a callback for the ChannelLeftBridge event and adds the channel to the bridge.




---

  
  


```

truejs77 function joinBridge(bridge) {
 channel.once('ChannelLeftBridge', function(event, instances) {
 channelLeftBridge(event, instances, bridge);
 });

 bridge.addChannel({channel: channel.id}, function(err) {
 if (err) {
 throw err;
 }
 });
 channel.answer(function(err) {
 if (err) {
 throw err;
 }
 });
 } 

```


Notice that we use an anonymous function to pass the bridge as an extra parameter to the ChannelLeftBridge callback so we can keep the handler at the same level as joinBridge and avoid another indentation level of callbacks. Finally, we can handle destroying the bridge when the last channel contained in it has left:




---

  
  


```

truejs95 // Handler for ChannelLeftBridge event
 function channelLeftBridge(event, instances, bridge) {
 var holdingBridge = instances.bridge;
 var channel = instances.channel;

 console.log('Channel %s left bridge %s', channel.name, bridge.id);

 if (holdingBridge.id === bridge.id &&
 holdingBridge.channels.length === 0) {

 if (timer) {
 clearTimeout(timer);
 }

 bridge.destroy(function(err) {
 if (err) {
 throw err;
 }
 });
 }
 }

```


### bridge-infinite-wait.js

The full source code for `bridge-infinite-wait.js` is shown below:




```javascript title="bridge-infinite-wait.js" linenums="1"
truejs/\*jshint node:true\*/
'use strict';

var ari = require('ari-client');
var util = require('util');

var timer = null;
ari.connect('http://localhost:8088', 'asterisk', 'asterisk', clientLoaded);

// handler for client being loaded
function clientLoaded (err, client) {
 if (err) {
 throw err;
 }

 // handler for StasisStart event
 function stasisStart(event, channel) {
 console.log('Channel %s just entered our application', channel.name);

 // find or create a holding bridge
 client.bridges.list(function(err, bridges) {
 if (err) {
 throw err;
 }

 var bridge = bridges.filter(function(candidate) {
 return candidate.bridge\_type === 'holding';
 })[0];

 if (bridge) {
 console.log('Using bridge %s', bridge.id);
 joinBridge(bridge);
 } else {
 client.bridges.create({type: 'holding'}, function(err, newBridge) {
 if (err) {
 throw err;
 } 
 console.log('Created bridge %s', newBridge.id);
 newBridge.startMoh(function(err) {
 if (err) {
 throw err;
 }
 });
 joinBridge(newBridge);

 timer = setTimeout(play\_announcement, 30000);

 // callback that will let our users know how much we care
 function play\_announcement() {
 console.log('Letting everyone know we care...');
 newBridge.stopMoh(function(err) {
 if (err) {
 throw err;
 }

 var playback = client.Playback();
 newBridge.play({media: 'sound:thnk-u-for-patience'},
 playback, function(err, playback) {
 if (err) {
 throw err;
 }
 });
 playback.once('PlaybackFinished', function(event, playback) {
 newBridge.startMoh(function(err) {
 if (err) {
 throw err;
 }
 });
 timer = setTimeout(play\_announcement, 30000);
 });
 });
 }
 });
 }
 });

 function joinBridge(bridge) {
 channel.once('ChannelLeftBridge', function(event, instances) {
 channelLeftBridge(event, instances, bridge);
 });

 bridge.addChannel({channel: channel.id}, function(err) {
 if (err) {
 throw err;
 }
 });
 channel.answer(function(err) {
 if (err) {
 throw err;
 }
 });
 }

 // Handler for ChannelLeftBridge event
 function channelLeftBridge(event, instances, bridge) {
 var holdingBridge = instances.bridge;
 var channel = instances.channel;

 console.log('Channel %s left bridge %s', channel.name, bridge.id);

 if (holdingBridge.id === bridge.id &&
 holdingBridge.channels.length === 0) {

 if (timer) {
 clearTimeout(timer);
 }

 bridge.destroy(function(err) {
 if (err) {
 throw err;
 }
 });
 }
 }
 }

 // handler for StasisEnd event
 function stasisEnd(event, channel) {
 console.log('Channel %s just left our application', channel.name);
 }

 client.on('StasisStart', stasisStart);
 client.on('StasisEnd', stasisEnd);

 console.log('starting');
 client.start('bridge-infinite-wait');
}

```


### bridge-infinite-wait.js in action

The following shows the output of the `bridge-infinite-wait.js` script when a `PJSIP` channel for `alice` enters the application:




---

  
  


```

Channel PJSIP/alice-00000001 just entered our application
Created bridge 31a4a193-36a7-412b-854b-cf2cf5f90bbd
Letting everyone know we care...
Channel PJSIP/alice-00000001 left bridge 31a4a193-36a7-412b-854b-cf2cf5f90bbd
Channel PJSIP/alice-00000001 just left our application

```


