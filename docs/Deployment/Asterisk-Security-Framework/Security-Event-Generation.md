---
title: Security Event Generation
pageid: 5243078
---

The ast\_event API is used for the generation of security events. That way, the events are in an easily interpretable format within Asterisk to make it easy to write modules that do things with them. There are also some helper data structures and functions to aid Asterisk modules in reporting these security events with the proper contents.


The next section of this document contains the current list of security events being proposed. Each security event type has some required pieces of information and some other optional pieces of information. 


Subscribing to security events from within Asterisk can be done by subscribing to events of type AST\_EVENT\_SECURITY. These events have an information element, AST\_EVENT\_IE\_SECURITY\_EVENT, which identifies the security event sub-type (from the list described in the next section). The result of the information elements in the events contain the required and optional meta data associated with the event sub-type.

