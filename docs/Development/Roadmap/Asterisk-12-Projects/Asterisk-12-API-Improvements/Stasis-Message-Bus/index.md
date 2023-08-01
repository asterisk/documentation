---
title: Overview
pageid: 22086002
---

INLINE

While the basic API's for the Stasis Message Bus are documented using Doxygen, there's still a lot to be said about how to use those API's within Asterisk.

{toc:style=none}

# Message Bus

The overall stasis-core API can be best described as a publish/subscribe message bus.

Data that needs to be published on the message bus is encapsulated in a `stasis_message`, which associates the message data (which is simply an AO2 managed `void \*`) along with a `stasis_message_type`. (The message also has the `timeval` when it was created, which is generally useful, since messages are received asynchronously).

Messages are published to a `stasis_topic`. To receive the messages published to a topic, use `stasis_subscribe()` to create a subscription.

When topics are subscribed to/unsubscribed to, `stasis_subscription_change` are sent to all of the topic's subscribers. On unsubscribe, the `stasis_subscription_change` will be the last message received by the unsubscriber, which can be used to kick off any cleanup that might be necessary. The convenience function `stasis_subscription_final_message()` can be used to check if a message is the final unsubscribe message.

To forward all of the messages from one topic to another, use `stasis_forward_all()`. This is useful for creating aggregation topics, like `[ast_channel_topic_all()|#ast_channel_topic_all()]`, which collect all of the messages published to a set of other topics.

## Routing and Caching

In addition to these fundamental concepts, there are a few extra objects in the Stasis Message Bus arsenal.

For subscriptions that deal with many different types of messages, the `stasis_message_router` can be used to route messages based on type. This gets rid of a lot of ugly looking `if/else` chains and replaces them with callback dispatch.

Another common use case within Asterisk is to have a subscription that monitors state changes for snapshots that are published to a topic. To aid in this, we have `stasis_caching_topic`. This is a _topic filter_, which presents its own topic with filtered and modified messages from an original topic. In the case of the caching topic, it watches for snapshot messages, compares them with their prior values. For these messages, it publishes a `stasis_cache_update` message with both the old and new values of the snapshot.

## Design Philosophy

