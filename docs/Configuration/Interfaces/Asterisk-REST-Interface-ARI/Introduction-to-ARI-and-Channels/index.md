---
title: Overview
pageid: 29395597
---

Channels: An Overview
=====================

In Asterisk, a channel is a patch of communication between some endpoint and Asterisk itself. The path of communication encompasses all information passed to and from the endpoint. That includes both the signalling (such as "change the state of the device to ringing" or "hangup this call") as well as media (the actual audio or video being sent/received to/from the endpoint).

When a channel is created in Asterisk to represent this path of communication, Asterisk assigns it both a **UniqueID** - which acts as a handle to the channel for its entire lifetime - as well as a unique **Name**. The UniqueID can be any globally unique identifier provided by the ARI client. If the ARI client does not provide a UniqueID to the channel, then Asterisk will assign one to the channel itself. By default, it uses an epoch timestamp with a monotonically increasing integer, optionally along with the Asterisk system name.

Channels to Endpoints
---------------------

The channel name consists of two parts: the type of channel being created, along with a descriptive identifier determined by the channel type. What channel types are available depends on how the Asterisk system is configured; for the purposes of most examples, we will use "PJSIP" channels to communicate with SIP devices.

![](ARI-Asterisk-channel-to-endpoint.png)

In the above diagram, Alice's SIP device has called into Asterisk, and Asterisk has assigned the resulting channel a UniqueID of **Asterisk01-123456789.1**, while the PJSIP channel driver has assigned a name of **PJSIP/Alice-00000001**. In order to manipulate this channel, ARI operations would use the UniqueID Asterisk01-123456789.1 as the handle to the channel.

40%On This PageChannels In DepthInternal Channels - Local Channels
----------------------------------

While most channels are between some external endpoint and Asterisk, Asterisk can also create channels that are completely internal within itself. These channels - called **Local** channels - help to move media between various resources within Asterisk.

Local channel are special in that Local channels always come in pairs of channels. Creating a single Local "channel" will *always* result in two channels being created in Asterisk. Sitting between the Local channel pairs is a special virtual endpoint that forwards media back and forth between the two Local channel pairs. One end of each Local channel is permanently tied to this virtual endpoint and cannot be moved about - however, the other end of each Local channel can be manipulated in any fashion. All media that enters into one of the Local channel halves is passed out through the other Local channel half, and vice versa.

![](ARI-Asterisk-Local-Channels.png)

In the above diagram, ARI has created a Local channel, `Local/myapp@default`. As a result, Asterisk has created a pair of Local channels with the UniqueIDs of **Asterisk01-123456790.1** and **Asterisk01-123456790.2**. The names of the Local channel halves are **Local/myapp@default-00000000;1** and **Local/myapp@default-00000000;2** - where the ;1 and ;2 denote the two halves of the Local channel.

Channels in a Stasis Application
================================

When a channel is created in Asterisk, it begins to execute dialplan. All channels enter into the dialplan at some location defined by a **context/extension/priority** tuple. Each tuple location in the dialplan defines some Asterisk application that the channel should go execute. When the application completes, the priority in the tuple is increased by one, and the next location in the dialplan is executed. This continues until the dialplan runs out of things to execute, the dialplan application tells the channel to hangup, or until the device itself hangs up.

