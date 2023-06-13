---
title: Event Subscription and Publication Design
pageid: 22773838
---


This page is a work in progress. Please do not make comments on this until this warning is removed


Asterisk's SIP implementation has a need for supporting RFC 3265's event subscription system since the original `chan_sip` had support for it.


Requirements
============


Asterisk needs to fully support RFC 3265. Support should be approached in a modular fashion. It should be easy to write a module that handles a specific Event and Accept type. So for instance, a module should exist for the "presence" event and the "application/pidf" type. A separate module should exist for the "presence" event and the "application/xpidf" type.


Pubsub core
===========


The core of the pubsub feature comes in Asterisk's ability to register different event types as being handled. A module can register itself as a subscription handler for a specific event type. By doing so, Asterisk will know to call into that module when SUBSCRIBE or NOTIFY requests or responses are received for that event type.


At the base of it all is PJSIP's evsub framework. It takes care of a large portion of our job for us, like maintaining timers, maintaining the state of the subscription, and maintaining the state of the underlying dialog and transactions. Asterisk's pubsub core will sit on top of this and help further take care of automatic duties. The pubsub core will also help to associate PJSIP's event subscriptions with our own representation. Asterisk's pubsub core will also provide some abstractions for common dealings in PJSIP.


PJSIP's evsub API is quite extensive, and there is no good reason to try to completely hide it from subscription handlers. Thus Asterisk will not attempt to wrap every single thing that the evsub API provides. However, certain operations will be wrapped if there are additional duties that will be performed by the core or if it makes things easier to handle.


API
===


Base subscription structure
---------------------------


The pubsub framework is based around an opaque structure called `ast_sip_subscription`. This structure is the basis for all subscriptions and is used in the majority of functions in the API. The following are functions involving the `ast_sip_subscription`.


c
/\*!
 \* \brief Opaque structure representing an RFC 3265 SIP subscription
 \*/
struct ast\_sip\_subscription;

/\*!
 \* \brief Role for the subscription that is being created
 \*/
enum ast\_sip\_subscription\_role {
 /\* Sending SUBSCRIBEs, receiving NOTIFYs \*/
 AST\_SIP\_SUBSCRIBER,
 /\* Sending NOTIFYs, receiving SUBSCRIBEs \*/
 AST\_SIP\_NOTIFIER,
};

/\*!
 \* \brief Create a new ast\_sip\_subscription structure
 \*
 \* \param handler The subsription handler for this subscription
 \* \param role Whether we are acting as subscriber or notifier for this subscription
 \* \param endpoint The endpoint involved in this subscription
 \* \param rdata If acting as a notifier, the SUBSCRIBE request that triggered subscription creation
 \*/
struct ast\_sip\_subscription \*ast\_sip\_create\_subscription(const struct ast\_sip\_subscription\_handler \*handler,
 enum ast\_sip\_subscription\_role role, struct ast\_sip\_endpoint \*endpoint, pjsip\_rx\_data \*rdata);


/\*!
 \* \brief Get the endpoint that is associated with this subscription
 \*
 \* \retval NULL Could not get endpoint
 \* \retval non-NULL The endpoint
 \*/
struct ast\_sip\_endpoint \*ast\_sip\_subscription\_get\_endpoint(struct ast\_sip\_subscription \*sub);

/\*!
 \* \brief Get the serializer for the subscription
 \*
 \* Tasks that originate outside of a SIP servant thread should get the serializer
 \* and push the task to the serializer.
 \*
 \* \param sub The subscription
 \* \retval NULL Failure
 \* \retval non-NULL The subscription's serializer
 \*/
struct ast\_sip\_serializer \*ast\_sip\_subscription\_get\_serializer(struct ast\_sip\_subscription \*sub);