By convention (since there's no effective way to enforce this in C), messages are immutable. Not only the `stasis_message` type itself, but also the data it contains. This allows messages to be shared freely throughout the system without locking. If you find yourself in the situation where you want to modify the contents of a `stasis_message`, what you actually want to do is copy the message, and change the copy. While on the surface this seems wasteful and inefficient, the gains in reducing lock contention win the day.

Messages are opaque to the message bus, so you don't have to modify `stasis.c` or `stasis.h` to add a new topic or message type.

The `stasis_topic` object is thread safe. Subscribes, unsubscribes and publishes may happen from any thread. There are some ordering guarantees about message delivery, but not many.

* A `stasis_publish()` that begins after a `stasis_publish()` to the same topic completes will be delivered in order.
    * In general, this means that publications from different threads to the same topic are unordered, but publications from the same thread are.
* Publications to different topics are not ordered.
* The final message delivered to a subscription will be the `stasis_subscription_final_message()`.

The callback invocations for a `stasis_topic` are serialized, although invocations can happen out of any thread from the Stasis thread pool. This is a comfortable middle ground between allocating a thread for every subscription (which would result in too many threads in the system) and invoking callbacks in parallel (which can cause insanity). If your particular handling can benefit from being parallelized, then you can dispatch it to a thread pool in your callback.

# Topics and messages

While Stasis allows for the proliferation of many, many message types, we feel that creating too many message types would complicate the overall API. We have a small number of first class objects, (channel snapshots, bridge snapshots, etc.). If a message needs a first class object plus a small piece of additional data, `blob` objects are provided which attach a [JSON object|http://doxygen.asterisk.org/trunk/d4/d05/json_8h.html] to the first class object.

The details of topics and messages are documented [on doxygen.asterisk.org|http://doxygen.asterisk.org/trunk/df/deb/group__StasisTopicsAndMessages.html]. Some of the more important items to be aware of:

## First Class Message Object

### `ast_channel_snapshot`

A snapshot of the primary state of a channel, created by `ast_channel_snapshot_create()`. 

## Second Class Message Objects

### `ast_channel_blob`

Often times, you find that you want to attach a piece of data to a snapshot for your message. For these cases, there's `ast_channel_blob`, which associated a channel snapshot with a JSON object (which is required to have a `type` field identifying it).

These are used to publish messages such as hangup requests, channel variable set events, etc.

## Channel Topics

## `ast_channel_topic(chan)`

This is the topic to which channel associated messages are published, including [channel snapshots|#ast_channel_snaphshot].

## `ast_channel_topic_all()`

This is an aggregation topic, to which all messages published to individual channel topics are forwarded.

## `ast_channel_topic_all_cached()`

This is a caching topic wrapping `ast_channel_topic_all()`, which caches `ast_channel_snaphshot` messages.

# Sample Code

## Publishing messages

```
#include "asterisk/stasis.h"

/*! \brief Some structure containing the content of your message */
struct ast_foo {
 /* stuff */
};

/*! \brief Message type for \ref ast_fo */
struct stasis_message_type \*ast_foo_type(void);

/*!
 * \brief Topic for the foo module.
 */
struct stasis_topic \*ast_foo_topic(void);

```
```
#include "asterisk.h"

ASTERISK_FILE_VERSION(__FILE__, "$Revision$")

#include "asterisk/astobj2.h"
#include "asterisk/module.h"
#include "asterisk/stasis.h"
#include "foo.h"

static struct stasis_message_type \*foo_type;

struct stasis_topic \*foo_topic;

struct stasis_message_type \*ast_foo_type(void)
{
 return foo_type;
}

struct stasis_topic \*ast_foo_topic(void)
{
 return foo_topic;
}

/*!
 * \brief Convenience function to publish an \ref ast_foo message to the
 * \ref foo_topic.
 */
static void publish_foo(struct ast_foo \*foo)
{
 RAII_VAR(struct stasis_message \*, msg, NULL, ao2_cleanup);

 msg = stasis_message_create(foo_type, foo);

 if (!msg) {
 return;
 }

 stasis_publish(foo_topic, msg);
}

/*
 * Imagine lots of cool foo-related code here, which uses the above
 * publish_foo message. Other foo-related messages may also be published
 * to the foo_topic.
 */

static int unload_module(void)
{
 ao2_cleanup(foo_type);
 foo_type = NULL;
 ao2_cleanup(foo_topic);
 foo_topic = NULL;
 return 0;
}

static int load_module(void)
{
 foo_type = stasis_message_type_create("ast_foo");
 if (!foo_type) {
 return AST_MODULE_LOAD_FAILURE;
 }
 foo_topic = stasis_topic_create("foo");
 if (!foo_topic) {
 return AST_MODULE_LOAD_FAILURE;
 }
 return AST_MODULE_LOAD_SUCCESS;
}

AST_MODULE_INFO(ASTERISK_GPL_KEY, 0, "The wonders of foo",
 .load = load_module,
 .unload = unload_module
 );

```

## Subscribing (no message router)

```
#include "asterisk/astobj2.h"
#include "asterisk/stasis.h"
#include "foo.h"

struct ast_bar {
 struct stasis_subscription \*sub;
};

static void bar_dtor(void \*obj)
{
 struct ast_bar \*bar = obj;

 /* Since the subscription holds a reference, unsubscribe
 * should happen before destruction.
 */
 ast_assert(bar->sub == NULL);
}


static void bar_callback(void \*data,
 struct stasis_subscription \*sub,
 struct stasis_topic \*topic,
 struct stasis_message \*message)
{
 struct ast_bar \*bar = data;

 if (stasis_subscription_final_message(sub, message)) {
 /* Final message; we can clean ourselves u */
 ao2_cleanup(bar);
 return;
 }

 if (ast_foo_type() == stasis_message_type(message)) {
 struct ast_foo \*foo = stasis_message_data(message);
 /* A fooing we will go.. */
 } else if (ast_whatever_type() == stasis_message_type(message)) {
 struct ast_whatever \*whatever = stasis_message_data (message);
 /* whateve */
 }
}

struct ast_bar \*ast_bar_create(void)
{
 RAII_VAR(struct ast_bar \*, bar, NULL, ao2_cleanup);

 bar = ao2_alloc(sizeof(\*bar), bar_dtor);
 if (!bar) {
 return NULL;
 }

 bar->sub = stasis_subscribe(ast_foo_topic(), bar_callback, bar);
 if (!bar->sub) {
 return NULL;
 }

 ao2_ref(bar, +1); /* The subscription hold a ref to ba */

 ao2_ref(bar, +1); /* And we're returning a ref to ba */
 return bar;
}

void ast_bar_shutdown(struct ast_bar \*bar)
{
 if (!bar) {
 return NULL;
 }
 stasis_unsubscribe(bar->sub);
 bar->sub = NULL;
}

```

## Subscribing (with message router)

```
#include "asterisk/astobj2.h"
#include "asterisk/stasis.h"
#include "asterisk/stasis_message_router.h"
#include "foo.h"

struct ast_bar {
 struct stasis_message_router \*router;
};

static void bar_dtor(void \*obj)
{
 struct ast_bar \*bar = obj;

 /* Since the subscription holds a reference, unsubscribe
 * should happen before destruction.
 */
 ast_assert(bar->router == NULL);
}


static void bar_default(void \*data,
 struct stasis_subscription \*sub,
 struct stasis_topic \*topic,
 struct stasis_message \*message)
{
 struct ast_bar \*bar = data;
 if (stasis_subscription_final_message(sub, message)) {
 /* Final message; we can clean ourselves u */
 ao2_cleanup(bar);
 }
}

static void bar_foo(void \*data,
 struct stasis_subscription \*sub,
 struct stasis_topic \*topic,
 struct stasis_message \*message)
{
 struct ast_bar \*bar = data;
 struct ast_foo \*foo;

 ast_assert(ast_foo_type() == stasis_message_type(message));
 foo = stasis_message_data(message);
 /* A fooing we will go.. */

}

static void bar_whatever(void \*data,
 struct stasis_subscription \*sub,
 struct stasis_topic \*topic,
 struct stasis_message \*message)
{
 struct ast_bar \*bar = data;
 struct ast_whatever \*whatever;

 ast_assert(ast_whatever_type() == stasis_message_type(message));
 whatever = stasis_message_data (message);
 /* whateve */
}

struct ast_bar \*ast_bar_create(void)
{
 RAII_VAR(struct ast_bar \*, bar, NULL, ao2_cleanup);
 int r;

 bar = ao2_alloc(sizeof(\*bar), bar_dtor);
 if (!bar) {
 return NULL;
 }

 bar->router = stasis_message_router_create(ast_foo_topic());
 if (!bar->router) {
 return NULL;
 }

 r = stasis_message_router_set_default(bar->router, bar_default, bar);
 if (r != 0) {
 ast_bar_shutdown(bar);
 return NULL;
 }
 ao2_ref(bar, +1); /* The subscription hold a ref to ba */

 r |= stasis_message_router_add(
 bar->router, ast_foo_type(), bar_foo, bar);
 r |= stasis_message_router_add(
 bar->router, ast_whatever_type(), bar_whatever, bar);
 if (r != 0) {
 ast_bar_shutdown(bar);
 return NULL;
 }

 ao2_ref(bar, +1);
 return bar;
}

void ast_bar_shutdown(struct ast_bar \*bar)
{
 if (!bar) {
 return;
 }
 stasis_message_router_unsubscribe(bar->router);
 bar->router = NULL;
}

```



