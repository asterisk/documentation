---
title: Overview
pageid: 29396210
---

Asterisk Bridges
================

In Asterisk, bridges can be thought of as a container for channels that form paths of communication between the channels contained within them. They can be used to pass media back and forth between the channels, as well as to play media to the various channels in a variety of ways.

More InformationFor more information on bridges in Asterisk, see .

Bridges in a Stasis Application
===============================

Bridge Types
------------

When a bridge is created through ARI, there are a number of attributes that can be specified that determine how the bridge mixes media between its participants. These include:

* `mixing` - specify that media should be passed between all channels in the bridge. This attribute cannot be used with `holding`.
* `dtmf_events` - specify that media should be decoded within Asterisk so that DTMF can be recognized. If this is not specified, then DTMF events may not be raised due to the media being passed directly between the channels in the bridge. This attribute only impacts how media is mixed when the `mixing` attribute is used.
* `proxy_media` - specify that media should always go through Asterisk, even if it could be redirected between clients. This attribute only impacts how media is mixed when the `mixing` attribute is used.
On This PageBridges in Depth* `holding` - specify that the channels in the bridge should be entertained with some media. Channels in the bridge have two possible roles: a participant or an announcer. Media between participant channels is not shared; media from an announcer channel is played to all participant channels.

Depending on the combination of attributes selected when a bridge is created, different mixing technologies may be used for the participants in the bridge. Asterisk will attempt to use the most performant mixing technology that it can based on the channel types in the bridge, subject to the attributes specified when the bridge was created.

Subscription Model
------------------