/\*!
 \* \brief Get the underlying PJSIP evsub structure
 \*
 \* This is useful when wishing to call PJSIP's API calls in order to
 \* create SUBSCRIBEs, NOTIFIES, etc. as well as get subscription state
 \*
 \* This function, as well as all methods called on the pjsip\_evsub should
 \* be done in a SIP servant thread.
 \*
 \* \param sub The subscription
 \* \retval NULL Failure
 \* \retval non-NULL The underlying pjsip\_evsub
 \*/
pjsip\_evsub \*ast\_sip\_subscription\_get\_evsub(struct ast\_sip\_subscription \*sub);

/\*!
 \* \brief Send a request created via a PJSIP evsub method
 \*
 \* Callers of this function should take care to do so within a SIP servant
 \* thread.
 \*
 \* \param sub The subscription on which to send the request
 \* \param tdata The request to send
 \* \retval 0 Success
 \* \retval non-zero Failure
 \*/
int ast\_sip\_subscription\_send\_request(struct ast\_sip\_subscription \*sub, pjsip\_tx\_data \*tdata);

/\*!
 \* \brief Alternative for ast\_datastore\_alloc()
 \*
 \* There are two major differences between this and ast\_datastore\_alloc()
 \* 1) This allocates a refcounted object
 \* 2) This will fill in a uid if one is not provided
 \*
 \* DO NOT call ast\_datastore\_free() on a datastore allocated in this
 \* way since that function will attempt to free the datastore rather
 \* than play nicely with its refcount.
 \*
 \* \param info Callbacks for datastore
 \* \param uid Identifier for datastore
 \* \retval NULL Failed to allocate datastore
 \* \retval non-NULL Newly allocated datastore
 \*/
struct ast\_datastore \*ast\_sip\_subscription\_alloc\_datastore(const struct ast\_datastore\_info \*info, const char \*uid);

/\*!
 \* \brief Add a datastore to a SIP subscription
 \*
 \* Note that SIP uses reference counted datastores. The datastore passed into this function
 \* must have been allocated using ao2\_alloc() or there will be serious problems.
 \*
 \* \param subscription The ssubscription to add the datastore to
 \* \param datastore The datastore to be added to the subscription
 \* \retval 0 Success
 \* \retval -1 Failure
 \*/
int ast\_sip\_subscription\_add\_datastore(struct ast\_sip\_subscription \*subscription, struct ast\_datastore \*datastore);

/\*!
 \* \brief Retrieve a subscription datastore
 \*
 \* The datastore retrieved will have its reference count incremented. When the caller is done
 \* with the datastore, the reference counted needs to be decremented using ao2\_ref().
 \*
 \* \param subscription The subscription from which to retrieve the datastore
 \* \param name The name of the datastore to retrieve
 \* \retval NULL Failed to find the specified datastore
 \* \retval non-NULL The specified datastore
 \*/
struct ast\_datastore \*ast\_sip\_subscription\_get\_datastore(struct ast\_sip\_subscription \*subscription, const char \*name);

/\*!
 \* \brief Remove a subscription datastore from the subscription
 \*
 \* This operation may cause the datastore's free() callback to be called if the reference
 \* count reaches zero.
 \*
 \* \param subscription The subscription to remove the datastore from
 \* \param name The name of the datastore to remove
 \*/
void ast\_sip\_subscription\_remove\_datastore(struct ast\_sip\_subscription \*subscription, const char \*name);

Subscription handlers
---------------------


Subscription handlers are what are responsible for handling specific event packages. Subscription handlers act as the barrier between Asterisk and PJSIP in that they take Asterisk data and make appropriate SIP requests. Subscription handlers also are called into by the pubsub core when changes in subscription state occur.


c

/\*!
 \* \brief Data for responses to SUBSCRIBEs and NOTIFIEs
 \*
 \* Some of PJSIP's evsub callbacks expect us to provide them
 \* with data so that they can craft a response rather than have
 \* us create our own response.
 \*
 \* The entire structure is itself optional, since the framework
 \* will automatically respond with a 200 OK response if we do
 \* not provide it with any data.
 \*/
