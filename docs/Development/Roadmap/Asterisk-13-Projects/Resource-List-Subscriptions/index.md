---
title: Overview
pageid: 28934182
---

Overview
========

In a PBX environment, it is common for SIP devices to subscribe to many resources offered by the PBX. This holds especially true for presence resources. Consider a small office where an Asterisk server acts as a PBX for 20 people, each with a SIP desk phone. Each of those 20 phones subscribes to the state of the others in the office. In this case, each of the phones would create 19 subscriptions (since the phone does not subscribe to its own state). When totaled, the Asterisk server would maintain 20 \* 19 = 380 subscriptions. For an office with 30 people, the total number of subscriptions becomes 30 \* 29 = 870 subscriptions. For an office with 40 people, the total number of subscriptions becomes 40 \* 39 = 1560. That is about four times the number of subscriptions for the 20-person office, despite only having twice the number of people. The number of subscriptions follows a geometric progression, leading to a situation commonly called an *N-squared* problem. In other words, the amount of traffic generated and amount of server resources required are proportional to the square of the number of users (N) on the system. The N-squared problem with subscriptions can be a limiting factor for PBX deployers for several reasons:

* In a situation where all phones boot up simultaneously, each of the phones will be sending out their SIP SUBSCRIBEs nearly simultaneously, placing a larger-than-average burden on the Asterisk server's CPU.
* In the SIP stack, N-squared long-term SIP dialogs have to be maintained, tying up more system resources (e.g. memory).

These limitations can drastically limit the number of devices a PBX administrator can use with an Asterisk system. Even if the hardware is capable of handling the mean traffic of, say, 200 users, it may be required to limit the number of users to 50 or fewer because of the N-squared subscriptions problem.

25%On this Page


Resource List Subscriptions
---------------------------

