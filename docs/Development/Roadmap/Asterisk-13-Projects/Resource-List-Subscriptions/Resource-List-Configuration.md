---
title: Resource List Configuration
pageid: 28934359
---

Configuration Scheme
====================

The following is a sample entry for a resource list in `pjsip.conf`:




---

  
  


```

[sales_team]
type = resource_list
event = presence
list_item = bob@default
list_item = alice@outgoing
list_item = carol@default,david@default
full_state = yes
notification_batch_interval = 2000

```


Here is a breakdown of the options:

* `type`: Like with all items in `pjsip.conf`, a type must be specified to indicate what type of configuration object is being used. A "resource_list" can be thought of as a narrowly-defined address of record. Like an AoR, it is addressable; SIP SUBSCRIBE messages are addressed to this resource.
* `event`: The SIP event package that this resource list supplies state for. Providing the event package name is essential for understanding how to interpret list items.
* `list_item`: Each of these is a resource in the list. In this case, each item is a dialplan extension and context in which to look up a hint. Note that list_items may be listed on separate lines or they may be comma-separated on a single line. The comma-separated option allows for configuration in realtime.
* `full_state`: Indicates if notifications should contain the state of all list items. If set to "yes" then the full state of the list is sent on every state change. If set to "no" then only the resources whose states have changed will be sent in notifications. Note that RFC 4662 mandates certain times when a full state MUST be sent. Even if full_state is set to "no" we will still send full state at those mandated times.
* `notification_batch_interval`: Indicates how many milliseconds to wait after an initial state change to accumulate further state changes before sending out a notification. In a very busy phone system, setting a reasonable interval will allow for multiple state changes to be sent to a subscriber at the same time. Setting the batch interval too high may result in seeing state changes too late or missing transient state changes altogether. Setting this to zero will cause notifications to be pushed out immediately when a state change occurs on a resource in the list.

One aspect of resource lists is that they allow for items within a list to be lists themselves. This would allow for a configuration like the following to be used:




---

  
  


```

[sales_team]
type = resource_list
event = presence
list_item = bob@default
list_item = alice@outgoing
list_item = carol@default,david@default
 
[marketing_team]
type = resource_list
event = presence
list_item = zane@default
list_item = yancy@default
list_item = xerxes@default
 
[business]
type = resource_list
event = presence
list_item = mallory@default
list_item = nadine@default
list_item = olaf@default
list_item = sales_team
list_item = marketing_team

```


In this example, someone could subscribe to the "business" resource and as a result be subscribed to "sales_team" and "marketing_team".

Supported Event Packages
========================

Asterisk currently only has support for the presence and message-summary (MWI) event packages. Support for these event packages is provided by the `res_pjsip_exten_state` and `res_pjsip_mwi` modules, respectively.

### Presence

Presence is the event package that maps SIP subscriptions to dialplan hints. Presence support is provided by the `res_pjsip_exten_state.so` module. List items for the presence event package are formatted as follows




---

  
  


```

list_item = exten@context

```


A hint must exist at the given extension and context in order for presence to be reported for the resource in the list.

### Message-summary

Message summary is the event package that provides message waiting indication (i.e. the number of old and new messages in a mailbox). Message-summary support is provided by the `res_pjsip_mwi.so` module. List items for the presence event package are formatted as follows:




---

  
  


```

;If using voicemail.conf and the VoiceMail() application for voicemail:
list_item = mailbox@context
 
;If using external voicemail, then the format of the list_item is based on a schema of your own choosing
list_item = my/crazy,homegrown|mailbox+hierarchy

```


### Other event packages

Support for other event packages can be added by creating a module that registers an `ast_sip_notifier` for the given event package. Instructions for writing such a module are outside the scope of this configuration document.

Edge Cases
==========

Let's consider some odd configurations that may occur.

### Duplicated list names with duplicated event packages

Consider the following configuration:




---

  
  


```

[foo]
type = resource_list
event = presence
list_item = alice@default
 
[foo]
type = resource_list
event = presence
list_item = bob@default

```


