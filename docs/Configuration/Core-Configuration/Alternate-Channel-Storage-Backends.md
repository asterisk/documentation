# Alternate Channel Storage Backends

## **Background**

Over the years, the single biggest source of deadlocks in Asterisk involve channels and the AO2 hash container all channels are kept in. While things have gotten better in recent years (mostly due to masquerades becoming less frequent), it's still an issue. Performance is also an issue, especially when the number of active channels grows past a few hundred.  To address these issues, Asterisk releases >= 22.5.0, 21.10.0 and 20.15.0 will allow you to select an alternate channel storage backend.

## **Choosing an Alternative**

We performed an [Alternate Backends Proof-of-Concept](#alternate-backends-proof-of-concept) that tested the legacy implementation along with 6 alternatives.  The clear winner was [C++ Maps on Name and Uniqueid](#1st-place-c-maps-on-name-and-uniqueid) and is the only alternative currently enabled.  A framework to add additional alternatives was created however so if another viable option becomes available in the future, it could be easily tested and plugged in.

Enabling the alternative requires following these steps:

1.  Install a C++11 compiler.  For most platforms, `g++` is what you want and may already be installed.
2.  Run the `./configure` script in the Asterisk source tree.  It's been updated to detect the C++ compiler and version.
3.  In menuselect, select the `channelstorage_cpp_map_name_id` option under the "Alternate Channel Storage Backends" category.
4.  Build and install Asterisk.

Once enabled, built and installed, you can select which backend to use, `ao2_legacy` or `cpp_map_name_id`, in the `asterisk.conf` by adding the `channel_storage_backend` parameter to the `[options]` section of asterisk.conf:

```ini title="asterisk.conf"
[options]
channel_storage_backend = ao2_legacy ; Select the channel storage backend
                ; to use for live operation.
                ;   ao2_legacy:  Original implementation (default)
                ; Depending on compile options, the following may also be
                ; available:
                ;   cpp_map_name_id: Use C++ Maps to index on both
                ;                    channel name and channel uniqueid.
```

/// warning
This configuration **must** be set before Asterisk starts, as the backend is
selected during core initialization.  A **full restart** of Asterisk is required
after making changes to `channel_storage_backend`. Reloading the configuration is
**not** sufficient.
///

You can verify which backend is in use by running the `core show settings` CLI command:

```
*CLI> core show settings
PBX Core settings
-----------------
  Version:                     22.5.0
 ...
  RTP dynamic payload types:   35-63,96-127
  Channel storage backend:     cpp_map_name_id
  Shell on remote consoles:    Enabled 
```

/// warning
Before using the alternate backend in production, you should thoroughly test using your typical configuration and workload.  If you deploy to multiple production Asterisk instances, we'd also suggest slow rolling the use of the alternate backend.
///

## **History**

### **Current Implementation**

#### **Queries**

The current channel access API allows the following queries:

- Find by full or partial channel name.
- Find by uniqueid.
- Find by context/extension.
- All searches are case-insensitive.

The channels container is a classic hash container whose key is the channel name. The container is protected by a mutex lock which means only 1 thread can access the table, for both read or write, at a time. Every channel also has a mutex lock that is supposed to prevent concurrent modifications. This means that queries other than by name casn't use the hash index and have to go through the following process:

- Lock the channels container.
- Test each channel in the container:
  - Lock the channel.
  - Do a case-insentive compare on the search criteria.
  - Unlock the channel.
  - Exit the loop if there's a match.
- Unlock the channels container.

A query by full channel name still locks the container but the search is done by the hash and doesn't require visiting every channel. A query by partial channel name however, can't use the hash and requires a full traversal.

#### **Updates**

Changing a channel's name and/or uniqueid are only done through the Masquerade process (which now only gets called by parking and some rare REFER scenarios) but only after the channel has been removed from the channels container.

Changing the context and extension on a channel however happens quite often as a channel progresses through the dialplan.  There are also two separate calls for setting context and extension so locking the channel is important.

### **Issues**

- There are dialplan applications and functions that allow searching for a channel by name or uniqueid. Unfortunately, they don't allow specifying which one you're specifying as the search criteria. This means that the `ast_channel_by_name()` function has to search the channels container by name and if it's not found, search again by  uniqueid. Since the name is the container index, that's a fast search but the search for uniqueid has to traverse the entire container.
- Locking and unlocking each channel while testing it can be a performance issue.
- Locking both the container and channels can lead to deadlocks if you already have one channel locked and are searching for another and you're not doing the locking in the correct order.
- Channel locking is done by *many* functions throughout Asterisk and while the API documentation *should* indicate whether the channel will be locked or not, it doesn't always.  Many of those functions call other channel function that also lock the channel.  For this reason, channels are protected by a recursive mutex so that a thread that locks the same channel multiple times won't deadlock.
- We do case-insensitive matching so we have to call strcasecmp() on every channel we touch.
- The current native AO2 hash container implementation is almost 20 years old and may not be optimized by today's standards.

The bottom line is that all the scanning can be a performance issue and
all the locking can cause deadlocks and can also be a performance issue.

### **Alternate Backends Proof-of-Concept**

The channels container isn't exposed outside of main/channels.c so we looked at alternate storage implementations that could help aleviate some of the issues.

#### **Multiple AO2 Hash Containers**

Since an AO2 hash container can have only a single key we can only do quick lookups by channel name. Given that the same function also searches for uniqueid and that requires a scan of the container, we could benefit by simply creating a second container whose key is uniqueid. A hash container uses 48 bytes per entry so even with thousands of channels, it's not that mcuh extra storage in the grand scheme of things.

#### **AO2 Optimized Containers**

Optimize the usage of the AO2 hash container in channels.c:

- Change the locking strategy for the container to rwlock instead of mutex. This will allow multiple readers to search the container at the same time while still locking the container completely for write access.
- Given that name and unique id changes only happen when the channel isn't in the container, we may be able to remove the locks on channel when searching by name or uniqueid. We *may* still need them when searching by context/exten because those can change at any time. Although you search by both context and extension in the same call (`ast_channel_get_by_exten()`), Setting them is done with two separate calls so there's an opportunity for testing a channel to happen between setting context and extension. 
- Use `ao2_find()` instead of `ao2_callback()` to search for name.

#### **C++ std::map**

The Asterisk build system has had support for compiling C++ source files for some time which means we could take advantage of C++ features that aren't in C.

C++ maps can be ordered or unordered. The unordered map uses a hashtable just like an ao2_hash_container. The ordered version uses a red-black tree as the backend storage method (like ao2_container_rbtree) and are therefore naturally sorted. The advantage of the ordered map is that you can create iterators with lower and upper bound constraints to return a range of entries. This is particularly useful when searching by partial channel name.

In a hash map, iterating over channels with a partial name requires traversing the entire container and testing each channel because the actual channels aren't in any particular order and could be spread out over the entire container. You don't know if you got them all until you reach the end of the container.

With an ordered RB tree container, if you want to find all channels that start with "PJSIP/1000", you'd set *lower_bound("PJSIP/1000")* and *upper_bound("PJSIP/1000\\xFF")*. Since the RB-tree is naturally sorted, finding the first matching channel is just as fast as a direct lookup and each successive channel that matches is actually the next channel in the container. When a channel name is found that is greater than the upper bound, the search stops there without having to continue to the end of the container.

Another advantage of C++ maps is that the key is specified separately from the object being stored. With channel name for instance, we can convert the name to lower case once upon insertion without touching the actual "name" field in the channel structure. When a search is performed, we then only have to convert the search criteria once to lower case (a trivial operation) before calling "find()" and not have to do case-insensitive string compares on every channel we traverse.

#### **Boost C++ Library**

Boost is a very popular library of C++ utilities most of which are are implemented in header files so there are no shared libraries to link to and the compiler can do a better job of optimization because it's compiling everything at the same time. Their container implementations are supposed to be highly optimized and they even have a multi-index container that we might use so we could have an index each for name, uniqueid and context/exten. Although the semantics for their maps are mostly the same as the standard C++ counterparts, they do NOT have ordered versions of maps, only unordered so there's no built-in range search functionality.

#### **Sqlite3 In-memory Database**

We already have experience with sqlite3 since we use it for astdb. Creating a "channels" table with indexes on name, uniqueid, context and extension with a pointer to the channel structure is quite easy using standard SQL. We also get the same benefit of specifying lower and upper bounds for iterators that we get with the C++ ordered map. Some work is required to make sure prepared statements are cached per-thread but AST_THREADSTORAGE takes care of most of that for us.

### **POC Conclusions**

#### **7th Place: Boost Multi-Index**

While the Boost Multi-Index implementation performed great for all retrievals and traversals, the complexity of maintaining multiple indexes made it's performance for insert and delete operations so bad it could never be considered for deployment.

#### **6th Place: AO2 Legacy**

Every other backend, with the exception of Boost Multi-Index, performed *better* that the AO2 Legacy backend.  Not surprising really.

#### **5th Place: AO2 Optimized**

This backend was better than Boost Multi-Index and AO2 Legacy but not as good as the others and it still relies on the very old AO2 hashtable implementation.

#### **4th Place: C++ Map on Channel Name**

This backend scored well and was significantly better than the lower placed backends in most categories.

#### **3rd Place: Boost Map Name**

This backend was just slightly better than the C++ equivalent but working with Boost's header files offsets that.

#### **2nd Place: Sqlite3**

This backend produced the most surprising results.  While it performed "OK" at the lower channel counts, it's speed and resource utilization at the higher channel counts were an order of magnitude better than the 3 last place finishers.  At just 1,000 channels for instance, the AO2 Legacy backend took 155 milliseconds and 828 million instructions to complete the unit test while this backend took just 39 milliseconds and 188 million instructions.  At 10,000 channels, the AO2 Legacy backend took a full 10 seconds and 71 billion instructions to complete the unit test while this backend took just 300 milliseconds and 2.2 billion instructions. 

#### **1st Place: C++ Maps on Name and Uniqueid**

This alternative uses two [C++ std::maps](#c-stdmap), one to index by channel name and another to index by channel uniqueid.  This alternative simply performed better than every other option at every channel count.
