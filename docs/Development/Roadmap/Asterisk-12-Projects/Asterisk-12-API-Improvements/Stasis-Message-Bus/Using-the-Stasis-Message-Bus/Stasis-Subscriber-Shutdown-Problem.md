---
title: Stasis Subscriber Shutdown Problem
pageid: 23756843
---

The introduction of the Stasis Message Bus in Asterisk 12 has resulted in some incredibly clean ways of bringing modules together in a decoupled way.

There has been one side effect of how Stasis subscriptions work that tends to take people by surprise.

tl;dr
=====

In general, there's a cyclic reference between a subscription and the object holding the subscription. This means that the object needs an explicit shutdown method, which unsubscribes all of its subscriptions. Once all messages from all subscriptions have been processed, the refcount for the object itself goes to zero and it can finally go away.

The naïve subscriber
====================

The first time we wrote subscription code, it looked like this:




---

  
Bad code we all wrote at first  


```

struct ast_foo {
 /* foo's stuff */
 /*! Very important subscriptio */
 struct stasis_subscription \*sub;
};
static void foo_dtor(void \*obj) {
 struct ast_foo \*foo = obj;
     stasis_unsubscribe(foo->sub); /* !!! WRONG !! */
     /* destroy foo's stuff */
    }

    static void foo_cb(void \*data, struct stasis_subscription \*sub,
     struct stasis_topic \*topic, struct stasis_message \*message)
    {
     struct foo \*foo = data;
     /* Message handlin */
    }

    struct ast_foo \*ast_foo_create(void) {
     RAII_VAR(struct ast_foo \*, foo, NULL, ao2_cleanup);
     foo = ao2_alloc(sizeof(\*foo), foo_dtor);
     if (!foo) { return NULL; }
     foo->sub = stasis_subscribe(some_topic(), foo_cb, foo);
     if (!foo->sub) { return NULL; }
     ao2_ref(foo, +1);
     return foo;
    }


    ```


    So the code looks fine, so what's the problem?

    The problem is that subscriptions are dispatched asynchronously, and you may have messages arriving on the subscription after the call to `stasis_unsubscribe()` returns. In fact, you will probably will, since the topic sends out unsubscribe notifications. If you're lucky, they'll come in before any more of the object had been destroyed. Typically, though, `foo_cb()` is calling back on a bad pointer, which is, well, bad.

    The slightly less naïve subscriber
    ==================================

    Okay, you notice the problem, and it's an easy fix. The subscription should have a reference to the data object. We even have a `stasis_subscription_final_message()` function for cleaning up after the final message has been received. Easy, right?




    ---

      
    Bad code we all wrote second  


    ```

    struct ast_foo {
     /* foo's stuff */
     /*! Very important subscriptio */
     struct stasis_subscription \*sub;
    };
    static void foo_dtor(void \*obj) {
     struct ast_foo \*foo = obj;
     stasis_unsubscribe(foo->sub); /* !!! STILL WRONG !! */
     /* destroy foo's stuff */
    }
    static void foo_cb(void \*data, struct stasis_subscription \*sub,
     struct stasis_topic \*topic, struct stasis_message \*message)
    {
     struct foo \*foo = data;
     /* Now we have to clean up the reference on the final messag */
     if (stasis_subscription_final_message(sub, message)) {
     ao2_cleanup(foo);
     return;
     }
     /* Message handlin */
    }
    struct ast_foo \*ast_foo_create(void) {
     RAII_VAR(struct ast_foo \*, foo, NULL, ao2_cleanup);
     foo = ao2_alloc(sizeof(\*foo), foo_dtor);
     if (!foo) { return NULL; }
     foo->sub = stasis_subscribe(some_topic(), foo_cb, foo);
     if (!foo->sub) { return NULL; }
     ao2_ref(foo, +1); /* Subscription now has a referenc */
     ao2_ref(foo, +1);
     return foo;
    }

    ```


    This has a decided advantage over the earlier code: it no longer segfaults. But it's still not correct. What's wrong with it?

    It has a memory leak. The subscription properly increases the ref count on the data object. But the data object has a reference to the subscription. This is a cyclic reference, and until C introduces a garbage collector, isn't going away. The subscription isn't going to release its reference to `foo` until the last message has been received. But it's not going to be unsubscribed until `foo` has been destroyed, which won't happen until all references to it go away.

    The Shrewd Subscriber
    =====================

    Now we've seen it all. We've learned our lessons. Now we can properly code up how to handle subscriptions from an object.




    ---

      
    Good code we finally wrote there at the end  


    ```

    struct ast_foo {
     /* foo's stuff */
     /*! Very important subscriptio */
     struct stasis_subscription \*sub;
    };
    static void foo_dtor(void \*obj) {
     struct ast_foo \*foo = obj;
     /* destroy foo's stuff */
     printf("%p\n", foo);
    }
    static void foo_cb(void \*data, struct stasis_subscription \*sub,
     struct stasis_topic \*topic, struct stasis_message \*message)
    {
     struct ast_foo \*foo = data;
     if (stasis_subscription_final_message(sub, message)) {
     /* Last message; all don */
     ao2_cleanup(foo);
     return;
     }
     /* Message handlin */
    }
    struct ast_foo \*ast_foo_create(void) {
     RAII_VAR(struct ast_foo \*, foo, NULL, ao2_cleanup);
     foo = ao2_alloc(sizeof(\*foo), foo_dtor);
     if (!foo) { return NULL; }
     foo->sub = stasis_subscribe(some_topic(), foo_cb, foo);
     if (!foo->sub) { return NULL; }
     /* This is the reference the subscription ha */
     ao2_ref(foo, +1);
     /* We're not bumping the refcount, since the caller doesn't
     \* get a direct reference. The call ast_foo_shutdown() instead
    */
     return foo;
    }
    void ast_foo_shutdown(struct ast_foo \*foo) {
     if (!foo) { return; }
     stasis_unsubscribe(foo->sub);
    }

    ```


    Finally, we've got code that works. Not what we wanted ideally, but the best we can do with what we've got.

    The object returned by `ast_foo_create()` must be explicitly shut down with the `ast_foo_shutdown()` function. It is still AO2 managed, so you can `ao2_ref()` it all you want. But the of `foo` object has an explicit lifetime, and must be shutdown before it can be disposed of.

    Epilogue: Too clever by half
    ============================

    If you're like me, you aren't terribly happy with explicit shutdown functions. These things really ought to be able to clean up after themselves when their refcount goes to zero.

    Well, there *is* a way to do that. But it involves a change to the way unsubscribes work that has a good chance of breaking all sorts of other things. It's not worth it.

    What would happen if `stasis_unsubscribe()` blocked until the last message was received? Answer: one good thing, and lots of bad things.

    On the good side, a blocking unsubscribe would allow for the [the code we wrote at first](#The-naïve-subscriber) to work as expected. The `foo` object owns the subscription, disposes of it when it's done with it, and doesn't receive any messages after it's destructor. So long as you unsubscribe first thing in the destructor, it works fine. Except…

    There's a general assumption that destruction is a straightforward process of freeing up resources. Having it block waiting on messages to be processed breaks that expectation. Someone will need to dig around in the internals of `astobj2.c` to make sure this is safe, and fix it up if it isn't.

    Even if that were fixed, it's worse than simply making the cleanup process block; it makes it non-deterministic. When I `ao2_cleanup()` on an object, if I'm the last one holding the bag I'm the one who has to wait for the unsubscribe to complete. Next time, though, maybe someone else will be holding the bag. That's not a very happy level of uncertainty.

    And even if that were acceptable (which it's not), the worst possible case is that while blocking in the destructor, the subscription may process a message which will bump the refcount up by one. Then it does whatever it does, decrements the refcount, which then proceeds to re-destroy the object. Now you've got hard to reproduce bugs that only show up under certain loads.

    We welcome any ideas for a cleaner means to handle these cyclic references. Until someone figures that out, explicit shutdown functions are the way to go.

