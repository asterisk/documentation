---
title: Configuring res_pjsip for Presence Subscriptions
pageid: 29392974
---




!!! warning 
    Under Construction - This page is a stub!

      
[//]: # (end-warning)



Capabilities
============

Asterisk's PJSIP channel driver provides the same presence subscription capabilities as `chan_sip` does. This means that [RFC 3856](http://tools.ietf.org/html/rfc3856) presence and [RFC 4235](http://www.rfc-editor.org/rfc/rfc4235.txt) dialog info are supported. Presence subscriptions support [RFC 3863](http://tools.ietf.org/html/rfc3863) PIDF+XML bodies as well as [XPIDF+XML](http://tools.ietf.org/html/draft-rosenberg-impp-pidf-00). Beyond that, Asterisk also supports subscribing to [RFC 4662](http://tools.ietf.org/html/rfc4662) lists of presence resources.  
On this Page


extensions.conf

```
true[default]
exten => 1000,hint,PJSIP/alice

```

The line shown here is similar to any normal line in a dialplan, except that instead of a priority number or label, the word "hint" is specified. The hint is used to associate the state of individual devices with the state of a dialplan extension. An English translation of the dialplan line would be "Use the state of device PJSIP/alice as the basis for the state of extension 1000". When PJSIP endpoints subscribe to presence, they are subscribing to the state of an extension in the dialplan. By providing the dialplan hint, you are creating the necessary association in order to know which device (or devices) are relevant. For the example given above, this means that if someone subscribes to the state of extension 1000, then they will be told the state of PJSIP/alice. For more information about device state, see [this page](/Fundamentals/Key-Concepts/States-and-Presence/Device-State).

There are two endpoint options that affect presence subscriptions in `pjsip.conf`. The `allow_subscribe` option determines whether SUBSCRIBE requests from the endpoint are permitted to be received by Asterisk. By default, `allow_subscribe` is enabled. The other setting that affects presence subscriptions is the `context` option. This is used to determine the dialplan context in which the extension being subscribed to should be searched for. Given the dialplan snippet above, if the intent of an endpoint that subscribes to extension 1000 is to subscribe to the hint at 1000@default, then the context of the subscribing endpoint would need to be set to "default". Note that if the `context` option is set to something other than "default", then Asterisk will search that context for the hint instead.

In order for presence subscriptions to work properly, some modules need to be loaded. Here is a list of the required modules:

* `res_pjsip.so`: Core of PJSIP code in Asterisk.
* `res_pjsip_pubsub.so`: The code that implements SUBSCRIBE/NOTIFY logic, on which individual event handlers are built.
* `res_pjsip_exten_state.so`: Handles the "presence" and "dialog" events.
* `res_pjsip_pidf_body_generator.so`: This module generates application/pidf+xml message bodies. Required for most subscriptions to the "presence" event.
* `res_pjsip_xpidf_body_generator.so`: This module generates application/xpidf+xml message bodies. Required for some subscriptions to the "presence" event.
* `res_pjsip_dialog_info_body_generator.so`: Required for subscriptions to the "dialog" event. This module generates application/dialog-info message bodies.

If you are unsure of what event or what body type your device uses for presence subscriptions, consult the device manufacturer's manual for more information.

Presence Customisations
=======================

Digium Presence
---------------

Digium phones are outfitted with a custom supplement to the base PIDF+XML presence format that allows for XMPP-like presence to be understood. To add this, the hint can be modified to include an additional presence state, like so:

extensions.conf

```
true[default]
exten => 1000,hint,PJSIP/alice,CustomPresence:alice

```

This means that updates to the presence state of CustomPresence:alice will also be conveyed to subscribers to extension 1000. For more information on presence state in Asterisk, see [this page](/Fundamentals/Key-Concepts/States-and-Presence/Presence-State).

The `res_pjsip_pidf_digium_body_supplement.so` module must be loaded in order for additional presence details to be reported.

Rich Presence (limited)
-----------------------

Some rich presence supplements that were in `chan_sip` have been migrated to the PJSIP channel driver as well. This is an extremely limited implementation of the "activities" element of a person. The `res_pjsip_pidf_eyebeam_body_supplement.so` module is required to add this functionality.

