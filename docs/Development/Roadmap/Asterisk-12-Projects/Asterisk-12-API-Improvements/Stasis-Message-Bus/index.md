---
title: Overview
pageid: 22086002
---

INLINE{numberedheadings}

While the basic API's for the Stasis Message Bus are documented using Doxygen, there's still a lot to be said about how to use those API's within Asterisk.

{toc:style=none}

h1. Message Bus

The overall stasis-core API can be best described as a publish/subscribe message bus.

Data that needs to be published on the message bus is encapsulated in a {{stasis\_message}}, which associates the message data (which is simply an AO2 managed {{void \*}}) along with a {{stasis\_message\_type}}. (The message also has the {{timeval}} when it was created, which is generally useful, since messages are received asynchronously).

Messages are published to a {{stasis\_topic}}. To receive the messages published to a topic, use {{stasis\_subscribe()}} to create a subscription.

When topics are subscribed to/unsubscribed to, {{stasis\_subscription\_change}} are sent to all of the topic's subscribers. On unsubscribe, the {{stasis\_subscription\_change}} will be the last message received by the unsubscriber, which can be used to kick off any cleanup that might be necessary. The convenience function {{stasis\_subscription\_final\_message()}} can be used to check if a message is the final unsubscribe message.

To forward all of the messages from one topic to another, use {{stasis\_forward\_all()}}. This is useful for creating aggregation topics, like {{[ast\_channel\_topic\_all()|#ast\_channel\_topic\_all()]}}, which collect all of the messages published to a set of other topics.

h2. Routing and Caching

In addition to these fundamental concepts, there are a few extra objects in the Stasis Message Bus arsenal.

For subscriptions that deal with many different types of messages, the {{stasis\_message\_router}} can be used to route messages based on type. This gets rid of a lot of ugly looking {{if/else}} chains and replaces them with callback dispatch.

Another common use case within Asterisk is to have a subscription that monitors state changes for snapshots that are published to a topic. To aid in this, we have {{stasis\_caching\_topic}}. This is a \_topic filter\_, which presents its own topic with filtered and modified messages from an original topic. In the case of the caching topic, it watches for snapshot messages, compares them with their prior values. For these messages, it publishes a {{stasis\_cache\_update}} message with both the old and new values of the snapshot.

h2. Design Philosophy

By convention (since there's no effective way to enforce this in C), messages are immutable. Not only the {{stasis\_message}} type itself, but also the data it contains. This allows messages to be shared freely throughout the system without locking. If you find yourself in the situation where you want to modify the contents of a {{stasis\_message}}, what you actually want to do is copy the message, and change the copy. While on the surface this seems wasteful and inefficient, the gains in reducing lock contention win the day.

Messages are opaque to the message bus, so you don't have to modify {{stasis.c}} or {{stasis.h}} to add a new topic or message type.

The {{stasis\_topic}} object is thread safe. Subscribes, unsubscribes and publishes may happen from any thread. There are some ordering guarantees about message delivery, but not many.

\* A {{stasis\_publish()}} that begins after a {{stasis\_publish()}} to the same topic completes will be delivered in order.
\*\* In general, this means that publications from different threads to the same topic are unordered, but publications from the same thread are.
\* Publications to different topics are not ordered.
\* The final message delivered to a subscription will be the {{stasis\_subscription\_final\_message()}}.

The callback invocations for a {{stasis\_topic}} are serialized, although invocations can happen out of any thread from the Stasis thread pool. This is a comfortable middle ground between allocating a thread for every subscription (which would result in too many threads in the system) and invoking callbacks in parallel (which can cause insanity). If your particular handling can benefit from being parallelized, then you can dispatch it to a thread pool in your callback.

h1. Topics and messages

While Stasis allows for the proliferation of many, many message types, we feel that creating too many message types would complicate the overall API. We have a small number of first class objects, (channel snapshots, bridge snapshots, etc.). If a message needs a first class object plus a small piece of additional data, {{blob}} objects are provided which attach a [JSON object|http://doxygen.asterisk.org/trunk/d4/d05/json\_8h.html] to the first class object.

The details of topics and messages are documented [on doxygen.asterisk.org|http://doxygen.asterisk.org/trunk/df/deb/group\_\_StasisTopicsAndMessages.html]. Some of the more important items to be aware of:

h2. First Class Message Object

h3. {{ast\_channel\_snapshot}}

A snapshot of the primary state of a channel, created by {{ast\_channel\_snapshot\_create()}}. 

h2. Second Class Message Objects

h3. {{ast\_channel\_blob}}

Often times, you find that you want to attach a piece of data to a snapshot for your message. For these cases, there's {{ast\_channel\_blob}}, which associated a channel snapshot with a JSON object (which is required to have a {{type}} field identifying it).

These are used to publish messages such as hangup requests, channel variable set events, etc.

h2. Channel Topics

h2. {{ast\_channel\_topic(chan)}}

This is the topic to which channel associated messages are published, including [channel snapshots|#ast\_channel\_snaphshot].

h2. {{ast\_channel\_topic\_all()}}

This is an aggregation topic, to which all messages published to individual channel topics are forwarded.

h2. {{ast\_channel\_topic\_all\_cached()}}

This is a caching topic wrapping {{ast\_channel\_topic\_all()}}, which caches {{ast\_channel\_snaphshot}} messages.

h1. Sample Code

h2. Publishing messages

{code:c|title=foo.h}
#include "asterisk/stasis.h"

/\*! \brief Some structure containing the content of your message. \*/
struct ast\_foo {
 /\* stuffz \*/
};

/\*! \brief Message type for \ref ast\_foo \*/
struct stasis\_message\_type \*ast\_foo\_type(void);

/\*!
 \* \brief Topic for the foo module.
 \*/
struct stasis\_topic \*ast\_foo\_topic(void);
{code}

{code:c|title=foo.c}
#include "asterisk.h"

ASTERISK\_FILE\_VERSION(\_\_FILE\_\_, "$Revision$")

#include "asterisk/astobj2.h"
#include "asterisk/module.h"
#include "asterisk/stasis.h"
#include "foo.h"

static struct stasis\_message\_type \*foo\_type;

struct stasis\_topic \*foo\_topic;

struct stasis\_message\_type \*ast\_foo\_type(void)
{
 return foo\_type;
}

struct stasis\_topic \*ast\_foo\_topic(void)
{
 return foo\_topic;
}

/\*!
 \* \brief Convenience function to publish an \ref ast\_foo message to the
 \* \ref foo\_topic.
 \*/
static void publish\_foo(struct ast\_foo \*foo)
{
 RAII\_VAR(struct stasis\_message \*, msg, NULL, ao2\_cleanup);

 msg = stasis\_message\_create(foo\_type, foo);

 if (!msg) {
 return;
 }

 stasis\_publish(foo\_topic, msg);
}

/\*
 \* Imagine lots of cool foo-related code here, which uses the above
 \* publish\_foo message. Other foo-related messages may also be published
 \* to the foo\_topic.
 \*/

static int unload\_module(void)
{
 ao2\_cleanup(foo\_type);
 foo\_type = NULL;
 ao2\_cleanup(foo\_topic);
 foo\_topic = NULL;
 return 0;
}

static int load\_module(void)
{
 foo\_type = stasis\_message\_type\_create("ast\_foo");
 if (!foo\_type) {
 return AST\_MODULE\_LOAD\_FAILURE;
 }
 foo\_topic = stasis\_topic\_create("foo");
 if (!foo\_topic) {
 return AST\_MODULE\_LOAD\_FAILURE;
 }
 return AST\_MODULE\_LOAD\_SUCCESS;
}

AST\_MODULE\_INFO(ASTERISK\_GPL\_KEY, 0, "The wonders of foo",
 .load = load\_module,
 .unload = unload\_module
 );
{code}

h2. Subscribing (no message router)

{code:c|title=bar.c}
#include "asterisk/astobj2.h"
#include "asterisk/stasis.h"
#include "foo.h"

struct ast\_bar {
 struct stasis\_subscription \*sub;
};

static void bar\_dtor(void \*obj)
{
 struct ast\_bar \*bar = obj;

 /\* Since the subscription holds a reference, unsubscribe
 \* should happen before destruction.
 \*/
 ast\_assert(bar->sub == NULL);
}


static void bar\_callback(void \*data,
 struct stasis\_subscription \*sub,
 struct stasis\_topic \*topic,
 struct stasis\_message \*message)
{
 struct ast\_bar \*bar = data;

 if (stasis\_subscription\_final\_message(sub, message)) {
 /\* Final message; we can clean ourselves up \*/
 ao2\_cleanup(bar);
 return;
 }

 if (ast\_foo\_type() == stasis\_message\_type(message)) {
 struct ast\_foo \*foo = stasis\_message\_data(message);
 /\* A fooing we will go... \*/
 } else if (ast\_whatever\_type() == stasis\_message\_type(message)) {
 struct ast\_whatever \*whatever = stasis\_message\_data (message);
 /\* whatever \*/
 }
}

struct ast\_bar \*ast\_bar\_create(void)
{
 RAII\_VAR(struct ast\_bar \*, bar, NULL, ao2\_cleanup);

 bar = ao2\_alloc(sizeof(\*bar), bar\_dtor);
 if (!bar) {
 return NULL;
 }

 bar->sub = stasis\_subscribe(ast\_foo\_topic(), bar\_callback, bar);
 if (!bar->sub) {
 return NULL;
 }

 ao2\_ref(bar, +1); /\* The subscription hold a ref to bar \*/

 ao2\_ref(bar, +1); /\* And we're returning a ref to bar \*/
 return bar;
}

void ast\_bar\_shutdown(struct ast\_bar \*bar)
{
 if (!bar) {
 return NULL;
 }
 stasis\_unsubscribe(bar->sub);
 bar->sub = NULL;
}
{code}

h2. Subscribing (with message router)

{code:c|title=bar2.c}
#include "asterisk/astobj2.h"
#include "asterisk/stasis.h"
#include "asterisk/stasis\_message\_router.h"
#include "foo.h"

struct ast\_bar {
 struct stasis\_message\_router \*router;
};

static void bar\_dtor(void \*obj)
{
 struct ast\_bar \*bar = obj;

 /\* Since the subscription holds a reference, unsubscribe
 \* should happen before destruction.
 \*/
 ast\_assert(bar->router == NULL);
}


static void bar\_default(void \*data,
 struct stasis\_subscription \*sub,
 struct stasis\_topic \*topic,
 struct stasis\_message \*message)
{
 struct ast\_bar \*bar = data;
 if (stasis\_subscription\_final\_message(sub, message)) {
 /\* Final message; we can clean ourselves up \*/
 ao2\_cleanup(bar);
 }
}

static void bar\_foo(void \*data,
 struct stasis\_subscription \*sub,
 struct stasis\_topic \*topic,
 struct stasis\_message \*message)
{
 struct ast\_bar \*bar = data;
 struct ast\_foo \*foo;

 ast\_assert(ast\_foo\_type() == stasis\_message\_type(message));
 foo = stasis\_message\_data(message);
 /\* A fooing we will go... \*/

}

static void bar\_whatever(void \*data,
 struct stasis\_subscription \*sub,
 struct stasis\_topic \*topic,
 struct stasis\_message \*message)
{
 struct ast\_bar \*bar = data;
 struct ast\_whatever \*whatever;

 ast\_assert(ast\_whatever\_type() == stasis\_message\_type(message));
 whatever = stasis\_message\_data (message);
 /\* whatever \*/
}

struct ast\_bar \*ast\_bar\_create(void)
{
 RAII\_VAR(struct ast\_bar \*, bar, NULL, ao2\_cleanup);
 int r;

 bar = ao2\_alloc(sizeof(\*bar), bar\_dtor);
 if (!bar) {
 return NULL;
 }

 bar->router = stasis\_message\_router\_create(ast\_foo\_topic());
 if (!bar->router) {
 return NULL;
 }

 r = stasis\_message\_router\_set\_default(bar->router, bar\_default, bar);
 if (r != 0) {
 ast\_bar\_shutdown(bar);
 return NULL;
 }
 ao2\_ref(bar, +1); /\* The subscription hold a ref to bar \*/

 r |= stasis\_message\_router\_add(
 bar->router, ast\_foo\_type(), bar\_foo, bar);
 r |= stasis\_message\_router\_add(
 bar->router, ast\_whatever\_type(), bar\_whatever, bar);
 if (r != 0) {
 ast\_bar\_shutdown(bar);
 return NULL;
 }

 ao2\_ref(bar, +1);
 return bar;
}

void ast\_bar\_shutdown(struct ast\_bar \*bar)
{
 if (!bar) {
 return;
 }
 stasis\_message\_router\_unsubscribe(bar->router);
 bar->router = NULL;
}
{code}

{numberedheadings}

