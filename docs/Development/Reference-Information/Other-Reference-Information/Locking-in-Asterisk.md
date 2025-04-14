---
title: Locking in Asterisk
pageid: 5243132
---

### Locking Fundamentals

Asterisk is a heavily multithreaded application. It makes extensive use of locking to ensure safe access to shared resources between different threads.

When more that one lock is involved in a given code path, there is the potential for deadlocks. A deadlock occurs when a thread is stuck waiting for a resource that it will never acquire. Here is a classic example of a deadlock:

```

 Thread 1 Thread 2
 ------------ ------------
 Holds Lock A Holds Lock B
 Waiting for Lock B Waiting for Lock A

```

In this case, there is a deadlock between threads 1 and 2. This deadlock would have been avoided if both threads had agreed that one must acquire Lock A before Lock B.

In general, the fundamental rule for dealing with multiple locks is: **an order *must* be established to acquire locks, and then all threads must respect that order when acquiring locks**.

##### Establishing a locking order

Because any ordering for acquiring locks is ok, one could establish the rule arbitrarily, e.g. ordering by address, or by some other criterion.  

1. is easy to check at runtime;
2. reflects the order in which the code executes.

As an example, if a data structure B is only accessible through a data structure A, and both require locking, then the natural order is locking first A and then B. As another example, if we have some unrelated data structures to be locked in pairs, then a possible order can be based on the address of the data structures themselves.

### Minding the boundary between channel drivers and the Asterisk core

The #1 cause of deadlocks in Asterisk is by not properly following the locking rules that exist at the boundary between Channel Drivers and  

The locking order in this situation is the following:

1. ast_channel
2. PVT

Channel Drivers implement the ast_channel_tech interface to provide a channel implementation for Asterisk. Most of the channel_tech  

interface callbacks are called with the associated ast_channel locked. When accessing technology specific data, the PVT can be locked directly because the locking order is respected.

### Preventing lock ordering reversals.

There are some code paths which make it extremely difficult to respect the locking order.  

Consider for example the following situation:

1. A message comes in over the "network"
2. The Channel Driver (CD) monitor thread receives the message
3. The CD associates the message with a PVT and locks the PVT
4. While processing the message, the CD must do something that requires locking the ast_channel associated to the PVT

This is the point that must be handled carefully.

The following psuedo-code

```
c
unlock(pvt);
lock(ast_channel);
lock(pvt);

```

is *not* correct for two reasons:

1. first and foremost, unlocking the PVT means that other threads can acquire the lock and believe it is safe to modify the associated data. When reacquiring the lock, the original thread might find unexpected changes in the protected data structures. This essentially means that the original thread must behave as if the lock on the pvt was not held, in which case it could have released it itself altogether;
2. Asterisk uses the so called "recursive" locks, which allow a thread to issue a lock() call multiple times on the same lock. Recursive locks count the number of calls, and they require an equivalent number of unlock() to be actually released.

For this reason, just calling unlock() once does not guarantee that the lock is actually released – it all depends on how many times lock() was called before.

An alternative, but still incorrect, construct is widely used in the asterisk code to try and improve the situation:

```

while (trylock(ast_channel) == FAILURE) {
 unlock(pvt);
 usleep(1); /* yield to other thread */
 lock(pvt);
}

```

Here the trylock() is non blocking, so we do not deadlock if the ast_channel is already locked by someone else: in this case, we try to unlock the PVT (which happens only if the PVT lock counter is 1), yield the CPU to give other threads a chance to run, and then acquire the lock again.

This code is not correct for two reasons:

1. same as in the previous example, it releases the lock when the thread probably did not expect it;
2. if the PVT lock counter is greater than 1 we will not really release the lock on the PVT. We might be lucky and have the other contender actually release the lock itself, and so we will "win" the race, but if both contenders have their lock counts > 1 then they will loop forever (basically replacing deadlock with livelock).

Another variant of this code is the following:

