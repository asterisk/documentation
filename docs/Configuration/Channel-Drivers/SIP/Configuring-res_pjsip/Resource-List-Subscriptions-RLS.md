---
title: Resource List Subscriptions (RLS)
pageid: 30278158
---

Overview
========

Beginning in Asterisk 13, Asterisk supports RFC 4662 resource list subscriptions in its PJSIP-based SIP implementation.

In a PBX environment, it is common for SIP devices to subscribe to many resources offered by the PBX. This holds especially true for presence resources. Consider a small office where an Asterisk server acts as a PBX for 20 people, each with a SIP desk phone. Each of those 20 phones subscribes to the state of the others in the office. In this case, each of the phones would create 19 subscriptions (since the phone does not subscribe to its own state). When totalled, the Asterisk server would maintain 20 \* 19 = 380 subscriptions. For an office with 30 people, the total number of subscriptions becomes 30 \* 29 = 870 subscriptions. For an office with 40 people, the total number of subscriptions becomes 40 \* 39 = 1560. That is about four times the number of subscriptions for the 20-person office, despite only having twice the number of people. The number of subscriptions follows a geometric progression, leading to a situation commonly called an *N-squared* problem. In other words, the amount of traffic generated and amount of server resources required are proportional to the square of the number of users (N) on the system. The N-squared problem with subscriptions can be a limiting factor for PBX deployers for several reasons:

* In a situation where all phones boot up simultaneously, each of the phones will be sending out their SIP SUBSCRIBEs nearly simultaneously, placing a larger-than-average burden on the Asterisk server's CPU.
* In the SIP stack, N-squared long-term SIP dialogs have to be maintained, tying up more system resources (e.g. memory).
On this Page2

These limitations can drastically limit the number of devices a PBX administrator can use with an Asterisk system. Even if the hardware is capable of handling the mean traffic of, say, 200 users, it may be required to limit the number of users to 50 or fewer because of the N-squared subscriptions generating so much simultaneous traffic.

Resource list subscriptions provide relief for this problem by allowing for resources to be grouped into lists. A single subscription to a list will result in multiple back-end subscriptions to the resources in that list. Notifications of state changes can also be batched so that multiple state changes may be conveyed in a single message. This can help to significantly decrease the amount of subscription-related traffic and processing being performed.

Configuring Resource List Subscriptions
=======================================

RLS is configured in `pjsip.conf` using a special configuration section type called "resource\_list". Here is an example of a simple resource list:

pjsip.conftrue[sales]
type = resource\_list
event = presence
list\_item = alice
list\_item = bob
list\_item = carolIt should be simple to glean the intent of this list. We have created a list called "sales" that provides the presence of the sales team of alice, bob, and carol. Let's go over each of the options in more detail.

* `type`: This must be set to "resource\_list" so that the configuration parser knows that it is looking at a resource list.
* `event`: The SIP event package provided by this resource list. Asterisk, as provided by Digium, provides support for the following event packages:
	+ presence: Provides ability to determine when devices are in use or not. Commonly known as BLF.
	+ dialog: An alternate method of providing BLF. Used by certain SIP equipment instead of the presence event package.
	+ message-summary: Provides the ability to determine the number of voice mail messages that a mailbox contains. Commonly known as MWI.
* `list_item`: This is the name of a resource that belongs to the list. The formatting of list items is dependent on the event package provided by the list.
	+ presence: This is the name of an extension in the dialplan. In the example, the extensions "alice", "bob", and "carol" exist in `extensions.conf`.
	+ dialog: The same as the presence event package.
	+ message-summary: This is the name of a mailbox. If you are using `app_voicemail`, then mailboxes will be in the form of "mailbox@context". If you are using an external voicemail system, then the name of the mailbox will be in whatever format the external voicemail system uses for mailbox names.The list items in the example were placed on separate lines, but it is also valid to place multiple list items on a single line: `list_item = alice,bob,carol`. Note also that list items can also be other resource lists of the same event type.