struct ast\_sip\_subscription\_response\_data {
 /\*! Status code of the response \*/
 int status\_code;
 /\*! Optional status text \*/
 const char \*status\_text;
 /\*! Optional additional headers to add to the response \*/
 struct ast\_variable \*headers;
 /\*! Optional body to add to the response \*/
 struct ast\_sip\_body \*body;
};

struct ast\_sip\_subscription\_handler {
 /\*! The name of the event this handler deals with \*/
 const char \*event\_name;
 /\*! The types of body this handler accepts \*/
 const char \*accept[];

 /\*!
 \* \brief Called when a subscription is to be destroyed
 \*
 \* This is a subscriber and notifier callback.
 \*
 \* The handler is not expected to send any sort of requests or responses
 \* during this callback. This callback is useful for performing any
 \* necessary cleanup
 \*/
 void (\*subscription\_shutdown)(struct ast\_sip\_subscription \*subscription);

 /\*!
 \* \brief Called when a SUBSCRIBE arrives in order to create a new subscription
 \*
 \* This is a notifier callback.
 \*
 \* If the notifier wishes to accept the subscription, then it can create
 \* a new ast\_sip\_subscription to do so. 
 \*
 \* If the notifier chooses to create a new subscription, then it must accept
 \* the incoming subscription using pjsip\_evsub\_accept() and it must also
 \* send an initial NOTIFY with the current subscription state.
 \*
 \* \param endpoint The endpoint from which we received the SUBSCRIBE
 \* \param rdata The SUBSCRIBE request
 \* \retval NULL The SUBSCRIBE has not been accepted
 \* \retval non-NULL The newly-created subscription
 \*/
 struct ast\_sip\_subscription \*(\*new\_subscribe)(struct ast\_sip\_endpoint \*endpoint,
 pjsip\_rx\_data \*rdata);

 /\*!
 \* \brief Called when an endpoint renews a subscription.
 \*
 \* This is a notifier callback.
 \*
 \* Because of the way that the PJSIP evsub framework works, it will automatically
 \* send a response to the SUBSCRIBE.
 \*
 \* \param sub The subscription that is being renewed
 \* \param rdata The SUBSCRIBE request in question
 \* \retval NULL Allow the default 200 OK response to be sent
 \* \retval non-NULL Send a response with the specified data present
 \*/
 struct ast\_sip\_subscription\_response\_data \*(\*resubscribe)(struct ast\_sip\_subscription \*sub,
 pjsip\_rx\_data \*rdata);

 /\*!
 \* \brief Called when a subscription times out.
 \*
 \* This is a notifier callback
 \*
 \* This indicates that the subscription has timed out. The subscription handler is
 \* expected to send a NOTIFY that terminates the subscription.
 \*
 \* \param sub The subscription that has timed out
 \*/
 void (\*subscription\_timeout)(struct ast\_sip\_subscription \*sub);

 /\*!
 \* \brief Called when a subscription is terminated via a SUBSCRIBE request
 \*
 \* This is a notifier callback.
 \*
 \* The PJSIP subscription framework will automatically send the response to the
 \* SUBSCRIBE. The subscription handler is expected to send a final NOTIFY to
 \* terminate the subscription.
 \*
 \* \param sub The subscription being terminated
 \* \param rdata The SUBSCRIBE request that terminated the subscription
 \*/
 void (\*subscription\_terminated)(struct ast\_sip\_subscription \*sub, pjsip\_rx\_data \*rdata);

 /\*!
 \* \brief Called when a subscription handler's outbound NOTIFY receives a response
 \*
 \* This is a notifier callback.
 \*
 \* \param sub The subscription
 \* \param rdata The NOTIFY response
 \*/
 void (\*notify\_response)(struct ast\_sip\_subscription \*sub, pjsip\_rx\_data \*rdata);

