---
title: Overview
pageid: 26478450
---

Overview
========

Asterisk 12 introduces the [Asterisk REST Interface](/Asterisk-12-RESTful-API), a set of RESTful APIs for building Asterisk based applications. This article will walk you though getting ARI up and running.

There are three main components to building an ARI application.

The first, obviously, is **the RESTful API** itself. The API is documented using [Swagger](https://developers.helloreverb.com/swagger/), a lightweight specification for documenting RESTful APIs. The Swagger API docs are used to generate validations and boilerplate in Asterisk itself, along with [static wiki documentation](/Asterisk-12-ARI), and interactive documentation using [Swagger-UI](https://github.com/wordnik/swagger-ui).

Then, Asterisk needs to send asynchronous events to the application (new channel, channel left a bridge, channel hung up, etc). This is done using a **WebSocket on /ari/events**. Events are sent as JSON messages, and are documented on the [REST Data Models page](/Asterisk-12-REST-Data-Models). (See the list of subtypes for the [`Message` data model](/Asterisk-12-REST-Data-Models).)

Finally, connecting the dialplan to your application is the  [`Stasis()` dialplan application](/Asterisk-12-Application_Stasis). From within the dialplan, you can send a channel to `Stasis()`, specifying the name of the external application, along with optional arguments to pass along to the application.

40%On This PageExample: ARI Hello World!
=========================

In this example, we will:

* Configure Asterisk to enable ARI
* Send a channel into Stasis
* And playback "Hello World" to the channel

This example will **not** cover:

1. Installing Asterisk. We'll assume you have Asterisk 12 or later installed and running.
2. Configuring a SIP device in Asterisk. For the purposes of this example, we are going to assume you have a SIP softphone or hardphone registered to Asterisk, using either `chan_sip` or `chan_pjsip`.

Getting wscat
-------------

ARI needs a WebSocket connection to receive events. For the sake of this example, we're going to use [wscat](http://einaros.github.io/ws/), an incredibly handy command line utility similar to netcat but based on a node.js websocket library. If you don't have wscat:

1. If you don't have it already, **install** npm




---

  
  


```

bash$ apt-get install npm

```



---
2. **Install** the `ws` node package:




---

  
  


```

bash$ npm install -g wscat

```



---




---

**Tip:**  Some distributions repos (e.g. Ubuntu) may have older versions of nodejs and npm that will throw a wrench in your install of the ws package. You'll have to install a newer version from another repo or via source.

[Installing Nodejs via packages](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager)

[Installing npm in a variety of ways](https://github.com/npm/npm)

  



---


 

Getting curl
------------

In order to control a channel in the Stasis dialplan application through ARI, we also need an HTTP client. For the sake of this example, we'll use [curl](http://linux.about.com/od/commands/l/blcmdl1_curl.htm):




---

  
  


```

bash$ apt-get install curl

```



---


Configuring Asterisk
--------------------

1. Enable the Asterisk HTTP service in `http.conf`:




---

  
http.conf  


```

truetext[general]
enabled = yes
bindaddr = 0.0.0.0

```



---
2. Configure an ARI user in `ari.conf`:




---

  
ari.conf  


```

truetext[general]
enabled = yes 
pretty = yes 

[asterisk]
type = user
read\_only = no
password = asterisk

```



---




---

**WARNING!: This is just a demo**  
Please use a more secure account user and password for production applications. Outside of examples and demos, asterisk/asterisk is a terrible, horrible, no-good choice...

  



---
3. Create a dialplan extension for your Stasis application. Here, we're choosing extension `1000` in context `default` - if your SIP phone is configured for a different context, adjust accordingly.




---

  
extensions.conf  


```

truetext[default]

exten => 1000,1,NoOp()
 same => n,Answer()
 same => n,Stasis(hello-world)
 same => n,Hangup()

```



---

Hello World!
------------

1. Connect to Asterisk using `wscat`:




---

  
  


```

bash$ wscat -c "ws://localhost:8088/ari/events?api\_key=asterisk:asterisk&app=hello-world"
connected (press CTRL+C to quit)
>

```



---


In Asterisk, we should see a new WebSocket connection and a message telling us that our Stasis application has been created:




---

  
  


```

text == WebSocket connection from '127.0.0.1:37872' for protocol '' accepted using version '13'
 Creating Stasis app 'hello-world'

```



---
2. From your SIP device, dial extension 1000:




---

  
  


```

text  -- Executing [1000@default:1] NoOp("PJSIP/1000-00000001", "") in new stack
 -- Executing [1000@default:2] Answer("PJSIP/1000-00000001", "") in new stack
 -- PJSIP/1000-00000001 answered
 -- Executing [1000@default:3] Stasis("PJSIP/1000-00000001", "hello-world") in new stack

```



---


In wscat, we should see the `StasisStart` event, indicating that a channel has entered into our Stasis application:




---

  
  


```

js< {
 "application":"hello-world",
 "type":"StasisStart",
 "timestamp":"2014-05-20T13:15:27.131-0500",
 "args":[],
 "channel":{
 "id":"1400609726.3",
 "state":"Up",
 "name":"PJSIP/1000-00000001",
 "caller":{
 "name":"",
 "number":""},
 "connected":{
 "name":"",
 "number":""},
 "accountcode":"",
 "dialplan":{
 "context":"default",
 "exten":"1000",
 "priority":3},
 "creationtime":"2014-05-20T13:15:26.628-0500"}
 }
>  

```



---
3. Using `curl`, tell Asterisk to playback `hello-world`. Note that the identifier of the channel in the `channels` resource **must** match the channel `id` passed back in the `StasisStart` event:




---

  
  


```

bash$ curl -v -u asterisk:asterisk -X POST "http://localhost:8088/ari/channels/1400609726.3/play?media=sound:hello-world"

```



---


The response to our HTTP request will tell us whether or not the request succeeded or failed (in our case, a success will queue the playback onto the channel), as well as return in JSON the Playback resource that was created for the operation:




---

  
  


```

text\* About to connect() to localhost port 8088 (#0)
\* Trying 127.0.0.1... connected
\* Server auth using Basic with user 'asterisk'
> POST /ari/channels/1400609726.3/play?media=sound:hello-world HTTP/1.1
> Authorization: Basic YXN0ZXJpc2s6c2VjcmV0
> User-Agent: curl/7.22.0 (x86\_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3
> Host: localhost:8088
> Accept: \*/\*
> 
< HTTP/1.1 201 Created
< Server: Asterisk/SVN-branch-12-r414137M
< Date: Tue, 20 May 2014 18:25:15 GMT
< Connection: close
< Cache-Control: no-cache, no-store
< Content-Length: 146
< Location: /playback/9567ea46-440f-41be-a044-6ecc8100730a
< Content-type: application/json
< 
\* Closing connection #0
{"id":"9567ea46-440f-41be-a044-6ecc8100730a",
 "media\_uri":"sound:hello-world",
 "target\_uri":"channel:1400609726.3",
 "language":"en",
 "state":"queued"}

$

```



---


In Asterisk, the sound file will be played back to the channel:




---

  
  


```

text -- <PJSIP/1000-00000001> Playing 'hello-world.gsm' (language 'en') 

```



---


And in our `wscat` WebSocket connection, we'll be informed of the start of the playback, as well as it finishing:




---

  
  


```

js< {"application":"hello-world",
 "type":"PlaybackStarted",
 "playback":{
 "id":"9567ea46-440f-41be-a044-6ecc8100730a",
 "media\_uri":"sound:hello-world",
 "target\_uri":"channel:1400609726.3",
 "language":"en",
 "state":"playing"}
 }

< {"application":"hello-world",
 "type":"PlaybackFinished",
 "playback":{
 "id":"9567ea46-440f-41be-a044-6ecc8100730a",
 "media\_uri":"sound:hello-world",
 "target\_uri":"channel:1400609726.3",
 "language":"en",
 "state":"done"}
 }

```



---
4. Hang up the phone! This will cause the channel in Asterisk to be hung up, and the channel will leave the Stasis application, notifying the client via a `StasisEnd` event:




---

  
  


```

js < {"application":"hello-world",
 "type":"StasisEnd",
 "timestamp":"2014-05-20T13:30:01.852-0500",
 "channel":{
 "id":"1400609726.3",
 "state":"Up",
 "name":"PJSIP/1000-00000001",
 "caller":{
 "name":"",
 "number":""},
 "connected":{
 "name":"",
 "number":""},
 "accountcode":"",
 "dialplan":{
 "context":"default",
 "exten":"1000",
 "priority":3},
 "creationtime":"2014-05-20T13:15:26.628-0500"}
 }

```



---

 

 