There is one further option that is not listed here, but deserves some mention: `full_state`. RFC 4662 defines "full" and "partial" state notifications. When the states of a subset of resources on a resource list changes, a server has the option of sending a notification that only contains the resources whose states have changed. This is a partial state notification. A full state notification would include the states of all resources in the list, even if only some of the resources' states have changed. The `full_state` option allows for full state notifications to be transmitted unconditionally. By default, `full_state` is disabled on resource list subscriptions in order to keep the size of notifications small. It is **highly recommended** that you use the default value for this option unless you are using a client that does not understand partial state notifications.

Batching Notifications
======================

In addition to the basic options listed above, there is another option, `notification_batch_interval` that can be used to change Asterisk's behavior when sending notifications of resource state changes on a list. By default, whenever the state of any resource on a list changes, Asterisk will immediately send out a notification of the state change. If, however, a `notification_batch_interval` is specified, then when a resource state changes, Asterisk will start a timer for the specified interval. While the timer is running, any further state changes of resources in the list are batched along with the original state change that started the timer. When the timer expires, then all batched state changes are sent in a single NOTIFY.

Let's modify the previous configuration to use a batching interval:

pjsip.conftrue[sales]
type = resource\_list
event = presence
list\_item = alice
list\_item = bob
list\_item = carol
notification\_batch\_interval = 2000The units for the `notification_batch_interval` are milliseconds. With this configuration, Asterisk will collect resource state changes for 2000 milliseconds before sending notifications on this resource list.

The biggest advantage of notification batching is that it can decrease the number of NOTIFY requests that Asterisk sends. If two SIP phones on a PBX are having a conversation with one another, when a call completes, both phones are likely to change states to being not in use. By having a batching interval configured, it would allow for a single NOTIFY to indicate both devices' state changes instead of having to send two separate NOTIFY requests.

The biggest disadvantage of notification batching is that it becomes possible for transient states for a device to be missed. If you have a batching interval of 3000 milliseconds, and a phone only rings for one second before it is answered, it means that the ringing state of the phone never got transmitted to interested listeners.

Corner Cases
============

Non-existent List Items
-----------------------

Let's say you have the following list configured in pjsip.conf:

pjsip.conftrue[sales]
type = resource\_list
event = presence
list\_item = alice
list\_item = bob
list\_item = carolAnd you have the following in `extensions.conf`

extensions.conftrue[default]
exten => alice,hint,PJSIP/alice
exten => bob,hint,PJSIP/bobNotice that there is no "carol" extension in `extensions.conf`. What happens when a user attempts to subscribe to the sales list?

When the subscription arrives, Asterisk recognizes the subscription as being for the list. Asterisk then acts as if it is establishing individual subscriptions to each of the list items the same way it would if a subscription had arrived directly for the list item. In this case, the subscriptions to alice and bob succeed. However, the presence subscription handler complains that it cannot subscribe to carol since the resource does not exist.

The policy currently used is that if subscription to at least one list resource succeeds, then the subscription to the entire list has succeeded. Only the list items that were successfully subscribed to will be reflected in the list subscription. If subscription to **all** list items fails, then the subscription to the list also fails.

Loops
-----

Let's say you have the following pjsip.conf file:

pjsip.conftrue[sales]
type = resource\_list
event = presence
list\_item = tech\_support
 
[tech\_support]
type = resource\_list
event = presence
list\_item = salesNotice that the sales list contains the tech\_support list, and the tech\_support list contains the sales list. We have a loop here. How is that handled?

Asterisk's policy with loops is to try to resolve the issue while being as graceful as possible. The way it does this is that when it detects a loop, it essentially considers the looped subscription to be a failed list item subscription. The process would go something like this:

1. A subscription arrives for the sales list.
2. We attempt to subscribe to the tech\_support list item in the sales list.
3. Inside the tech\_support list, we see the sales list as a list item.
4. We notice that we've already visited the sales list, so we fail the subscription to the sales list list item.
5. Since subscriptions to all list items in the tech support list failed, the subscription to the tech support list failed.
6. Since the tech support list was the only list item in the sales list, and that subscription failed, the subscription to the sales list fails as well.

What if the configured lists were modified slightly:

pjsip.conftrue[sales]
type = resource\_list
event = presence
list\_item = tech\_support


[tech\_support]
type = resource\_list
event = presence
list\_item = sales
list\_item = aliceNotice that the tech\_support list now also has alice as a list\_item. How does the process change on a subscription attempt to sales?