A proposed solution to this problem is to implement [RFC 4662 Resource List Subscriptions](http://www.rfc-editor.org/rfc/rfc4662.txt) (abbreviated RLS from here on). This RFC describes a method for SIP servers to map a single requested resource to a list of resources. In the example 20-person office from before, a list could be configured that contained all 20 users' phones. Each phone could then establish a single subscription to that list rather than having to establish 20 different subscriptions to each individual user's phone. In addition, notifications can list multiple resources in a single message, allowing for Asterisk to send fewer notifications.

In addition to resolving the N-squared problem, configurable lists also allows for more intuitive creation of useful sub-lists of users. In an office, you could have a "Sales" list, an "Engineering" list, a "Tech Support" list, etc. Lists are not restricted to being composed of individual devices; lists can be made of other lists. This makes it possible to have an "All" list, composed of the Sales, Engineering, and Tech Support lists, for instance.

RLS is not restricted to presence. RLS can be used for other SIP event packages, like MWI. In Asterisk, currently if subscribing to the state of multiple mailboxes, you have two options:

1. Create multiple subscriptions, a la presence.
2. Create a single subscription that aggregates the total number of old and new messages together.

While the second option allows for a reduction in subscriptions, it makes it difficult to discern from the SIP traffic which of the subscribed mailboxes contains messages. With RLS, a user could subscribe to their personal mailbox plus, say, a tech support queue mailbox. When the user is notified of the state of mailboxes, the notifications will list the individual mailboxes in separate parts, clearly indicating which mailbox has messages.

Adding support for RLS is a multi-part process.

Task 1: Abstraction of SIP Subscriptions
========================================

This first part is a behind-the-scenes improvement. Currently, the layer between Asterisk's SIP subscription handlers and the underlying dialog maintained by PJSIP is thin. Asterisk subscription handlers directly call into PJSIP in order to create NOTIFY requests to send or to accept incoming subscriptions. When using RLS, a single RLS subscription can result in multiple virtual subscriptions for the subscription handlers. Each of these virtual subscriptions should behave the same as a real subscription, but under the hood, the pubsub core in Asterisk should be capable of doing the right thing if the subscription is actually virtual. This requires improvements to the pubsub API in order to abstract operations.

Since the changes are large and deal with behind-the-scenes content, the have been relegated to their own [sub-page](/Development/Roadmap/Asterisk-13-Projects/Resource-List-Subscriptions/PJSIP-Subscription-Abstraction-Plan).

Task 2: Implementation of inbound RLS
=====================================

Once the subscription model has been abstracted, it is possible to implement support for single-server inbound RLS.

Implement configuration method
------------------------------

RFC 4662 is purposefully vague about how a SIP server sets up its resource lists. For Asterisk, we need to determine a configuration scheme to use for setting up lists. Configuration needs to take into acocunt

* New configuration object(s) required for lists
* How the resources for a given list are determined
* Whether notifications are batched
* Whether we send partial or full updates when resource states change.

Configuration of RLS is defined on [this page](/Development/Roadmap/Asterisk-13-Projects/Resource-List-Subscriptions/Resource-List-Configuration).

Write test cases (nominal and off-nominal)
------------------------------------------

If a configuration scheme has been decided, testsuite tests can be written for RLS. A test plan for RLS can be found [here](/Development/Roadmap/Asterisk-13-Projects/Resource-List-Subscriptions/Resource-List-Subscription-Test-Plan).

Write an application/rlmi+xml body generator
--------------------------------------------

RLS makes use of a special type of body that acts as metadata for the rest of the state being reported in a notification. For supporting inbound RFC 4662, we are not concerned with the ability to parse such data; we only need to be able to generate it for outbound NOTIFYs.

RLMI stands for "Resource List Meta-Information". It is an XML document used by an RLS subscriber to determine what content to expect in the parts of the multi-part body to follow. In order to be able to construct an accurate RLMI body, the following information is necessary:

* A URI for the list. This can be derived from the saved resource name on the `ast_sip_subscription`.
* A version number. This is a monotonically increasing number to include in each RLMI document.
* An indicator if full or partial state is to be sent in this document.
* For each resource being reported on:
	+ A display name for the resource. We can simply use the resource name saved on the subscription.
	+ A unique ID for each instance of the resource. Since we currently are not dealing with forked outbound-subscriptions, the resource name should suffice here.
	+ The Content ID for the body section for each subscription being reported.
	+ The current subscription state (i.e. active, pending, or terminated)

An RLMI document can be constructed using the following structure:




---

  
  


```

struct rlmi\_data {
 struct ast\_sip\_subscription \*list\_subscription;
 AST\_LIST\_HEAD(,ast\_list\_subscription) child\_subscriptions;
}; 

```


This seems a bit minimalistic, but it should be enough.

* The resource name for any subscription can be retrieved via an API call.
* The RLMI version number can be stored in a datastore on the list subscription.
* The Content-ID for the body section can actually be determined by the RLMI document and then set in a datastore on the child subscription. The multi-part body generator can take care of adding the appropriate Content-ID to each part.
* The subscription state of each of the list items will, for the time being, be "active" unless the list subscription itself is being terminated.

Implement RLS subscriptions
---------------------------

### Add inbound subscription handling

When an inbound SUBSCRIBE arrives, the pubsub layer needs to be able to determine if the requested resource is a list or not. Unfortunately, there is not anything in the inbound SUBSCRIBE that can tell us if the intent is to subscribe to a list (the SUBSCRIBE can indicate support for RLS and application/rlmi+xml, but that does not guarantee that the requested resource is a list).

When an inbound SUBSCRIBE is received, the first thing that needs to happen is to check the SUBSCRIBE's Supported header to see if it supports "eventlist" and check its Accept header to see if it accepts "application/rlmi+xml" and "multipart/related". If any of these conditions are not met, then the SUBSCRIBE can only be to a single resource, not a list. If all conditions are met, then Asterisk will attempt to locate a list that corresponds to the resource name. If there is no corresponding list, then Asterisk will attempt to subscribe to a single resource.

If the requested resource is a list, then a single real list subscription is created. For each resource in the list, the event-specific notifier is called into (the `new_subscribe` callback). For each 200-class return you receive, you will add a virtual child subscription to the list subscription. If none of the `new_subscribe` callbacks return 200-class responses, then respond to the subscription with a 404 response. For each 200-class response you get, call into the handler's `notify_required` callback with the reason `AST_SIP_SUBSCRIPTION_NOTIFY_REASON_STARTED`.

Keep in mind that resources in a list may themselves be lists. This means that for each individual resource within the list, it will be necessary to again check if the resource is a list first before passing the named resource to the notifier's `new_subscribe` callback.

### Add necessary NOTIFY handling

With the abstraction being completed in Task 1, notifiers should now be calling a single method in the pubsub API in order to send a notification. This task involves modifying that method to work properly for RLS.

When the pubsub API is asked to send a notification, it needs to determine if the subscription is virtual or real. If the subscription is real, then the current algorithm for sending SIP NOTIFYs is followed (i.e. the NOTIFY is constructed and sent).

#### Virtual subscription NOTIFY algorithm:

1. Create a NOTIFY body indicating the state of the resource being monitored.
2. Save the body on the subscription (possibly using a datastore, though we may end up adding a field to `ast_sip_subscription` to hold the body instead).
3. Set a flag on the subscription (possibly using the same datastore the body is stored in indicating that this subscription has had a state change).
4. Determine how to finish.

From here, the duty to create the NOTIFY has been passed up the chain to the list subscription.

#### List subscription NOTIFY algorithm:

1. Check the configured `full_state` value for the subscription
	1. If set to "yes" then iterate over all child subscriptions and gather the saved NOTIFY bodies on each.
	2. If set to "no" then iterate over the child subscriptions and gather the saved NOTIFY bodies on the ones that indicate they have had a state change. As each body is gathered, clear the flag indicating that the state had changed.
2. Create an application/rlmi+xml body that properly identifies the gathered bodies.
3. Create multipart/related body that contains the application/rlmi+xml body and the gathered child bodies.
4. Check if the list subscription is virtual
	1. If the subscription is not virtual, then send out a NOTIFY with the constructed multipart/related body.
	2. If the subscription is virtual, then follow virtual subscription NOTIFY algorithm, starting at step 2 since the body has already been constructed.

### Implement batched notifications

This alters notification behavior by accumulating data and sending the data out in a batch rather than sending individual state changes in real time. Notification batching behavior is based on configuration for a list. Batching is configured using the `notification_batch_interval` configuration option for a list. If set to a positive value, then batching is enabled for the list.

If batching is enabled on a real list subscription, then the List subscription NOTIFY algorithm is replaced as follows:

1. Check if there is currently a batch in progress.
	1. If there is, then do nothing.
	2. If there is not, then schedule a batch dispatch task to occur.

It's a pretty simple algorithm. The batch dispatch task follows the exact same steps as the List subscription NOTIFY algorithm from the previous section.

Batching tasks will, at times, need to be canceled since a NOTIFY needs to immediately be sent out. Batching cancellation will occur if:

* The subscriber resubscribes to the list.
* The subscriber terminates its subscription to the list.

Task 3: Multi-Server Support
============================

With Task 2 accomplished, Asterisk will have RLS support on a single server. RLS support would be richer if Asterisk had the ability to subscribe to, receive notifications from, publish to, and receive publications from other SIP servers. With these facilities in place, Asterisk could set up mixed lists of local and remote resources.

While multi-server support would be nice to have, it adds a load of work to be accomplished. With the looming feature freeze of Asterisk 13, this likely will have to wait until the next version of Asterisk to be completed. For now, here are some notes on what would be required to have multi-server support for RLS.

Outbound Subscriptions
----------------------

Asterisk may wish to subscribe to resource lists on external servers. Currently, Asterisk has an API for performing outbound subscriptions, but it is completely unused. More investigation needs to be done in order to determine the usefulness of outbound subscriptions as a general concept in Asterisk, especially outbound subscriptions to list subscriptions.

PUBLISH support, in general, seems like a better idea.

PUBLISH support
---------------

While RLS could be implemented by passing subscriptions through Asterisk to external servers, a preferred method would be to terminate the subscription on the Asterisk server and receive SIP PUBLISHes to update state on remote resources. When a subscription arrives, the resource being subscribed to may or may not exist on the Asterisk server. If the resource does not exist, then instead of rejecting the SUBSCRIBE request, Asterisk will instead accept the request and keep the subscription in a pending state if state cannot be determined for the requested resource. External resources can then PUBLISH state to Asterisk, and Asterisk can NOTIFY interested parties of the state of the resource.

The flip-side of this is that Asterisk could also be configured to PUBLISH the state of local resources to remote servers. This would allow for a cluster of Asterisk boxes to be able to share the state of various resources between each other and allow for devices on any individual Asterisk server to be given the state of resources on any of the servers.

As far as RLS is concerned, this would allow for resource lists to consist of both local and remote resources.

We already have a bit of a head start on PUBLISH support since we have an API for handling incoming PUBLISH in res\_pjsip\_pubsub.c. However, there is much more work that would need to be done in order to have full multi-server support, including:

* Modifying the core PBX code such that it is not dependent on handling only local extension states.
* Modifying the pubsub API to know about pending subscriptions and how to indicate these properly.
* Writing parsers for body documents that can be received in incoming PUBLISH requests.
* Writing an API for sending outbound PUBLISHes. Initially, it was thought we would use PJSIP's API directly, but given that we will have the same abstraction requirements for publications that we have for RLS, using the PJSIP API directly is not an option. This API would need to include resource list publication support as well.
* While stasis currently has the concept of internal and external resources built into it, it's probably important for this to be built into the pubsub core as well. For instance, URIs generated for resources are currently only concerned with the user portion, since the domain part corresponds to the local Asterisk box. However, with remote resources, the URI will need to be constructed differently.
* A configuration section that illustrates what to publish and to whom, and whether to publish the resources as a list or as individual publications.