Unlike channels, bridges in a Stasis application are not automatically subscribed to for events. In order to receive events concerning events for a given bridge, the [applications](https://wiki.asterisk.org/wiki/display/AST/Asterisk+12+Applications+REST+API) resource must be used to subscribe to the bridge via the `POST - /applications/{app_name}/subscription` operation. Events related to channels entering and leaving bridges will be sent without the need to subscribe to them since they are related to a channel in a Stasis application.

Example: Interacting with Bridges
=================================

For this example, we're going to write an ARI application that will do the following:

1. When it connects, it will print out the names of all existing holding bridges. If there are no existing holding bridges, it will create one.
2. When a channel enters into its Stasis application, it will be added to the holding bridge and music on hold will be started on the bridge.

Dialplan
--------

The dialplan for this will be very straight forward: a simple extension that drops a channel into Stasis.

extensions.conftruetext[default]

exten => 1000,1,NoOp()
 same => n,Answer()
 same => n,Stasis(bridge-hold)
 same => n,Hangup()Python
------

For our Python examples, we will rely primarily on the [ari-py](https://github.com/asterisk/ari-py) library. Because the `ari` library will emit useful information using Python logging, we should go ahead and set that up as well - for now, a `basicConfig` with `ERROR` messages displayed should be sufficient. Finally, we'll need to get a client made by initiating a connection to Asterisk. This occurs using the `ari.connect` method, where we have to specify three things:

1. The HTTP base URI of the Asterisk server to connect to. Here, we assume that this is running on the same machine as the script, and that we're using the default port for Asterisk's HTTP server - `8088`.
2. The username of the ARI user account to connect as. In this case, we're specifying it as `asterisk`.
3. The password for the ARI user account. In this case, that's asterisk.

Modify the connection credentials as appropriate for your server, although many examples will use these credentials.

**Please don't use these credentials in production systems!**

truepy#!/usr/bin/env python

import ari
import logging
 
logging.basicConfig(level=logging.ERROR)
 
client = ari.connect('http://localhost:8088', 'asterisk', 'asterisk')Once we've made our connection, our first task is to look for an existing holding bridge - if there is no existing holding bridge - we need to create it. The bridges resource has an operation for listing existing bridges - `GET /bridges`. Using ari-py we need to use the operation nickname - `list`. We can then use another bridges resource operation to create a holding bridge if none was found - `POST /bridges`. Using ari-py, we need to use the operation nickname - `create`.

truepy10# find or create a holding bridge
bridges = [candidate for candidate in client.bridges.list() if
 candidate.json['bridge\_type'] == 'holding']
if bridges:
 bridge = bridges[0]
 print "Using bridge %s" % bridge.id
else:
 bridge = client.bridges.create(type='holding')
 print "Created bridge %s" % bridge.idThe `GET /channels` operation returns back a list of `Bridge` resources. Those resources, however, are returned as JSON from the operation, and while the `ari-py` library converts the `uniqueid` of those into an attribute on the object, it leaves the rest of them in the JSON dictionary.

Our next step involves adding channels that enter our Stasis application to the bridge we either found or created and signaling when a channel leaves our Stasis application. To do that, we need to subscribe for the `StasisStart` and `StasisEnd` events:

truepy36client.on\_channel\_event('StasisStart', stasis\_start\_cb)
client.on\_channel\_event('StasisEnd', stasis\_end\_cb)We need two handler functions - `stasis_start_cb` for the `StasisStart` event and `stasis_end_cb` for the `StasisEnd` event:

truepy20def stasis\_start\_cb(channel\_obj, ev):
 """Handler for StasisStart event"""

 channel = channel\_obj.get('channel')
 print "Channel %s just entered our application, adding it to bridge %s" % (
 channel.json.get('name'), bridge.id)
 channel.answer()
 bridge.addChannel(channel=channel.id)
 bridge.startMoh()

def stasis\_end\_cb(channel, ev):
 """Handler for StasisEnd event"""

 print "Channel %s just left our application" % channel.json.get('name')Finally, we need to tell the `client` to run our application. Once we call `client.run`, the websocket connection will be made and our application will wait on events infinitely. We can use `Ctrl+C` to kill it and break the connection.

truepy39client.run(apps='bridge-hold')### bridge-hold.py

The full source code for `bridge-hold.py` is shown below:

truepy#!/usr/bin/env python

import ari
import logging

logging.basicConfig(level=logging.ERROR)

client = ari.connect('http://localhost:8088', 'asterisk', 'asterisk')

# find or create a holding bridge
bridges = [candidate for candidate in client.bridges.list() if
 candidate.json['bridge\_type'] == 'holding']
if bridges:
 bridge = bridges[0]
 print "Using bridge %s" % bridge.id
else:
 bridge = client.bridges.create(type='holding')
 print "Created bridge %s" % bridge.id

def stasis\_start\_cb(channel\_obj, ev):
 """Handler for StasisStart event"""

 channel = channel\_obj.get('channel')
 print "Channel %s just entered our application, adding it to bridge %s" % (
 channel.json.get('name'), bridge.id)

 channel.answer()
 bridge.addChannel(channel=channel.id)
 bridge.startMoh()

def stasis\_end\_cb(channel, ev):
 """Handler for StasisEnd event"""

 print "Channel %s just left our application" % channel.json.get('name')

client.on\_channel\_event('StasisStart', stasis\_start\_cb)
client.on\_channel\_event('StasisEnd', stasis\_end\_cb)

client.run(apps='bridge-hold') 

### bridge-hold.py in action

Here, we see the output from the `bridge-hold.py` script when a PJSIP channel for endpoint 'alice' enters into the application:

truebashasterisk:~$ python bridge-hold.py
Created bridge 79f3ad78-b124-4d7b-a629-a53b7e7f50cd
Channel PJSIP/alice-00000001 just entered our application, adding it to bridge 79f3ad78-b124-4d7b-a629-a53b7e7f50cd
Channel PJSIP/alice-00000001 just left our application 

JavaScript (Node.js)
--------------------

For our JavaScript examples, we will rely primarily on the Node.js [ari-client](https://github.com/asterisk/node-ari-client) library. We'll need to get a client made by initiating a connection to Asterisk. This occurs using the `ari.connect` method, where we have to specify four things:

1. The HTTP base URI of the Asterisk server to connect to. Here, we assume that this is running on the same machine as the script, and that we're using the default port for Asterisk's HTTP server - `8088`.
2. The username of the ARI user account to connect as. In this case, we're specifying it as `asterisk`.
3. The password for the ARI user account. In this case, that's asterisk.
4. A callback that will be called with an error if one occurred, followed by an instance of an ARI client.

Modify the connection credentials as appropriate for your server, although many examples will use these credentials.

**Please don't use these credentials in production systems!**

truejs/\*jshint node:true\*/
'use strict';

var ari = require('ari-client');
var util = require('util');

ari.connect('http://localhost:8088', 'asterisk', 'asterisk', clientLoaded);

// handler for client being loaded
function clientLoaded (err, client) {
 if (err) {
 throw err;
 }
}Once we've made our connection, our first task is to look for an existing holding bridge - if there is no existing holding bridge - we need to create it. The bridges resource has an operation for listing existing bridges - `GET /bridges`. Using ari-client we need to use the operation nickname - `list`. We can then use another bridges resource operation to create a holding bridge if none was found - `POST /bridges`. Using ari-client, we need to use the operation nickname - `create`.

truejs15// find or create a holding bridge
var bridge = null;
client.bridges.list(function(err, bridges) {
 if (err) {
 throw err;
 }
 bridge = bridges.filter(function(candidate) {
 return candidate.bridge\_type === 'holding';
 })[0];
 if (bridge) {
 console.log(util.format('Using bridge %s', bridge.id));
 } else {
 client.bridges.create({type: 'holding'}, function(err, newBridge) {
 if (err) {
 throw err;
 }
 bridge = newBridge;
 console.log(util.format('Created bridge %s', bridge.id));
 });
 }
});The `GET /channels` operation returns back a an error if it occurred and a list of `Bridge` resources. `ari-client` will return a JavaScript object for each `Bridge` resource. Properties such as `bridge_type` can be accessed on the object directly.

Our next step involves adding channels that enter our Stasis application to the bridge we either found or created and signaling when a channel leaves our Stasis application. To do that, we need to subscribe for the `StasisStart` and `StasisEnd` events:

truejs72client.on('StasisStart', stasisStart);
client.on('StasisEnd', stasisEnd);We need two callback functions - `stasisStart` for the `StasisStart` event and `stasisEnd` for the `StasisEnd` event:

truejs40// handler for StasisStart event
function stasisStart(event, channel) {
 console.log(util.format(
 'Channel %s just entered our application, adding it to bridge %s',
 channel.name,
 bridge.id));

 channel.answer(function(err) {
 if (err) {
 throw err;
 }

 bridge.addChannel({channel: channel.id}, function(err) {
 if (err) {
 throw err;
 }

 bridge.startMoh(function(err) {
 if (err) {
 throw err;
 }
 });
 });
 });
}

// handler for StasisEnd event
function stasisEnd(event, channel) {
 console.log(util.format(
 'Channel %s just left our application', channel.name));
} Finally, we need to tell the `client` to start our application. Once we call `client.start`, a websocket connection will be established and the client will emit Node.js events as events come in through the websocket. We can use `Ctrl+C` to kill it and break the connection.

truejs75client.start('bridge-hold');### bridge-hold.js

The full source code for `bridge-hold.js` is shown below:

truejs/\*jshint node:true\*/
'use strict';

var ari = require('ari-client');
var util = require('util');

ari.connect('http://localhost:8088', 'asterisk', 'asterisk', clientLoaded);

// handler for client being loaded
function clientLoaded (err, client) {
 if (err) {
 throw err;
 }

 // find or create a holding bridge
 var bridge = null;
 client.bridges.list(function(err, bridges) {
 if (err) {
 throw err;
 }

 bridge = bridges.filter(function(candidate) {
 return candidate.bridge\_type === 'holding';
 })[0];

 if (bridge) {
 console.log(util.format('Using bridge %s', bridge.id));
 } else {
 client.bridges.create({type: 'holding'}, function(err, newBridge) {
 if (err) {
 throw err;
 }

 bridge = newBridge;
 console.log(util.format('Created bridge %s', bridge.id));
 });
 }
 });

 // handler for StasisStart event
 function stasisStart(event, channel) {
 console.log(util.format(
 'Channel %s just entered our application, adding it to bridge %s',
 channel.name,
 bridge.id));

 channel.answer(function(err) {
 if (err) {
 throw err;
 }

 bridge.addChannel({channel: channel.id}, function(err) {
 if (err) {
 throw err;
 }

 bridge.startMoh(function(err) {
 if (err) {
 throw err;
 }
 });
 });
 });
 }

 // handler for StasisEnd event
 function stasisEnd(event, channel) {
 console.log(util.format(
 'Channel %s just left our application', channel.name));
 }

 client.on('StasisStart', stasisStart);
 client.on('StasisEnd', stasisEnd);

 client.start('bridge-hold');
}### bridge-hold.js in action

Here, we see the output from the `bridge-hold.js` script when a PJSIP channel for endpoint 'alice' enters into the application:

truebashasterisk:~$ node bridge-hold.js
Created bridge 41208316-174c-4e40-90bb-c45cca6579d4
Channel PJSIP/alice-00000001 just entered our application, adding it to bridge 41208316-174c-4e40-90bb-c45cca6579d4
Channel PJSIP/alice-00000001 just left our application