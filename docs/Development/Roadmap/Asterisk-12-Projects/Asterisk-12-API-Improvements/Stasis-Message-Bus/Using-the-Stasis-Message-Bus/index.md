---
title: Overview
pageid: 23756837
---

In Asterisk 12, we introduced the Stasis project, and new set of API's throughout Asterisk to make developing with Asterisk easier at all levels. Not only does this includes a reworking of the existing AMI interface, and the addition of a simpler RESTful HTTP interface, but there are a new set of API's within Asterisk itself, making it easier to integrate new modules within Asterisk.

At the lowest level is the [Stasis Message Bus](http://doxygen.asterisk.org/trunk/stasis.html), a publish-subscribe message bus allowing for asynchronous message delivery within Asterisk. The purpose of this page is to take you through the basics of using the Stasis Message Bus to integrate a new module within Asterisk.

Background Information
======================

There is already a fair amount of documentation about the Stasis Message Bus already available. The API's themselves are documented using Doxygen. There's also a [design document](/Development/Roadmap/Asterisk-12-Projects/Asterisk-12-API-Improvements/Stasis-Message-Bus) on wiki.asterisk.org describing the overall design of the Stasis Message Bus. These provide some good in-depth information on the different pieces of the Stasis Message Bus.

Walking Through an Example
==========================

Sometimes, though, it's best to see something in action. Probably the best example of a simply usage of the message bus can be found in [res\_chan\_stats.so](https://code.asterisk.org/code/browse/asterisk/trunk/res/res_chan_stats.c?hb=true). This is a module that subscribes to the [ast\_channel\_topic\_all()](http://doxygen.asterisk.org/trunk/df/deb/group__StasisTopicsAndMessages.html#g34a3ac59fb8d0c49cbc2cb9b87261d31) and posts some interesting statistics using [a simple Statsd API](http://doxygen.asterisk.org/trunk/d4/d67/statsd_8h.html).

Plain subscriptions
-------------------

A regular subscription is Stasis is created by using the [stasis\_subscribe()](http://doxygen.asterisk.org/trunk/dd/d79/stasis_8h.html#0f22205d00ef47310681da71d082017b) function. You provide the topic, a callback function, and a piece of data you wish to come along with the callback, and the message bus does the rest.

 




---

  
  


```

static void statsmaker(void \*data, struct stasis\_subscription \*sub,
 struct stasis\_topic \*topic, struct stasis\_message \*message)
{
 /\* ... \*/
}
 
static int load\_module(void)
{
 /\* ... \*/
 sub = stasis\_subscribe(ast\_channel\_topic\_all(), statsmaker, NULL);
 if (!sub) {
 return AST\_MODULE\_LOAD\_FAILURE;
 }
 return AST\_MODULE\_LOAD\_SUCCESS;
}


static int unload\_module(void)
{
 stasis\_unsubscribe(sub);
 sub = NULL;
 /\* ... \*/
 return 0;
}

```



---


For every message that's published to the `ast_channel_topic_all()` topic, the `statsmake()` callback will be invoked with the data pointer given in the subscription, the subscription being dispatched, the topic the message was originally published to (useful when messages are forwarded between topics), and, finally, the message itself.

You have some really strong guarantees about how the messages get dispatched to your callback.

* **Messages have a type** - the [stasis\_message\_type()](http://doxygen.asterisk.org/trunk/d2/db9/stasis__message_8c.html#9356e8a29344ca4eac93088198ccff89) function gives you the type of the message you've received.
* **Messages are ordered** - Messages are dispatched to your callback in the same order in which they were published.
* **Dispatches are serialized** - The next message dispatch won't occur until after the current message dispatch completes. In many situations this greatly simplifies threading concerns, and can eliminate deadlocks, or even the need for locking, altogether.
* **Messages are immutable** - Actually, this is more of a rule of the system than a guarantee by it. Messages should be treated as immutable. If you feel the temptation to modify a message you receive, you should instead copy the message and modify the copy.
* **Messages are ref-counted** - Because messages are immutable and ref-counted, you can very cheaply keep references to a message for later use. When you're done with the message, simply call [ao2\_cleanup()](http://doxygen.asterisk.org/trunk/d5/da5/astobj2_8h.html#6321ee982370c55ab3c24c72c562cbdd). The object will be destroyed and memory will be freed when all referrers are done with it.

### What a subscription handler looks like

The bulk of the subscription callback will be whatever logic you need to process the incoming messages. But there is one caveat: [handling the final message](/Development/Roadmap/Asterisk-12-Projects/Asterisk-12-API-Improvements/Stasis-Message-Bus/Using-the-Stasis-Message-Bus/Stasis-Subscriber-Shutdown-Problem).




---

  
  


```

static void statsmaker(void \*data, struct stasis\_subscription \*sub,
 struct stasis\_topic \*topic, struct stasis\_message \*message)
{
 RAII\_VAR(struct ast\_str \*, metric, NULL, ast\_free);
 if (stasis\_subscription\_final\_message(sub, message)) {
 /\* Normally, data points to an object that must be cleaned up.
 \* The final message is an unsubscribe notification that's
 \* guaranteed to be the last message this subscription receives.
 \* This would be a safe place to kick off any needed cleanup.
 \*/
 return;
 }
 /\* For no good reason, count message types \*/
 metric = ast\_str\_create(80);
 if (metric) {
 ast\_str\_set(&metric, 0, "stasis.message.%s",
 stasis\_message\_type\_name(stasis\_message\_type(message)));
 ast\_statsd\_log(ast\_str\_buffer(metric), AST\_STATSD\_METER, 1);
 }
}

```



---


When you unsubscribe from a topic, messages are still being dispatched to the callback. You need to wait until the final message has been processed before you can dispose of the data pointer given to the subscription.

Fortunately, the message bus offers a simple way to handle this. The unsubscribe message for your subscription is guaranteed to be the last message received. The [stasis\_subscription\_final\_message()](http://doxygen.asterisk.org/trunk/d0/df4/stasis_8c.html#839350445aaa51cedf31f6daec933ee0) function will determine if a message is indeed your last message, and allow you to kick off any necessary cleanup. Usually this involves `ao2_cleanup(data)`, but many times there's simply nothing to do.

Message Routing
---------------

We discovered in using subscriptions that most subscription handlers were simply chains of `if/else` clauses dispatching messages based on type. Rather than encourage that sort of ugly boilerplate, we introduced the [stasis\_message\_router](http://doxygen.asterisk.org/trunk/d4/d25/stasis__message__router_8h.html).




---

  
  


```

static void updates(void \*data, struct stasis\_subscription \*sub,
 struct stasis\_topic \*topic, struct stasis\_message \*message)
{
 /\* Since this came from a message router, we know the type of the
 \* message. We can cast the data without checking its type.
 \*/
 struct stasis\_cache\_update \*update = stasis\_message\_data(message);
 /\* ... \*/

}
static void default\_route(void \*data, struct stasis\_subscription \*sub,
 struct stasis\_topic \*topic, struct stasis\_message \*message)
{
 if (stasis\_subscription\_final\_message(sub, message)) {
 /\* subscription cleanup \*/
 }
 /\* ... \*/
}
static int load\_module(void)
{
 router = stasis\_message\_router\_create(
 stasis\_caching\_get\_topic(ast\_channel\_topic\_all\_cached()));
 if (!router) {
 return AST\_MODULE\_LOAD\_FAILURE;
 }
 stasis\_message\_router\_add(router, stasis\_cache\_update\_type(),
 updates, NULL);
 stasis\_message\_router\_set\_default(router, default\_route, NULL);
 /\* ... \*/
 return AST\_MODULE\_LOAD\_SUCCESS;
}


static int unload\_module(void)
{
 /\* ... \*/
 stasis\_message\_router\_unsubscribe(router);
 router = NULL;
 return 0;
}

```



---


Messages are dispatched to the router with the same guarantees as a regular subscription. The difference is that you can provide a different callback for every message type that you're interested in. You can also add a default route, which is useful for handling miscellaneous messages, such as the final message.