 /\*!
 \* \brief Called when a subscription handler receives an inbound NOTIFY
 \*
 \* This is a subscriber callback.
 \*
 \* Because of the way that the PJSIP evsub framework works, it will automatically
 \* send a response to the NOTIFY. By default this will be a 200 OK response, but
 \* this callback can change details of the response by returning response data
 \* to use.
 \*
 \* \param sub The subscription
 \* \param rdata The NOTIFY request
 \* \retval NULL Have the framework send the default 200 OK response
 \* \retval non-NULL Send a response with the specified data
 \*/
 struct ast\_sip\_subscription\_response\_data \*(\*notify\_request)(struct ast\_sip\_subscription \*sub,
 pjsip\_rx\_data \*rdata);

 /\*!
 \* \brief Called when it is time for a subscriber to resubscribe
 \*
 \* This is a subscriber callback.
 \*
 \* The subscriber can reresh the subscription using the pjsip\_evsub\_initiate()
 \* function.
 \*
 \* \param sub The subscription to refresh
 \* \retval 0 Success
 \* \retval non-zero Failure
 \*/
 int (\*refresh\_subscription)(struct ast\_sip\_subscription \*sub);
};

/\*!
 \* \brief Register a subscription handler
 \*
 \* \retval 0 Handler was registered successfully
 \* \retval non-zero Handler was not registered successfully
 \*/
int ast\_sip\_register\_subscription\_handler(const struct ast\_sip\_subscription\_handler \*handler);

/\*!
 \* \brief Unregister a subscription handler
 \*/
void ast\_sip\_unregister\_subscription\_handler(const struct ast\_sip\_subscription\_handler \*handler);

Event publication
=================


In addition to supporting the SUBSCRIBE/NOTIFY methods specified in RFC 3265, we also wish to have support for the PUBLISH method defined in RFC 3903. PJSIP provides client support for event publication, but it has no such support for serving as an event state compositor. Unfortunately, Asterisk is much more likely to be needed as an event state compositor than as an event publication agent.


When acting as an event publication agent, Asterisk will use the PJSIP publish API directly. Any amount of state that needs to be kept can be done locally as needed.


When acting as an event state compositor, there will be a core set of Asterisk APIs to use instead, as well as a structure that can be used for accumulating state.


PUBLISH API
===========


c
/\*!
 \* \brief Opaque structure representing a publication
 \*/
struct ast\_sip\_publication;

/\*!
 \* \brief Callbacks that publication handlers will define
 \*/
struct ast\_sip\_publication\_handler {
 /\*!
 \* \brief Called when a PUBLISH to establish a new publication arrives.
 \*
 \* \param endpoint The endpoint from whom the PUBLISH arrived
 \* \param rdata The PUBLISH request
 \* \retval NULL PUBLISH was not accepted
 \* \retval non-NULL New publication
 \*/
 struct ast\_sip\_publication \*(\*new\_publication)(struct ast\_sip\_endpoint \*endpoint, pjsip\_rx\_data \*rdata);
 /\*!
 \* \brief Called when a PUBLISH for an existing publication arrives.
 \*
 \* This PUBLISH may be intending to change state or it may be simply renewing
 \* the publication since the publication is nearing expiration. The callback
 \* is expected to send a response to the PUBLISH.
 \*
 \* \param pub The publication on which the PUBLISH arrived
 \* \param rdata The PUBLISH request
 \* \retval 0 Publication was accepted
 \* \retval non-zero Publication was denied
 \*/
 int (\*publish\_refresh)(struct ast\_sip\_publication \*pub, pjsip\_rx\_data \*rdata);
 /\*!
 \* \brief Called when a publication has reached its expiration.
 \*/
 void (\*publish\_expire)(struct ast\_sip\_publication \*pub);
 /\*!
 \* \brief Called when a PUBLISH arrives to terminate a publication.
 \*
 \* The callback is expected to send a response for the PUBLISH.
 \*
 \* \param pub The publication that is terminating
 \* \param rdata The PUBLISH request terminating the publication
 \*/
 void (\*publish\_termination)(struct ast\_sip\_publication \*pub, pjsip\_rx\_data \*rdata);
};