Channels are handed over to ARI through the [Stasis](/Asterisk-12-Application_Stasis) dialplan application. This special application takes control of the channel from the dialplan, and indicates to an ARI client with a connected websocket that a channel is now ready to be controlled. When this occurs, a [StasisStart](/Asterisk+12+REST+Data+Models#Asterisk12RESTDataModels-StasisStart) event is emitted; when the channel leaves the Stasis dialplan application - either because it was told to leave or because the device hung up - a [StasisEnd](/Asterisk+12+REST+Data+Models#Asterisk12RESTDataModels-StasisEnd) event is emitted. When the StasisEnd event is emitted, ARI no longer controls the channel and the channel is handed back over to the dialplan.

Resources in Asterisk do not, by default, send events about themselves to a connected ARI application. In order to get events about resources, one of three things must occur:

1. The resource must be a channel that entered into a Stasis dialplan application. A subscription is implicitly created in this case. The subscription is implicitly destroyed when the channel leaves the Stasis dialplan application.
2. While a channel is in a Stasis dialplan application, the channel may interact with other resources - such as a [bridge](/Asterisk+12+REST+Data+Models#Asterisk12RESTDataModels-Bridge). While channels interact with the resource, a subscription is made to that resource. When no more channels in a Stasis dialplan application are interacting with the resource, the implicit subscription is destroyed.
3. At any time, an ARI application may make a subscription to a resource in Asterisk through [application](/Asterisk-12-Applications-REST-API) operations. While that resource exists, the ARI application owns the subscription.

Example: Interacting with Channels
==================================

For this example, we're going to write an ARI application that will do the following:

1. When it connects, it will print out the names of all existing channels. If there are no existing channels, it will tell us that as well.
2. When a channel enters into its Stasis application, it will print out all of the specific information about that channel.
3. When a channel leaves its Stasis application, it will print out that the channel has left.

Dialplan
--------

The dialplan for this will be very straight forward: a simple extension that drops a channel into Stasis.




---

  
extensions.conf  


```

truetext[default]

exten => 1000,1,NoOp()
 same => n,Answer()
 same => n,Stasis(channel-dump)
 same => n,Hangup()

```



---


Python
------




For our Python examples, we will rely primarily on the [ari-py](https://github.com/asterisk/ari-py) library. Because the `ari` library will emit useful information using Python logging, we should go ahead and set that up as well - for now, a `basicConfig` with `ERROR` messages displayed should be sufficient. Finally, we'll need to get a client made by initiating a connection to Asterisk. This occurs using the `ari.connect` method, where we have to specify three things:

1. The HTTP base URI of the Asterisk server to connect to. Here, we assume that this is running on the same machine as the script, and that we're using the default port for Asterisk's HTTP server - `8088`.
2. The username of the ARI user account to connect as. In this case, we're specifying it as `asterisk`.
3. The password for the ARI user account. In this case, that's asterisk.




---

**Tip:**  Modify the connection credentials as appropriate for your server, although many examples will use these credentials.

**Please don't use these credentials in production systems!**

  



---




---

  
  


```

truepy #!/usr/bin/env python

import ari
import logging

logging.basicConfig(level=logging.ERROR)

client = ari.connect('http://localhost:8088', 'asterisk', 'asterisk')

```



---


Once we've made our connection, our first task is to print out all existing channels or - if there are no channels - print out that there are no channels. The `channels` resource has an operation for this - `GET /channels`. Since the `ari-py` library will dynamically construct operations on objects that map to resource calls using the nickname of an operation, we can use the `list` method on the `channels` resource to get all current channels in Asterisk:




---

  
  


```

truepy10current\_channels = client.channels.list()
if (len(current\_channels) == 0):
 print "No channels currently :-("
else:
 print "Current channels:"
 for channel in current\_channels:
 print channel.json.get('name') 

```



---


The `GET /channels` operation returns back a list of `Channel` resources. Those resources, however, are returned as JSON from the operation, and while the `ari-py` library converts the `uniqueid` of those into an attribute on the object, it leaves the rest of them in the JSON dictionary. Since what we want is the name, we can just extract it ourselves out of the JSON and print it out.

Our next step involves a bit more - we want to print out all the information about a channel when it enters into our Stasis dialplan application "channel-dump" and print the channel name when it leaves. To do that, we need to subscribe for the `StasisStart` and `StasisEnd` events:




---

  
  


```

truepy32client.on\_channel\_event('StasisStart', stasis\_start\_cb)
client.on\_channel\_event('StasisEnd', stasis\_end\_cb) 

```



---


We need two handler functions - `stasis_start_cb` for the `StasisStart` event and `stasis_end_cb` for the `StasisEnd` event:




---

  
  


```

truepy18def stasis\_start\_cb(channel\_obj, ev):
 """Handler for StasisStart event"""

 channel = channel\_obj.get('channel')
 print "Channel %s has entered the application" % channel.json.get('name')

 for key, value in channel.json.items():
 print "%s: %s" % (key, value)

def stasis\_end\_cb(channel, ev):
 """Handler for StasisEnd event"""

 print "%s has left the application" % channel.json.get('name')

```



---


Finally, we need to tell the `client` to run our application. Once we call `client.run`, the websocket connection will be made and our application will wait on events infinitely. We can use `Ctrl+C` to kill it and break the connection.




---

  
  


```

truepy35client.run(apps='channel-dump') 

```



---


### channel-dump.py

The full source code for `channel-dump.py` is shown below:




---

  
channel-dump.py  


```

truepy#!/usr/bin/env python

import ari
import logging

logging.basicConfig(level=logging.ERROR)

client = ari.connect('http://localhost:8088', 'asterisk', 'asterisk')

current\_channels = client.channels.list()
if (len(current\_channels) == 0):
 print "No channels currently :-("
else:
 print "Current channels:"
 for channel in current\_channels:
 print channel.json.get('name')

def stasis\_start\_cb(channel\_obj, ev):
 """Handler for StasisStart event"""

 channel = channel\_obj.get('channel')
 print "Channel %s has entered the application" % channel.json.get('name')

 for key, value in channel.json.items():
 print "%s: %s" % (key, value)

def stasis\_end\_cb(channel, ev):
 """Handler for StasisEnd event"""

 print "%s has left the application" % channel.json.get('name')

client.on\_channel\_event('StasisStart', stasis\_start\_cb)
client.on\_channel\_event('StasisEnd', stasis\_end\_cb)

client.run(apps='channel-dump')



```



---


### channel-dump.py in action

Here's sample output from `channel-dump.py`. When it first connects there are no channels in Asterisk -  - but afterwards a PJSIP channel from Alice enters into extension 1000. This prints out all the information about her channels. After hearing silence for awhile, she hangs up - and our script notifies us that her channel has left the application.




---

  
  


```

bashasterisk:~$ python channel-dump.py
No channels currently :-(
Channel PJSIP/alice-00000001 has entered the application
accountcode: 
name: PJSIP/alice-00000001
caller: {u'Alice': u'', u'6575309': u''}
creationtime: 2014-06-09T17:36:31.698-0500
state: Up
connected: {u'name': u'', u'number': u''}
dialplan: {u'priority': 3, u'exten': u'1000', u'context': u'default'}
id: asterisk-01-1402353503.1
PJSIP/alice-00000001 has left the application

```



---


JavaScript (Node.js)
--------------------

For our JavaScript examples, we will rely primarily on the Node.js [ari-client](https://github.com/asterisk/node-ari-client) library. We'll need to get a client made by initiating a connection to Asterisk. This occurs using the `ari.connect` method, where we have to specify four things:

1. The HTTP base URI of the Asterisk server to connect to. Here, we assume that this is running on the same machine as the script, and that we're using the default port for Asterisk's HTTP server - `8088`.
2. The username of the ARI user account to connect as. In this case, we're specifying it as `asterisk`.
3. The password for the ARI user account. In this case, that's asterisk.
4. A callback that will be called with an error if one occurred, followed by an instance of an ARI client.




---

**Tip:**  Modify the connection credentials as appropriate for your server, although many examples will use these credentials.

**Please don't use these credentials in production systems!**

  



---




---

  
  


```

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
}

```



---


Once we've made our connection, our first task is to print out all existing channels or - if there are no channels - print out that there are no channels. The `channels` resource has an operation for this - `GET /channels`. Since the `ari-client` library will dynamically construct a client with operations on objects that map to resource calls using the nickname of an operation, we can use the `list` method on the `channels` resource to get all current channels in Asterisk:




---

  
  


```

truejs15client.channels.list(function(err, channels) {
 if (!channels.length) {
 console.log('No channels currently :-(');
 } else {
 console.log('Current channels:');
 channels.forEach(function(channel) {
 console.log(channel.name);
 });
 }
});

```



---


The `GET /channels` operation expects a callback that will be called with an error if one occurred and a list of `Channel` resources. `ari-client` will return a JavaScript object for each `Channel` resource. Properties such as `name` can be accessed on the object directly.

Our next step involves a bit more - we want to print out all the information about a channel when it enters into our Stasis dialplan application "channel-dump" and print the channel name when it leaves. To do that, we need to subscribe for the `StasisStart` and `StasisEnd` events:




---

  
  


```

truejs43client.on('StasisStart', stasisStart);
client.on('StasisEnd', stasisEnd);

```



---


We need two callback functions - `stasisStart` for the `StasisStart` event and `stasisEnd` for the `StasisEnd` event:




---

  
  


```

truejs26// handler for StasisStart event
function stasisStart(event, channel) {
 console.log(util.format(
 'Channel %s has entered the application', channel.name));
 // use keys on event since channel will also contain channel operations
 Object.keys(event.channel).forEach(function(key) {
 console.log(util.format('%s: %s', key, JSON.stringify(channel[key])));
 });
}
// handler for StasisEnd event
function stasisEnd(event, channel) {
 console.log(util.format(
 'Channel %s has left the application', channel.name));
}

```



---


Finally, we need to tell the `client` to start our application. Once we call `client.start`, a websocket connection will be established and the client will emit Node.js events as events come in through the websocket. We can use `Ctrl+C` to kill it and break the connection.




---

  
  


```

truejs46client.start('channel-dump');

```



---


### channel-dump.js

The full source code for `channel-dump.js` is shown below:




---

  
  


```

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

 client.channels.list(function(err, channels) {
 if (!channels.length) {
 console.log('No channels currently :-(');
 } else {
 console.log('Current channels:');
 channels.forEach(function(channel) {
 console.log(channel.name);
 });
 }
 });

 // handler for StasisStart event
 function stasisStart(event, channel) {
 console.log(util.format(
 'Channel %s has entered the application', channel.name));

 // use keys on event since channel will also contain channel operations
 Object.keys(event.channel).forEach(function(key) {
 console.log(util.format('%s: %s', key, JSON.stringify(channel[key])));
 });
 }

 // handler for StasisEnd event
 function stasisEnd(event, channel) {
 console.log(util.format(
 'Channel %s has left the application', channel.name));
 }

 client.on('StasisStart', stasisStart);
 client.on('StasisEnd', stasisEnd);

 client.start('channel-dump');
}

```



---


### channel-dump.js in action

Here's sample output from `channel-dump.js`. When it first connects there are no channels in Asterisk -  - but afterwards a PJSIP channel from Alice enters into extension 1000. This prints out all the information about her channels. After hearing silence for a while, she hangs up - and our script notifies us that her channel has left the application.




---

  
  


```

truebashasterisk:~$ node channel-dump.js
No channels currently :-(
Channel PJSIP/alice-00000001 has entered the application
accountcode: 
name: PJSIP/alice-00000001
caller: {u'Alice': u'', u'6575309': u''}
creationtime: 2014-06-09T17:36:31.698-0500
state: Up
connected: {u'name': u'', u'number': u''}
dialplan: {u'priority': 3, u'exten': u'1000', u'context': u'default'}
id: asterisk-01-1402353503.1
PJSIP/alice-00000001 has left the application

```



---


