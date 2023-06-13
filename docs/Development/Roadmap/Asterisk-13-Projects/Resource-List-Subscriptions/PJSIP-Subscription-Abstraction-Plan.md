---
title: PJSIP Subscription Abstraction Plan
pageid: 28934231
---

As explained on the parent page, the current pubsub API in res\_pjsip\_pubsub does not abstract away the underlying PJSIP implementation. This page details the current problems and how they should be fixed.

Tweaks to `ast_sip_subscription`
================================

`ast_sip_subscription` currently assumes that all subscriptions align with an actual SUBSCRIBE dialog within PJSIP, like the following:

simple\_subscription

With RLS, `ast_sip_subscription` needs to be able to form a tree of subscriptions, with a "real" list subscription at the root of the tree and "virtual" leaf subscriptions, like the following:

complex\_sip\_subscriptions

Subscription handlers may no longer be able to directly send NOTIFYs on one of their `ast_sip_subscriptions` because the subscription does not directly correlate to a real SIP subscription. This means that anything the subscription handlers were doing previously where they would reach across the `res_pjsip_pubsub` layer into PJSIP will no longer be valid.

Internal changes
================

There will be many internal changes that get made as part of RLS work, but the only change that needs to be made is to alter the `ast_sip_subscription` structure so it may more easily conform to the drawing above.

The following will need to be removed from the `ast_list_subscription` structure:

struct ast\_sip\_subscription {
 pjsip\_evsub \*evsub;
};With the division between real and virtual subscriptions, it makes no sense for virtual subscriptions to have a pointer to a `pjsip_evsub`. Instead, having a pointer to the parent subscription makes much more sense. Real subscriptions should still have a pointer to the PJSIP subscription, though. A union works well for this. Given the tree-like structure of `ast_sip_subscription`, appropriate fields need to be added to support this. As a final change, since users of the pubsub API will need access to the data, the name of the subscribed resource will need to be added to the structure.

 enum sip\_subscription\_type {
 SIP\_SUBSCRIPTION\_REAL,
 SIP\_SUBSCRIPTION\_VIRTUAL,
}; 
 
struct ast\_sip\_subscription {
 /\*! Name of the subscribed resource \*/
 const char \*resource;
 /\*! Indicator if subscription is real or virtual \*/
 enum sip\_subscription\_type type;
 union {
 /\*! Real subscriptions point to a PJSIP subscription \*/
 pjsip\_evsub \*evsub;
 /\*! Virtual subscriptions point to a parent Asterisk subscription \*/
 struct ast\_sip\_subscription \*parent;
 };
 /\*! List of child subscriptions \*/
 AST\_LIST\_HEAD(,ast\_sip\_subscription) children;
}; General API changes
===================

The biggest removals from the API are the following:

pjsip\_evsub \*ast\_sip\_subscription\_get\_evsub(struct ast\_sip\_subscription \*sub);
pjsip\_dialog \*ast\_sip\_subscription\_get\_dlg(struct ast\_sip\_subscription \*sub);Those two functions assume that the subscription has a corresponding PJSIP subscription. However, users of the pubsub API can no longer make such an assumption since the subscription they interact with may be virtual. The main uses of these two functions by subscription handlers were as follows:

* Getting the `pjsip_evsub` in order to transmit a NOTIFY request.
* Getting the `pjsip_evsub` in order to accept an inbound SUBSCRIBE request.
* Getting the `pjsip_evsub` to get the current subscription state.
* Getting the `pjsip_evsub` to terminate a subscription on an inbound SUBSCRIBE request.
* Getting the `pjsip_dialog` to get local and remote information.

In order to satisfy previously-required functionality, new calls will be added to the pubsub API to replace the old functionality. Each of these API calls, when initially written, will propagate up the tree of subscriptions, resulting in similar operations to what were previously being done.

/\*! Notify a SIP subscription of a state change.
 \* This will create a SIP NOTIFY request, send the notify\_data to
 \* a body generator, and then send the NOTIFY request out.
 \*/
int ast\_sip\_subscription\_notify(struct ast\_sip\_subscription \*sub, void \*notify\_data);
 
/\*! Reject an incoming SIP SUBSCRIBE request.
 \* This will send the specified response to the SUBSCRIBE. If a
 \* NULL reason is specified, then default reason text will be used.
 \*/
void ast\_sip\_subscription\_reject(struct ast\_sip\_subscription \*sub, int response, const char \*reason);
 
/\*! Accept an incoming SIP SUBSCRIBE request with a 200 OK. \*/
void ast\_sip\_subscription\_accept(struct ast\_sip\_subscription \*sub);
 
/\*! Retrieve the local URI for this subscription \*/
void ast\_sip\_subscription\_get\_local\_uri(struct ast\_sip\_subscription \*sub, char \*buf, size\_t size);
 