This is a bad configuration. The result is up to the lower layers of configuration handling in Asterisk, but it will likely end up overwriting the first instance of foo with the second.

### Duplicated list names with different event packages

Consider the following configuration:




---

  
  


```

[foo]
type = resource_list
event = presence
list_item = alice@default
 
[foo]
type = resource_list
event = message-summary
list_item = bob@default

```


This may seem valid since the two lists apply to different event packages. However, the object storage system that Asterisk uses (sorcery) does not allow for identically-named categories of the same type. As a result, this configuration is invalid. The most likely result of this setup would the second foo list overwriting the first foo list.

### Loops

Consider the following configuration:




---

  
  


```

[foo]
type = resource_list
event = presence
list_item = bar
 
[bar]
type = resource_list
event = presence
list_item = foo
list_item = baz
 
[baz]
type = resource_list
event = presence
list_item = alice@default

```


In this configuration, foo references the bar list, and bar references the foo list. This is called a "loop" since attempting to follow the links between lists will result in an everlasting loop. In the above configuration, attempted subscriptions to the "foo" and "bar" lists are invalid since they create loops. However, the "baz" list is addressable on its own since subscribing to it does not create a loop.

Note that loops are detected when a SIP SUBSCRIBE to a looped resource is received; the loop is not detected at startup when configuration is loaded. Appropriate warning messages will be issued if a loop is detected and the SUBSCRIBE will receive a 482 response.

### Ambiguity between list and resource names:

Consider the following configuration:




---

  
  


```

;pjsip.conf
[foo]
type = resource_list
event = presence
list_item = alice@default
 
[alice@default]
type = resource_list
event = presence
list_item = bob@default
 
;extensions.conf
[default]
exten => alice,hint,PJSIP/alice,CustomPresence:alice
exten => bob,hint,PJSIP/bob,CustomPresence:bob

```


In this configuration, if a subscriber subscribes to the "foo" list, then how is the list item interpreted? Does it refer to the list in pjsip.conf called "alice@default", or does it refer to the extensions.conf entry for extension alice in the default context?

Asterisk will always first attempt to resolve a list item to another list. If it is not a list, then the specific event package handler is responsible for locating the requested resource. Applying that logic to the above configuration means that an inbound subscription to list foo will be composed of the alice@default list in pjsip.conf, not the alice extension in extensions.conf.

### Non-existent resources

Consider the following configuration:




---

  
  


```

;pjsip.conf
[foo]
type = resource_list
event = presence
list_item = alice@default
 
;extensions.conf
[default]
exten => bob,hint,PJSIP/bob,CustomPresence:bob

```


Notice that the foo resource list refers to alice@default, but this does not exist either as another resource list or as a dialplan extension. What happens in this case?

Unfortunately, in this case, the answer is "it depends". For individual (i.e. non-list)  presence subscriptions, requests to non-existent resources are rejected. If a list contains a mix of existent and non-existent resources, then the subscription is accepted, but the subscriber will only receive updates for the resources that exist at the time the subscription is established. Warnings are emitted for non-existent resources. If a subscription is established to such a list and formerly-nonexistent resources are then added to configuration, the established subscription **will not** be updated to reflect the state of the newly-added resources. A subscription to a list of nothing but non-existent presence resources (like the above configuration had) will be rejected with a 404 response.

For message-summary, things work a bit differently. If you are using voicemail.conf and the VoiceMail application to define your message-summary resources, then the rules described for presence apply exactly the same way. However, if you are using an external voice mail system, message-summary has the notion built into it that the resource being subscribed to may not yet be established but may be later. This means that subscriptions to external message-summary resources will always succeed, even if none of the resources exist yet. If the resources are added after the subscription is established, then the states of those resources **will** be reflected in future notifications on the same subscription.

Note that the contents of resource lists are evaluated every time that a new SIP SUBSCRIBE arrives, not when modules are loaded. This means that if resources that previously did not exist later get added (e.g. a previously non-existent extension gets added to extensions.conf), it is **not necessary** to reload your pjsip.conf configuration after the resource is added. The only time you will need to reload pjsip.conf is if the content of pjsip.conf itself has changed.

