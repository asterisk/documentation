---
title: Code Review Checklist
pageid: 27820123
---

Overview
========

The following are a list of things to look for when performing a code review.

* For reviewers: you can use this check list to help you when performing a review.
* For submitters: you can use this check list before submitting a patch for review.

Note that this checklist is in no way comprehensive. It merely contains *some* of the things reviewers can look for.

Checklist
=========

[Coding Guidelines](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review/Coding-Guidelines)
---------------------------------------

The first, and most obvious thing to look for. Many of the items in the coding guidelines concern themselves with the syntax of a code submission, but some also concern themselves with semantics. Read through the guidelines and verify that your code follows them.

Egregious and flagrant disregard for the coding guidelines will result in your submission being rejected outright.

Design
------

### Structure and Layout

* Can the code changes be placed into a separate module?
	+ If not, can the code be placed into a separate file?
* Are functions short, and do they have only a single purpose?
* Can any code be refactored into other functions to reduce complexity?
* Can any code be refactored to reduce duplication?
* Can the code be refactored to lend itself to unit testing?
* Can any data structures be made opaque?

### Naming

* Do function names follow the [Coding Guidelines](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review/Coding-Guidelines)?


	+ Public functions prefixed with a namespace, i.e., `ast_`, `stasis_`, `pbx_`, etc.
	+ Do they follow - when possible - the scheme `namespace_object_verb_noun`?