1. A subscription arrives for the sales list
2. We attempt to subscribe to the tech\_support list item in the sales list.
3. Inside the tech\_support list, we see the sales list as a list item.
4. We notice that we've already visited the sales list, so we fail the subscription to the sales list list item.
5. We move on to the next list\_item in tech\_support, alice.
6. We attempt a subscription to alice, and it succeeds.
7. Since at least one subscription to a list item in tech\_support succeeded, the subscription to tech\_support succeeds.
8. Since the subscription to the only list item in sales succeeded, the subscription to sales succeeds.

So in this case, even though the configuration contains a loop, Asterisk is able to successfully create a subscription while trimming the loops out.

Ambiguity
---------

### Duplicated List Names

If a list name is duplicated, then the configuration framework of Asterisk will not allow for the two to exist as separate entities. It is expected that the most recent list in the configuration file will overwrite the earlier ones.

While this may seem like an obvious thing, users may be tempted to configure lists that have the same name but that exist for different SIP event packages. While this may seem like a legitimate configuration, it will not work as intended.

### List and Resources with Same Name

One flaw that RLS has is that there is no way to know whether a subscription is intended to be for a list or for an individual resource. Let's say you have the following pjsip configuration:

pjsip.conftrue[sales]
type = resource\_list
event = presence
list\_item = alice
list\_item = bob
list\_item = carolAnd let's say you have the following `extensions.conf`:

extensions.conftrue[default]
exten => sales,hint,Custom:salesWhat happens if someone attempts to subscribe to the "sales" presence resource?

One easy way to determine intent is to check the Supported: header in the incoming SUBSCRIBE request. If "eventlist" does not appear, then the subscriber does not support RLS and is therefore definitely subscribing to the individual sales resource as described in `extensions.conf`.

But if the subscriber does support RLS, then Asterisk's policy is to always assume that the subscriber intends to subscribe to the list, not the individual resource.

### Conflicting Batching Intervals

`notification_batch_interval` can be configured on any resource list. Consider the following configuration:

pjsip.conftrue[sales]
type = resource\_list
event = presence
list\_item = sales\_b
list\_item = carol
list\_item = david
notification\_batch\_interval = 3000
 
[sales\_b]
type = resource\_list
event = presence
list\_item = alice
list\_item = bob
notification\_batch\_interval = 10000What is the batch interval when a user subscribes to the sales list?

The policy that Asterisk enforces is that only the batch interval of the top-most list in the hierarchy is applied. So in the example above, the batch interval would be 3000 milliseconds since the top-most list in the hierarchy is the sales list. If the sales list did not have a batch interval configured, then there would be no batch interval for the list subscription at all.

Limitations
===========

List size
---------

Due to limitations in the PJSIP stack, Asterisk is limited regarding the size of a SIP message that can be transmitted. Asterisk currently works around the built-in size limitation of PJSIP (4000 bytes by default) and can send a message up to 64000 bytes instead. RFC 4662 requires that when sending a NOTIFY request due to an inbound SUBSCRIBE request, we must send the full state of the resource list in response. For large lists, this may mean that the NOTIFY will exceed the size limit.

It is difficult to try to quantify the limit in terms of number of list resources since different body types are more verbose than others, and different configurations will have different variables that will factor into the size of the message (e.g. the length of SIP URIs for one system may be three times as long as the SIP URIs for a separate system, depending on how things are configured).

If you create a very large list, and you find that Asterisk is unable to send NOTIFY requests due to the size of the list, consider breaking the list into smaller sub-lists if possible.

Lack of dynamism
----------------

Resource lists can be updated as you please, adding and removing list items, altering the batching interval, etc. However, you will find that when a list is altered, any current subscriptions to the list are not updated to reflect the changes to the list. This is because the list is read from configuration at the time that the subscription is established, and the configuration is never again consulted during the lifetime of the subscription. If configuration is updated, then you must terminate your current subscriptions to the list and create a new subscription in order to apply the changes.

Similarly, the state of resources is locked in at the time the subscription is established. For instance, if a list contains a list item that does not exist at the time the subscription is established, if that resource comes into existence later, then the established subscription is not updated to properly reflect the added list item. The subscription must be terminated and re-established in order to have the corrected list item included.