/\*!
 \* \brief Create a new publication
 \*
 \* Publication handlers should call this when a PUBLISH arrives to establish a new publication.
 \*
 \* \param endpoint The endpoint from whom the PUBLISHes arrive
 \* \param rdata The PUBLISH that established the publication
 \* \retval NULL Failed to create a publication
 \* \retval non-NULL The newly-created publication
 \*/
struct ast\_sip\_publication \*ast\_sip\_create\_publication(struct ast\_sip\_endpoint \*endpoint, pjsip\_rx\_data \*rdata);

/\*!
 \* \brief Given a publication, get the associated endpoint
 \*
 \* \param pub The publication
 \* \retval NULL Failure
 \* \retval non-NULL The associated endpoint
 \*/
struct ast\_sip\_endpoint \*ast\_sip\_publication\_get\_endpoint(struct ast\_sip\_publication \*pub);

/\*!
 \* \brief Create a response to an inbound PUBLISH
 \*
 \* The created response can be sent using pjsip\_endpt\_send\_response() or pjsip\_endpt\_send\_response2()
 \*
 \* \param pub The publication
 \* \param status code The status code to place in the response
 \* \param rdata The request to which the response is being made
 \* \param[out] tdat The created response
 \*/
int ast\_sip\_publication\_create\_response(struct ast\_sip\_publication \*pub, int status\_code, pjsip\_rx\_data \*rdata);

/\*!
 \* \brief Alternative for ast\_datastore\_alloc()
 \*
 \* There are two major differences between this and ast\_datastore\_alloc()
 \* 1) This allocates a refcounted object
 \* 2) This will fill in a uid if one is not provided
 \*
 \* DO NOT call ast\_datastore\_free() on a datastore allocated in this
 \* way since that function will attempt to free the datastore rather
 \* than play nicely with its refcount.
 \*
 \* \param info Callbacks for datastore
 \* \param uid Identifier for datastore
 \* \retval NULL Failed to allocate datastore
 \* \retval non-NULL Newly allocated datastore
 \*/
struct ast\_datastore \*ast\_sip\_subscription\_alloc\_datastore(const struct ast\_datastore\_info \*info, const char \*uid);

/\*!
 \* \brief Add a datastore to a SIP subscription
 \*
 \* Note that SIP uses reference counted datastores. The datastore passed into this function
 \* must have been allocated using ao2\_alloc() or there will be serious problems.
 \*
 \* \param subscription The ssubscription to add the datastore to
 \* \param datastore The datastore to be added to the subscription
 \* \retval 0 Success
 \* \retval -1 Failure
 \*/
int ast\_sip\_subscription\_add\_datastore(struct ast\_sip\_subscription \*subscription, struct ast\_datastore \*datastore);

/\*!
 \* \brief Retrieve a subscription datastore
 \*
 \* The datastore retrieved will have its reference count incremented. When the caller is done
 \* with the datastore, the reference counted needs to be decremented using ao2\_ref().
 \*
 \* \param subscription The subscription from which to retrieve the datastore
 \* \param name The name of the datastore to retrieve
 \* \retval NULL Failed to find the specified datastore
 \* \retval non-NULL The specified datastore
 \*/
struct ast\_datastore \*ast\_sip\_subscription\_get\_datastore(struct ast\_sip\_subscription \*subscription, const char \*name);

/\*!
 \* \brief Remove a subscription datastore from the subscription
 \*
 \* This operation may cause the datastore's free() callback to be called if the reference
 \* count reaches zero.
 \*
 \* \param subscription The subscription to remove the datastore from
 \* \param name The name of the datastore to remove
 \*/
void ast\_sip\_subscription\_remove\_datastore(struct ast\_sip\_subscription \*subscription, const char \*name);
