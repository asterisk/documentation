---
title: Overview
pageid: 28315259
---








ARI Improvements for Asterisk 13
================================

One of the major goals of Asterisk 13 is to round out the functionality in ARI. This page serves as a place to put notes about API proposals, design decisions, and other useful information for people participating in those projects.

Smaller projects may not be listed here; for those, check the [asterisk-app-dev](http://lists.digium.com/cgi-bin/mailman/listinfo/asterisk-app-dev) mailing list.

Messaging Resource
==================

Asterisk has the ability to send and receive text messages from various sources in a channel agnostic fashion. Ideally, we would also have the ability to interact with text messages via ARI. An ARI application should be able to be notified when a new message has been received (possibly after subscribing to something related to said message), and should be able to send messages to some destination.

The currently supported text message formats are XMPP messages (via res_xmpp) and SIP (via chan_sip and res_pjsip_messaging). Sending a message is done through the [MessageSend](/Latest_API/API_Documentation/Dialplan_Applications/MessageSend) dialplan application or the [MessageSend](/Latest_API/API_Documentation/AMI_Actions/MessageSend) AMI action; the destination of the message is inferred by a prefix, e.g., 'xmpp:' for XMPP, etc. Messages are processed in the dialplan using a special channel driver implemented in the [message](http://doxygen.asterisk.org/trunk/d2/d0d/message_8h.html) core of Asterisk. When a message is received from any channel driver/technology stack, the message is enqueued to the special channel driver. All messages from all channel drivers are enqueued for a single instance of the channel drvier. This channel driver - aptly called **Message** - dispatches the message to the appropriate place in the dialplan for processing.

This process make sense and works well when the dialplan is the appropriate location for handling the text message. At the time it was written, it was also the only place to handle said messages. However, in ARI, this mechanism has several drawbacks.

1. Sending the Message channel to the Stasis application would cause it to block all other message processing indefinitely. This is particularly bad for situations where some messages should be processed in the dialplan (and need to be processed without external interaction) and other messages should be processed by an external application.
2. Using the Message channel in a Stasis application would create an implicit dependency between all external applications. That is, if ARI application 'foo' is servicing a message, external ARI application 'bar' cannot (at the same time).
3. The Message channel is really an implementation of detail of how the message is delivered to the dialplan. Performing actions on the channel (such as playbacks, hold, ringing, etc.) would cause some rather strange side effects. Requiring the channel to be exposed in ARI to process a text message feels wrong.

Instead of having a channel process the received text messages, ideally we would simply notify the ARI clients of the received message via a JSON event:

```
{
 type: 'MessageReceived'
 from: 'sip:bob'
 to: 'xmpp:alice'
 body: 'blah blah blah'
 variables: [ key: 'value', someotherkey: 'someothervalue' ]
}

```



An ARI application - if they subscribed to some endpoint that matches the From: or To: header - can choose to act on the message in any way they see fit. Message processing in the dialplan can still take place as well, if the dialplan needs to handle the message.

User Stories
------------

As an ARI application, I want to be able to...

* Initiate sending a technology specific message to an ARI endpoint using a REST resource
* Initiate sending a technology specific message to an arbitrary technology specific URI using a REST resource
* Subscribe for MessageReceived events related to an endpoint
* Cancel an active subscription for MessageReceived events
* Receive MessageReceived events related to a subscription
* Retrieve, from a MessageReceived event, who sent the message; who the message was destined for; the body of the message; technology specific headers/metadata

APIs
----

### Endpoint Resource

A new operation supporting sending a message to a technology will be added to the *endpoint* resource. To send a message to a specific endpoint, the technology/resource should be specified:

```
POST /endpoints/PJSIP/alice/message
{
 "from": "pjsip:bob",
 "body": "I am the very model of a major general"
 "variables": [
 { "X-Foo-Bar": "I am a special header" },
 { "X-Foo-Yack": "I am not" },
 ],
}

```

Note that the content of the **from** key is dependent on the channel technology being chosen. SIP message technologies allow for arbitrary URIs to be specified as the initiator of the message; XMPP does not.



Messages can be sent to a technology specific URI that is not associated with an endpoint. This can be done by omitting the resource to send the message to and providing a **to** key in the request:

```
POST /endpoints/PJSIP/message
{
 "from": "xmpp:bob@jabber.org",
 "to": "pjsip:generic/sip:alice@mysipserver.org"
 "body": "No, \*I\* am the very model of a major general"
}

```



!!! tip **  Note that in this case, the SIP URI specified in the **to
    key uses the PJSIP nomenclature of a generic endpoint to associate with the outbound SIP URI. This is due to PJSIP's usage of endpoints to provide default codecs/behaviour with outbound requests to SIP URIs.

      
[//]: # (end-tip)



Responses to the request can include:

* 200 - the message was successfully enqueued/sent
* 400 - missing a needed parameter
* 404 - the specified endpoint was not found. The endpoint that was not found will be provided (as this could apply to either the **from** or the **to**)

### Applications resource

The *applications* resource will be updated such that subscribing to an endpoint also subscribes to messages sent to that endpoint.

### Events

A new event will be defined, *MessageReceived.*This event will occur when Asterisk receives a message sent from some entity to an endpoint defined by Asterisk.

```
{
 "type": "MessageReceived",
 "from": "pjsip:alice",
 "to": "\"bob\" <bob@my_asterisk_server.org>",
 "body": "Who's the major general now?",
 "variables": [
 {"SIP_RECVADDR", "127.0.0.1"},
 ],
}

```

Note that the **to** key in the JSON *MessageReceived* event specifies the URI the message was sent to. It is up to the ARI application to handle or route that appropriately.

Design
------

There's a few pieces to the message core in Asterisk that will need to be changed.

First, *message.h* will need to expose a registration function that allows for an external participant to handle the message routing:

```
static int ast_msg_register_observer(const char \*id, void (\*msg_cb)(struct ast_msg \*msg));

static int ast_msg_unregister_observer(const char \*id);

```



When performing the routing (after pulling the message off the taskprocessor), message should deliver the message to the observers:

```
/*!
 * \internal
 * \brief Run the dialplan for message processing
 *
 * \pre The message has already been set up on the msg datastore
 * on this channel.
 */
static void msg_route(struct ast_channel \*chan, struct ast_msg \*msg)
{
 struct ast_pbx_args pbx_args;
 msg_cb_t \*cb;

 AST_LIST_TRAVERSE(&observers, cb, list) {
 cb(msg);
 }

 ast_explicit_goto(chan, ast_str_buffer(msg->context), AS_OR(msg->exten, "s"), 1);
 memset(&pbx_args, 0, sizeof(pbx_args));
 pbx_args.no_hangup_chan = 1,
 ast_pbx_run_args(chan, &pbx_args);
}

```

Note that we aren't going to do any filtering of the messages at this level; instead, we'll rely on the filtering to be done in Stasis. The Stasis application can decide whether or not the message is something it wants to forward along.



No modifications should have to be done for `res_xmpp` or `res_pjsip_messaging`. `chan_sip`, on the other hand, first checks the dialplan to see if an extension exists before it passes the message to the messaging core. As such, `chan_sip` will have to be modified to dispatch the message if an observer has been registered, even if no extension matches. This would entail a function in *message* that would return whether or not any observers existed.

```
 switch (get_destination(p, NULL, NULL)) {
 case SIP_GET_DEST_REFUSED:
 /* Okay to send 403 since this is after auth processin */
 transmit_response(p, "403 Forbidden", req);
 sip_scheddestroy(p, DEFAULT_TRANS_TIMEOUT);
 return;
 case SIP_GET_DEST_INVALID_URI:
 transmit_response(p, "416 Unsupported URI Scheme", req);
 sip_scheddestroy(p, DEFAULT_TRANS_TIMEOUT);
 return;
 case SIP_GET_DEST_EXTEN_NOT_FOUND:
 case SIP_GET_DEST_EXTEN_MATCHMORE:
 if (!ast_msg_observers_registered()) {
 transmit_response(p, "404 Not Found", req);
 sip_scheddestroy(p, DEFAULT_TRANS_TIMEOUT);
 return;
 }
 /* Fall throug */
 case SIP_GET_DEST_EXTEN_FOUND:
 break;
 }

```



Stasis (as in the application for ARI, not the message bus) can filter out the messages accordingly. Normally, a subscription entails a particular stasis subscription for a channel, bridge, endpoint, etc. While some subscriptions for messages are endpoint based, some are based on technology (such as, give me all of the messages associated with PJSIP endpoints/technology). This is because messages don't have to be associated with an endpoint - they can be sent to an arbitrary URI, and they can be sent to "asterisk" - not to some endpoint managed by Asterisk. As such, we can't just use a Stasis topic for this (or at least, we can't use the endpoint topic - more on that later).

The observer that the Stasis application registers with the core should filter out the messages that don't have a subscription. This can be done by inspecting the to/from URIs and matching on either the technology (if we have a subscription to the technology) and/or the endpoint that sent/received the message. These should then be turned into JSON events and sent out the websocket to the subscribing applications.




!!! tip Why not use the Stasis message bus?
    The Stasis message bus, as a general publish/subscribe message bus, is great at delivering information throughout Asterisk. At the same time, that doesn't mean that everything needs to get pushed over it. There's some problems with pushing all text messages over Stasis:

    1. Some systems can be rather chatty. XMPP servers could blast us with notifications. Pushing all that information over Stasis requires a lot of processing in the Asterisk core, which is potentially wasteful and would hurt performance.
    2. Subscriptions to endpoints in Stasis probably shouldn't include messages, as the association with an endpoint is somewhat only loosely enforced in the channel drivers. The subscription, in this case, is really more of an application level construct.
    3. The only thing that cares about these messages is ARI - AMI doesn't, CDRs don't, CEL doesn't. Pushing information over the bus for only one consumer is sometimes okay; other times - particularly when there will be lots of these messages - it doesn't seem worthwhile.
      
[//]: # (end-tip)



Test Plan
---------



| Test | Level | Description |
| --- | --- | --- |
| applications/subscribe-endpoint | Asterisk Test Suite | Basic subscription to an endpoint. Test should verify that a message sent from the subscribed endpoint is received; message sent to the subscribed endpoint is received; message sent to an unsubscribed endpoint is not received. Verify that an application not subscribed does not receive messages. |
| applications/subscribe-technology | Asterisk Test Suite | Subscribe to all messages associated with a technology. Verify that any message sent to an endpoint of the technology type is received. Verify that an application not subscribed does not receive messages. |
| message/basic | Asterisk Test Suite | Test sending a message through ARI to an endpoint, a generic URI; from an endpoint, from a sip URI. |
| message/off_nominal | Asterisk Test Suite | Test off nominal scenarios:* Badly formatted request body
* Bad from endpoint (for a technology that requires it)
* Bad to endpoint (for a technology that requires it)
 |
| message/headers | Asterisk Test Suite | Test adding technology specific headers to a message through ARI |

Project Planning
================

Provide links to the appropriate JIRA issues tracking work related to the project using the {jiraissues} macro (for more information on its usage, see [JIRA Issues Macro](https://confluence.atlassian.com/display/DOC/JIRA+Issues+Macro)). The sample below uses a public Triage filter - you will need to set up a JIRA issue filter for the macro to pull issues from that is shared with the **Public** group.

JIRA Issues
-----------

Contributors
------------



| Name | E-mail Address |
| --- | --- |
| unknown user | mjordan@digium.com |

Reference Information
=====================