* Are variable names descriptive?
* Are global variables used?
	+ Can they be removed and replaced with an [ao2\_global\_obj](http://doxygen.asterisk.org/trunk/d2/dd8/structao2__global__obj.html)?

### Interfaces

#### Dialplan Applications

* Does the functionality have read/write semantics? If so, does a dialplan function make more sense?
* Are all options parsed using the application parsing routines, validated, and documented?
* Is there a routine result that should be returned via a channel variable?

#### Dialplan Functions

* Does the function have system altering capabilities? Should it be registered as 'dangerous'?
* Does the function have no side effects when being read?

#### CLI

* Does the CLI command have tab completion support?
* Does the functionality make more sense as an AMI action?
* Is the text returned formatted to fit on a variety of screen widths?

#### AMI

* Are all actions and events documented?
* Does the action have a long expected execution time? Should the action dispatch itself asynchronously?
* Do the events make use of object snapshots appropriately? Can the Stasis cache be used to retrieve a related object?
* Do events need to be synchronized through Stasis?
* Is there an existing event that already conveys similar information?

#### ARI

* Is the HTTP verb choice appropriate?
* Are names chosen appropriately for all resources and query parameters?

Documentation
-------------

#### Code

* Do comments in the code explain why something is being done, as opposed to how it is being done?
* If a comment is explaining what or how it is being done, can the code be refactored to be more clear?
* Is a comment explaining the purpose of something indicative of a design flaw?

#### Doxygen

* Are all public functions and data structures documented?
* Are internal functions marked as \internal, and do they have appropriate summaries?
* Should the public functions/data structures be grouped together into logical groupings?

#### User Documentation

* If the change may affect an existing system, is the UPGRADE file updated?
* If the change is a new feature, is the CHANGES file updated?
* Are all new configuration parameters documented in XML documentation and in the sample configuration file?
	+ Do any of the realtime database schemas need to be updated?
* Are all dialplan functions/applications/AMI actions & events/AGI actions/ARI resources documented?
* Does any wiki documentation need to be updated/written?

Framework and API Usage
-----------------------

Asterisk contains many frameworks. When possible, you should always strive to use the tools available and not re-invent your own. The following are some of the common frameworks in Asterisk, their purpose, and what they should be used for. Code should be reviewed for proper use of the appropriate frameworks.




---

**Tip:**  This is not an exhaustive list, nor is it meant to be. These are merely some of the more commonly used APIs and frameworks in Asterisk. Reproducing their functionality is highly likely to be noticed and discouraged.

  



---




| Framework | Principle Location | Usage |
| --- | --- | --- |
| AstObj2 | [astobj2.h](http://doxygen.asterisk.org/trunk/d5/da5/astobj2_8h.html) | Provides reference counted objects, including reference counted containers (hash table, red/black tree, list, single object). Probably the most heavily used API in Asterisk. Any object whose lifetime is affected by module reloads, who is shared between threads, or is generally complex should use this API. |
| Audiohooks | [audiohook.h](http://doxygen.asterisk.org/trunk/d0/d79/audiohook_8h.html) | A special type of frame hook used to intercept and manipulate audio frames. |
| Bridging | [bridge.h](http://doxygen.asterisk.org/trunk/d4/d56/bridge_8h.html) | A framework for bridging channels together. |
| Configuration Framework | [config\_options.h](http://doxygen.asterisk.org/trunk/db/dfe/config__options_8h.html) | A framework that manages and wraps a variety of static configuration APIs, including handling `.conf` files and static realtime. The framework provides thread safety, type safety, CLI/wiki documentation integration, and enforces schema consistency across Asterisk. For an example of using the framework, see [Using the Configuration Framework](/Development/Reference-Information/Asterisk-Framework-and-API-Examples/Using-the-Configuration-Framework). If you need support for dynamic realtime, see the Sorcery framework. |
| Datastores | [datastore.h](http://doxygen.asterisk.org/trunk/d9/db6/datastore_8h.html) | API for storing generic information on a channel. |
| Dialling | [dial.h](http://doxygen.asterisk.org/trunk/df/dcf/dial_8h.html) | A framework for performing outbound dialling operations. |
| Framehooks | [framehook.h](http://doxygen.asterisk.org/trunk/db/d3c/framehook_8h.html) | An API for intercepting and manipulating frames on a channel. |
| Linked Lists | [dlinkedlists.h](http://doxygen.asterisk.org/trunk/d0/d43/dlinkedlists_8h.html) [linkedlists.h](http://doxygen.asterisk.org/trunk/df/d90/linkedlists_8h.html) | Single and doubly linked lists. These are of particular use when used as members of structs, and when the items contained in the lists have well defined lifetimes. |
| Sorcery | [sorcery.h](http://doxygen.asterisk.org/trunk/d8/d25/sorcery_8h.html) | A framework that is both built on and extends the Configuration Framework, Sorcery is a data abstraction layer that maps general CRUD operations on objects to a persistent storage. Sorcery wizards provide the actual interface from the general operations to some storage mechanism. This framework provides a consistent mechanism to manage objects in memory, static configuration schemes, dynamic realtime, and more. If your configuration has complex storage requirements, this framework is probably appropriate. |
| Scheduler | [sched.h](http://doxygen.asterisk.org/trunk/d7/d00/sched_8h.html) | An API for scheduling callbacks to be called at a later time. |
| Stasis | [stasis.h](http://doxygen.asterisk.org/trunk/dd/d79/stasis_8h.html) | An internal publish/subscribe message bus that modules in Asterisk can use to share and consume state information. This includes information about channels, bridges, endpoints, as well as application specific messages. See [Stasis Topics and Messages](http://doxygen.asterisk.org/trunk/df/deb/group__StasisTopicsAndMessages.html) for more information. |
| Threading | [utils.h](http://doxygen.asterisk.org/trunk/d5/d60/utils_8h.html) | Create, manipulate, and synchronize threads. Note that these wrap the basic POSIX calls, which should never be called directly. |
| Thread pools | [threadpool.h](http://doxygen.asterisk.org/trunk/d3/d40/threadpool_8h.html) | A pool of threads to be used for dispatching work items. |
| Task Processors | [taskprocessor.h](http://doxygen.asterisk.org/trunk/d0/d1e/taskprocessor_8h.html) | Thread safe queues for dispatching items in a serialized fashion to a dedicated thread or thread pool. |
| Vectors | [vector.h](http://doxygen.asterisk.org/trunk/d6/d68/vector_8h.html) | A managed and dynamically resizing array. |

Locking
-------

* Is the [locking order](/Development/Reference-Information/Other-Reference-Information/Locking-in-Asterisk) well understood and respected?




---

**Tip:**  Common locking orders:

* Channels are locked before the channel private structure
* Bridges are locked before bridge\_channels, and bridge\_channels before channels
* Channel locks must not be held before going into autoservice
  



---


* Are locks held when accessing data that may change, and are they held when mutating an object?
* When accessing data, are module reloads taken into account?

Memory Allocation
-----------------

### Correct Use of Asterisk Memory Management Functions

* Does the program use `ast_malloc`, `ast_calloc`, `ast_realloc`, and `ast_free`?
* Are stack allocations handled in a manner that ensures the stack will not be overrun?
* If interfacing with another library, are the proper library specific memory management routines used correctly?
* Is memory allocated in the appropriate spaces, i.e., stack versus heap?

### Memory Leaks; Stale Pointers

* Is all memory allocated and freed correctly?
	+ Would appropriate use of the `RAII_VAR` macro simplify the management of memory?
	+ Given the implementation, would users of the proposed changes be able to infer the lifetime of the allocated memory?
* Would any memory allocations be more appropriate as `astobj2` reference counted objects?

Pointer Usage
-------------

* Are pointers checked for `NULL` in appropriate locations?
* Are pointers to reference counted objects de-referenced after their reference has been released?

Immutable Objects
-----------------

* Are the semantics of the object well understood?
* Are there properties that should not be changed on an object by convention?




---

**Note:**  All objects passed as the payload in a Stasis message are immutable by convention. Some objects in the `res_pjsip` stack are immutable by convention as well. When this is the case, the doxygen documentation will note it as such.

  



---

Reference Counted Objects
-------------------------

* Is the ownership of an `ao2` object well defined?
* Are all `ao2_find` references de-referenced?
* Are all objects returned by an `ao2_iterator` de-referenced?
* If `OBJ_NODATA` is not specified, is the return of an `ao2_callback` de-referenced?
* Are the hash and comparison callbacks for an `ao2_container` [implemented correctly?](/Development/Reference-Information/Asterisk-Framework-and-API-Examples/Templates-for-ao2-hash-sort-and-callback-functions.)
* Are all `ao2_callback` uses well understood and necessary?




---

**Note:**  `ao2_callback` can be an expensive operation, as it is `O(n)` - and iterating in the `astobj2` library is not as inexpensive as a more simple linked list implementation.

  



---
* Are all object locks used correctly, and are there instances when lookups can be performed with the `OBJ_NOLOCK` flag?
* Is the reference of an object bumped when it is unlocked, and some other thread could cause it to be destroyed?
* Would appropriate use of the `RAII_VAR` macro simplify the code, or handle off nominal returns in a more graceful fashion?

Strings
-------

* Are string fields used for rarely changing strings on structs?
* Would the use of dynamic strings - `ast_str` - be appropriate?
* Are the Asterisk string functions used?

XML Documentation
-----------------

* Does the XML follow the XML DTD?
	+ The DTD for Asterisk is found in your source directory at /doc/appdocsxml.dtd ([What is an XML DTD?](http://www.w3schools.com/dtd/dtd_intro.asp))
* When testing your build, run configure with `-enable-dev-mode` so the XML will be checked against the DTD
	+ Requires xmllint

 