/\*! Retrive the remote URI for this subscription \*/
void ast\_sip\_subscription\_get\_remote\_uri(struct ast\_sip\_subscription \*sub, char \*buf, size\_t size);
 
/\*! Terminate an active SIP subscription. \*/
void ast\_sip\_subscription\_terminate(struct ast\_sip\_subscripiton \*sub);
 
You'll notice that there is no function to get the current subscription state. This is because state can be determined by the core pubsub API in most cases or can be determined based on the operation being performed. For instance, if `ast_sip_subscription_terminate` is called by a notifier, then the pubsub core will rightly set the subscription state as "terminated".

Subscriber-side API additions will be required in addition, but those changes are being saved for the larger-scale [Outbound Subscriptions](https://wiki.asterisk.org/wiki/display/AST/Resource+List+Subscriptions#ResourceListSubscriptions-OutboundSubscriptions) task to be accomplished later.

Changes to notifier usage
=========================

The `ast_sip_subscription_handler` structure will also need to be altered to rid itself of PJSIP-specific structures. Specifically, the following callbacks will need to be altered:

struct ast\_sip\_subscription\_handler {
 struct ast\_sip\_subscription \*(\*new\_subscribe)(struct ast\_sip\_endpoint \*endpoint,
 pjsip\_rx\_data \*rdata);
 void (\*resubscribe)(struct ast\_sip\_subscription \*sub,
 pjsip\_rx\_data \*rdata, struct ast\_sip\_subscription\_response\_data \*response\_data);
 void (\*subscription\_terminated)(struct ast\_sip\_subscription \*sub, pjsip\_rx\_data \*rdata);
 void (\*notify\_response)(struct ast\_sip\_subscription \*sub, pjsip\_rx\_data \*rdata);
};All of these currently contain a `pjsip_rx_data` structure as a parameter. A notifier no longer can can operate on a `pjsip_rx_data` structure since the subscription as a whole may not pertain to the list member that the notifier is handling. In practice, a notifier should never need an entire SIP request to operate on; they care about the resource that is being subscribed to. Given that notifiers will not be directly responding to SIP requests, it means that the API can be made easier to use for notifiers. Also, since edits are being made in this area, a long-standing personal desire to separate subscribers and notifiers can be done here.

enum ast\_sip\_subscription\_notify\_reason {
 /\*! Initial NOTIFY for subscription \*/
 AST\_SIP\_SUBSCRIPTION\_NOTIFY\_REASON\_STARTED,
 /\*! Subscription has been renewed \*/
 AST\_SIP\_SUBSCRIPTION\_NOTIFY\_REASON\_RENEWED,
 /\*! Subscription is being terminated \*/
 AST\_SIP\_SUBSCRIPTION\_NOTIFY\_REASON\_TERMINATED,
 /\*! Other unspecified reason \*/
 AST\_SIP\_SUBSCRIPTION\_NOTIFY\_REASON\_OTHER
};
 
struct ast\_sip\_subscription\_notifier {
 /\*! Return the response code for the incoming SUBSCRIBE request \*/
 int (\*new\_subscribe)(struct ast\_sip\_endpoint \*endpoint, const char \*resource);
 /\*! Subscription is in need of a NOTIFY \*/
 void (notify\_required)(struct ast\_sip\_subscription \*sub, enum ast\_sip\_subscription\_notify\_reason reason);
};
 
/\*! Get the name of a subscribed resource \*/
const char \*ast\_sip\_subscription\_get\_resource\_name(struct ast\_sip\_subscription \*sub);The biggest change is the one being made to the `new_subscribe` callback. Previously, this callback required the notifier to respond to the SIP SUBSCRIBE, then create an `ast_sip_subscription` structure, send an initial NOTIFY request, and then return the created `ast_sip_subscription`. The callback has been simplified greatly. Now, the notifier returns a response code for the pubsub core to send in response to the SUBSCRIBE request. If the response is a 200-class response, then the pubsub core will create the `ast_sip_subscription` itself, then immediately call back into the notifier with the `notify_required` callback in order to send the initial NOTIFY. At first, this appears to give a disadvantage over the previous version since the notifier will not have access to the `ast_sip_subscription` structure in the `new_subscribe` callback. However, since the `notify_required` callback is guranteed to be immediately called into with `AST_SIP_SUBSCRIPTION_NOTIFY_REASON_STARTED` as the reason, the notifier can use that opportunity to do anything that requires the subscription, such as setting up the underlying stasis subscription or adding datastores.

The `notify_required` callback tells the notifier that it needs to generate a NOTIFY. The reason lets the notifier know why the NOTIFY is needed. Because one of the reasons is `AST_SIP_SUBSCRIPTION_NOTIFY_REASON_TERMINATED` there is no reason to have a separate `subscription_terminated` callback for notifiers.

Note that the old `notify_response` callback is completely gone now. Notifiers do not have any need to know what the response to their NOTIFY was. The pubsub core can handle off-nominal paths, to include asking the notifier to try sending again or terminating the subscription.

Changes to subscriber usage
===========================

More in-depth subscriber usage changes may happen at a later date; however, a prerequisite is to make sure that inadequate subscriber callbacks in the `ast_sip_subscription_handler` structure are abstracted. The old subscriber-specific callbacks need to be converted not to use PJSIP-specific structures. Here are the parts that need conversion:

struct ast\_sip\_subscription \*ast\_sip\_create\_subscription(const struct ast\_sip\_subscription\_handler \*handler,
 enum ast\_sip\_subscription\_role role, struct ast\_sip\_endpoint \*endpoint, pjsip\_rx\_data \*rdata);
 
struct ast\_sip\_subscription\_handler {
 void (\*subscription\_terminated)(struct ast\_sip\_subscription \*sub, pjsip\_rx\_data \*rdata);
 void (\*notify\_request)(struct ast\_sip\_subscription \*sub,
 pjsip\_rx\_data \*rdata, struct ast\_sip\_subscription\_response\_data \*response\_data);
 int (\*refresh\_subscription)(struct ast\_sip\_subscription \*sub);
}Here is the revised version:

/\*! Create a new outbound SIP subscription to the requested resource at the requested endpoint. \*/
struct ast\_sip\_subscription \*ast\_sip\_create\_subscription(const struct ast\_sip\_subscriber \*subscriber,
 struct ast\_sip\_endpoint \*endpoint, const char \*resource);
 
struct ast\_sip\_subscriber {
 /\*! A NOTIFY has been received with the attached body. \*/
 void (\*state\_change)(struct ast\_sip\_subscription \*sub, const char \*body, enum pjsip\_evsub\_state state);
}`ast_sip_create_subscription` is now only used by subscribers; notifiers have no need to create subscriptions themselves. As such, in addition to creating the `ast_sip_subscription` structure, it will also send out the initial SUBSCRIBE request to the specified resource at the specified endpoint.

As was noted with notifiers earlier, `ast_sip_subscription_handler` is being replaced by separate notifier and subscriber structures. The subscriber structure has a few major changes. `refresh_subscription` has been removed since the pubsub core will handle it. `notify_request` has been altered to be `state_change` now. Instead of being given the entire NOTIFY request, the subscriber is given the relevant body from the NOTIFY request as well as the subscription state. If the state is `PJSIP_EVSUB_STATE_TERMINATED` then the subscriber can know that the subscription has been terminated. Because of this, there is no need for a `subscription_terminated` callback.

Changes to publish handler usage
================================

Publisher changes are similar to notifier changes. Here are the areas where publication handling needs to be altered:

struct ast\_sip\_publication\_handler {
 struct ast\_sip\_publication \*(\*new\_publication)(struct ast\_sip\_endpoint \*endpoint, pjsip\_rx\_data \*rdata);
 int (\*publish\_refresh)(struct ast\_sip\_publication \*pub, pjsip\_rx\_data \*rdata);
 void (\*publish\_termination)(struct ast\_sip\_publication \*pub, pjsip\_rx\_data \*rdata);
};
 
struct ast\_sip\_publication \*ast\_sip\_create\_publication(struct ast\_sip\_endpoint \*endpoint, pjsip\_rx\_data \*rdata);Here is the revised edition:

enum ast\_sip\_publish\_state {
 /\*! Publication has just been initialized \*/
 AST\_SIP\_PUBLISH\_STATE\_INITIALIZED,
 /\*! Publication is currently active \*/
 AST\_SIP\_PUBLISH\_STATE\_ACTIVE,
 /\*! Publication has been terminated \*/
 AST\_SIP\_PUBLISH\_STATE\_TERMINATED,
}; 
 
struct ast\_sip\_publication\_handler {
 /\*! New publication has arrived. Return appropriate SIP response code \*/
 int (\*new\_publication)(struct ast\_sip\_endpoint \*endpoint, const char \*resource);
 /\*! Published resource has changed states. Use the state parameter to determine if publication is terminated. \*/
 int (\*publication\_state\_change)(struct ast\_sip\_publication \*pub, const char \*body, enum ast\_sip\_publish\_state state);
};
 
const char \*ast\_sip\_publish\_get\_resource(struct ast\_sip\_publication \*pub);Like with the notifier, the `new_publication` callback is being simplified just to be an indicator if the PUBLISH should be accepted or not. The pubsub core will take care of creating the publication and will then immediately call into the `publication_state_change` callback to relay the actual PUBLISH body to the handler. `publish_refresh` and `publish_termination` are not needed since the `publication_state_change` covers their functionality.

