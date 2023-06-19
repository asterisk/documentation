---
title: ARI and Bridges: Bridge Operations
pageid: 29396222
---

Moving Between Bridges
======================

Channels can be both added and removed from bridges via the [`POST - /bridges/{bridgeId}/addChannel`](/Asterisk+12+Bridges+REST+API#Asterisk12BridgesRESTAPI-addChannel) and [`POST - /bridges/{bridgeId}/removeChannel`](/Asterisk+12+Bridges+REST+API#Asterisk12BridgesRESTAPI-removeChannel) operations. This allows channels to be put in a holding bridge while waiting for an application to continue to its next step for example. One example of this would be to put an incoming channel into a holding bridge playing music on hold while dialing another endpoint. Once that endpoint answers, the incoming channel can be moved from the holding bridge to a mixing bridge to establish an audio call between the two channels.

Example: Dialing with Entertainment
===================================

This example ARI application will do the following:

1. When a channel enters into the Stasis application, it will be put in a holding bridge and a call will be originated to the endpoint specified by the first command line argument to the script.
2. When that channel enters into the Stasis application, the original channel will be removed from the holding bridge, a mixing bridge will be created, and the two channels will be put in it.
3. If either channel hangs up, the other channel will also be hung up.
4. Once the dialed channel exists the Stasis application, the mixing bridge will be destroyed.
On This Page 

Dialplan
--------

For this example, we need to just drop the channel into Stasis, specifying our application:




---

  
extensions.conf  


```

trueexten => 1000,1,NoOp()
 same => n,Stasis(bridge-move,inbound,PJSIP/bob)
 same => n,Hangup()

```



---


Python
------

A large part of the implementation of this particular example is similar to the [`bridge-dial.py`](/ARI+and+Bridges%3A+Basic+Mixing+Bridges) example. However, instead of ringing the inbound channel, we'll instead create a holding bridge and place the channel in said holding bridge. Since a holding bridge can hold a number of channels, we'll reuse the same holding bridge for all of the channels that use the application. The method to obtain the holding bridge is `find_or_create_holding_bridge`, shown below:




---

  
  


```

truepy11# Our one and only holding bridge
holding\_bridge = None


def find\_or\_create\_holding\_bridge():
 """Find our infinite wait bridge, or create a new one

 Returns:
 The one and only holding bridge
 """
 global holding\_bridge

 if holding\_bridge:
 return holding\_bridge

 bridges = [candidate for candidate in client.bridges.list() if
 candidate.json['bridge\_type'] == 'holding']
 if bridges:
 bridge = bridges[0]
 print "Using bridge {}".format(bridge.id)
 else:
 bridge = client.bridges.create(type='holding')
 bridge.startMoh()
 print "Created bridge {}".format(bridge.id)

 holding\_bridge = bridge
 return holding\_bridge 

```



---


When the inbound channel enters the application, we'll place it into our waiting bridge:




---

  
  


```

truepy79 wait\_bridge = find\_or\_create\_holding\_bridge()
 wait\_bridge.addChannel(channel=channel.id)

```



---


When the dialed channel answers, we can remove the inbound channel from the waiting bridge - since there is only one waiting bridge being used, we can use `find_or_create_holding_bridge` to obtain it. We then place it into a newly created mixing bridge along with the dialed channel, in the same fashion as the `bridge-dial.py` example.




---

  
  


```

truepy97 print "{} answered; bridging with {}".format(outgoing.json.get('name'),
 channel.json.get('name'))

 wait\_bridge = find\_or\_create\_holding\_bridge()
 wait\_bridge.removeChannel(channel=channel.id)

 bridge = client.bridges.create(type='mixing')
 bridge.addChannel(channel=[channel.id, outgoing.id])



```



---


### bridge-move.py

The full source code for `bridge-move.py` is shown below:




---

  
  


```

truepy#!/usr/bin/env python

import logging
import requests
import ari

logging.basicConfig(level=logging.ERROR)

client = ari.connect('http://localhost:8088', 'asterisk', 'asterisk')

# Our one and only holding bridge
holding\_bridge = None


def find\_or\_create\_holding\_bridge():
 """Find our infinite wait bridge, or create a new one

 Returns:
 The one and only holding bridge
 """
 global holding\_bridge

 if holding\_bridge:
 return holding\_bridge

 bridges = [candidate for candidate in client.bridges.list() if
 candidate.json['bridge\_type'] == 'holding']
 if bridges:
 bridge = bridges[0]
 print "Using bridge {}".format(bridge.id)
 else:
 bridge = client.bridges.create(type='holding')
 bridge.startMoh()
 print "Created bridge {}".format(bridge.id)

 holding\_bridge = bridge
 return holding\_bridge


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

 wait\_bridge = find\_or\_create\_holding\_bridge()
 wait\_bridge.addChannel(channel=channel.id)

 try:
 outgoing = client.channels.originate(endpoint=args[1],
 app='bridge-move',
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

 wait\_bridge = find\_or\_create\_holding\_bridge()
 wait\_bridge.removeChannel(channel=channel.id)

 bridge = client.bridges.create(type='mixing')
 bridge.addChannel(channel=[channel.id, outgoing.id])

 # Clean up the bridge when done
 channel.on\_event('StasisEnd', lambda \*args:
 safe\_bridge\_destroy(bridge))
 outgoing.on\_event('StasisEnd', lambda \*args:
 safe\_bridge\_destroy(bridge))

 outgoing.on\_event('StasisStart', outgoing\_start\_cb)


client.on\_channel\_event('StasisStart', stasis\_start\_cb)

client.run(apps='bridge-move')



```



---


### bridge-move.py in action

The following shows the output of the `bridge-move.py` script when a `PJSIP` channel for `alice` enters the application and dials a PJSIP channel for bob:




---

  
  


```

PJSIP/Alice-00000001 entered our application
Dialing PJSIP/Bob
PJSIP/Bob-00000002 answered; bridging with PJSIP/Alice-00000001
Hung up PJSIP/Bob-00000002

```



---


JavaScript (Node.js)
--------------------

This example is very similar to bridge-dial.js with one main difference: the original Stasis channel is put in a holding bridge while the an originate operation is used to dial another channel. Once the dialed channel enters into the Stasis application, the original channel will be removed from the holding bridge, and both channels will finally be put into a mixing bridge. Once a channel enters into our Stasis application, we either find an existing holding bridge or create one:




---

  
  


```

truejs39function findOrCreateHoldingBridge(channel) {
 client.bridges.list(function(err, bridges) {
 var holdingBridge = bridges.filter(function(candidate) {
 return candidate.bridge\_type === 'holding';
 })[0];

 if (holdingBridge) {
 console.log('Using existing holding bridge %s', holdingBridge.id);

 originate(channel, holdingBridge);
 } else {
 client.bridges.create({type: 'holding'}, function(err, holdingBridge) {
 if (err) {
 throw err;
 }

 console.log('Created new holding bridge %s', holdingBridge.id);

 originate(channel, holdingBridge);
 });
 }
 });
}

```



---


We then add the channel to the holding bridge and start music on hold before continuing with dialing we we did in the bridge-dial.js example:




---

  
  


```

truejs64holdingBridge.addChannel({channel: channel.id}, function(err) {
 if (err) {
 throw err;
 }
 holdingBridge.startMoh(function(err) {
 // ignore error
 });
});

```



---


Once the endpoint has answered and a mixing bridge has been created, we proceed by first removing the original channel from the holding bridge and then adding both channels to the mixing bridge as before:




---

  
  


```

truejs145function moveToMixingBridge(channel, dialed, mixingBridge, holdingBridge) {
 console.log('Adding channel %s and dialed channel %s to bridge %s',
 channel.name, dialed.name, mixingBridge.id);

 holdingBridge.removeChannel({channel: channel.id}, function(err) {
 if (err) {
 throw err;
 }

 mixingBridge.addChannel(
 {channel: [channel.id, dialed.id]}, function(err) {
 if (err) {
 throw err;
 }
 });
 });
}

```



---


Note that we need to keep track of one more variable as we go down the application flow to ensure we have a reference to both the holding and mixing bridge. Again we use anonymous functions to pass extra arguments to callback handlers to keep the nested callbacks to a minimum.

### bridge-move.js

The full source code for `bridge-move.js` is shown below:




---

  
bridge-move.js  


```

truejs /\*jshint node:true\*/
'use strict';

var ari = require('ari-client');
var util = require('util');

// ensure endpoint was passed in to script
if (!process.argv[2]) {
 console.error('usage: node bridge-move.js endpoint');
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

 findOrCreateHoldingBridge(channel);
 });
 }
 }

 function findOrCreateHoldingBridge(channel) {
 client.bridges.list(function(err, bridges) {
 var holdingBridge = bridges.filter(function(candidate) {
 return candidate.bridge\_type === 'holding';
 })[0];

 if (holdingBridge) {
 console.log('Using existing holding bridge %s', holdingBridge.id);

 originate(channel, holdingBridge);
 } else {
 client.bridges.create({type: 'holding'}, function(err, holdingBridge) {
 if (err) {
 throw err;
 }

 console.log('Created new holding bridge %s', holdingBridge.id);

 originate(channel, holdingBridge);
 });
 }
 });
 }

 function originate(channel, holdingBridge) {
 holdingBridge.addChannel({channel: channel.id}, function(err) {
 if (err) {
 throw err;
 }

 holdingBridge.startMoh(function(err) {
 // ignore error
 });
 });

 var dialed = client.Channel();

 channel.on('StasisEnd', function(event, channel) {
 safeHangup(dialed);
 });

 dialed.on('ChannelDestroyed', function(event, dialed) {
 safeHangup(channel);
 });

 dialed.on('StasisStart', function(event, dialed) {
 joinMixingBridge(channel, dialed, holdingBridge);
 });

 dialed.originate(
 {endpoint: process.argv[2], app: 'bridge-move', appArgs: 'dialed'},
 function(err, dialed) {
 if (err) {
 throw err;
 }
 });
 }

 // safely hangs the given channel
 function safeHangup(channel) {
 console.log('Hanging up channel %s', channel.name);

 channel.hangup(function(err) {
 // ignore error
 });
 }

 // handler for dialed channel entering Stasis
 function joinMixingBridge(channel, dialed, holdingBridge) {
 var mixingBridge = client.Bridge();

 dialed.on('StasisEnd', function(event, dialed) {
 dialedExit(dialed, mixingBridge);
 });

 dialed.answer(function(err) {
 if (err) {
 throw err;
 }
 });

 mixingBridge.create({type: 'mixing'}, function(err, mixingBridge) {
 if (err) {
 throw err;
 }

 console.log('Created mixing bridge %s', mixingBridge.id);

 moveToMixingBridge(channel, dialed, mixingBridge, holdingBridge);
 });
 }

 // handler for the dialed channel leaving Stasis
 function dialedExit(dialed, mixingBridge) {
 console.log(
 'Dialed channel %s has left our application, destroying mixing bridge %s',
 dialed.name, mixingBridge.id);

 mixingBridge.destroy(function(err) {
 if (err) {
 throw err;
 }
 });
 }

 // handler for new mixing bridge ready for channels to be added to it
 function moveToMixingBridge(channel, dialed, mixingBridge, holdingBridge) {
 console.log('Adding channel %s and dialed channel %s to bridge %s',
 channel.name, dialed.name, mixingBridge.id);

 holdingBridge.removeChannel({channel: channel.id}, function(err) {
 if (err) {
 throw err;
 }

 mixingBridge.addChannel(
 {channel: [channel.id, dialed.id]}, function(err) {
 if (err) {
 throw err;
 }
 });
 });
 }

 client.on('StasisStart', stasisStart);

 client.start('bridge-move');
}

```



---


### bridge-move.js in action

The following shows the output of the `bridge-move.js` script when a `PJSIP` channel for `alice` enters the application and dials a PJSIP channel for bob:




---

  
  


```

Channel PJSIP/alice-00000001 has entered our application
Created new holding bridge e58641af-2006-4c3d-bf9e-8817baa27381
Created mixing bridge 5ae49fee-e353-4ad9-bfa7-f8306d9dfd1e
Adding channel PJSIP/alice-00000001 and dialed channel PJSIP/bob-00000002 to bridge 5ae49fee-e353-4ad9-bfa7-f8306d9dfd1e
Dialed channel PJSIP/bob-00000002 has left our application, destroying mixing bridge 5ae49fee-e353-4ad9-bfa7-f8306d9dfd1e
Hanging up channel PJSIP/alice-00000001
Hanging up channel undefined

```



---