```
c
if (trylock(ast_channel) == FAILURE) {
 unlock(pvt);
 lock(ast_channel);
 lock(pvt);
}

```

which has the same issues as the while(trylock...) code, but just deadlocks instead of looping forever in case of lock counts > 1.

The deadlock/livelock could be in principle spared if one had an unlock_all() function that calls unlock as many times as needed to actually release the lock, and reports the count. Then we could do:

```
c
if (trylock(ast_channel) == FAILURE) {
 n = unlock_all(pvt);
 lock(ast_channel);
 while (n-- > 0) {
 lock(pvt);
 }
}

```

The issue with unexpected unlocks remains, though.

### Locking multiple channels.

The next situation to consider is what to do when you need a lock on multiple ast_channels (or multiple unrelated data structures).

If we are sure that we do not hold any of these locks, then the following construct is sufficient:

```
c
lock(MIN(chan1, chan2));
lock(MAX(chan1, chan2));

```

That type of code would follow an established locking order of always locking the channel that has a lower address first. Also keep in mind  

However, if we enter the above section of code with some lock held (which would be incorrect using non-recursive locks, but is completely legal using recursive mutexes) then the locking order is not guaranteed anymore because it depends on which locks we already hold. So we have to go through the same tricks used for the channel+PVT case.

### Recommendations

As you can see from the above discussion, getting locking right is all but easy. So please follow these recommendations when using locks:

##### Use locks only when really necessary

Please try to use locks only when strictly necessary, and only for the minimum amount of time required to run critical sections of code. A common use of locks in the current code is to protect a data structure from being released while you use it. With the use of reference-counted objects (astobj2) this should not be necessary anymore.

There is only one time in the entire code base where deadlock avoidance is absolutely necessary and that is when multiple channels are being locked at the same time. This is because there is no locking order established for locking multiple channels.

With everything else, there is a locking order established. In this case the channels container must always be locked before an individual channel. Deadlock avoidance is not necessary here.

So, never use deadlock avoidance unless you have to grab two channel locks at the same time, otherwise it is not necessary. I know the code has misuses of deadlock avoidance all over the place, ignore them. They will go away in time.

!!! note 
    As a side note, if you ever find yourself in the position where you are designing a program and think using deadlock avoidance is a quick solution for a concurrency problem you run into, it is not. Running into a deadlock almost certainly means your design is flawed. I'd go as far as to say if you ever find yourself designing a system with multiple locks held at the same time, your design is flawed. Seriously, anyone who reads this remember this, and say it to yourself every time you create a new mutex.  

[//]: # (end-note)

##### Do not sleep while holding a lock

If possible, do not run any blocking code while holding a lock, because you will also block other threads trying to access the same lock. In many cases, you can hold a reference to the object to avoid that it is deleted while you sleep, perhaps set a flag in the object itself to report other threads that you have some pending work to complete, then release and acquire the lock around the blocking path, checking the status of the object after you acquire the lock to make sure that you can still perform the operation you wanted to.

##### Try not to exploit the 'recursive' feature of locks.

Recursive locks are very convenient when coding, as you don't have to worry, when entering a section of code, whether or not you already hold the lock – you can just protect the section with a lock/unlock pair and let the lock counter track things for you.

But as you have seen, exploiting the features of recursive locks make it a lot harder to implement proper deadlock avoidance strategies. So please try to analyse your code and determine statically whether you already hold a lock when entering a section of code. If you need to call some function foo() with and without a lock held, you could define two function as below:

```
c
foo_locked(/* .. */) {
 /* ... do something, assume lock hel */
}

foo(/* .. */) {
 lock(xyz);
 ret = foo_locked(/* .. */)
 unlock(xyz);
 return ret;
}

```

and call them according to the needs.

##### Document locking rules.

Please document the locking order rules are documented for every lock introduced into Asterisk. This is done almost nowhere in the existing code. However, it will be expected to be there for newly introduced code. Over time, this information should be added for all of the existing lock usage.
