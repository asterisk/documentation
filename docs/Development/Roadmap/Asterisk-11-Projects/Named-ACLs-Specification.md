---
title: Named ACLs Specification
pageid: 20185274
---

Overview
========

The primary goal for Named ACLs (Access Control Lists) is to provide users with a way to create commonly used ACL profiles and to be able to use those profiles wherever ACLs are consumed without the need to duplicate the list each time it is used (often with varying keywords for defining the ACLs). This will make the creation and maintainence of complex ACLs an easier, less error prone process. An implementation of this concept exists within a team branch written by Olle E. Johansson.

Table of Contents
=================

Use Cases - Initial Implementation
==================================

These use cases define the behavior of the Named ACL feature with respect to the initial implementation put up for review here:

<https://reviewboard.asterisk.org/r/1978/>

Actors
------

* Named ACL Subsystem - the ACL subsystem that owns the definition of the named ACLs. Currently, this is acl.c.
* Consumers - subsystems that use named ACLs to make internal decisions, e.g., chan_sip.

Note that the configuration information for these actors could come from a variety of sources, such as .conf files, RealTime backends, etc.

Named ACL and Consumers - Module Load
-------------------------------------

##### Actors

* Named ACL Subsystem.
* One or more Consumers.

##### Preconditions

* Configuration exists for all actors.

##### Scenario

1. The Named ACL Subsystem is initialized.
2. The Named ACL Subsystem loads configuration information.
3. Each category in the configuration specifies a unique named ACL. Key/value pairs within that category define the rules for that ACL.
4. A Consumer is initialized (from here, steps are repeated for each consumer).
5. The Consumer loads its configuration information.
6. The Consumer's configuration specifies the usage of a named ACL defined by the Named ACL Subsystem.
7. The Consumer has the ability to verify whether or not the named ACL key is valid.

##### Post Conditions

* The Consumers have a key by which they can determine whether or not an address is allowable by that named ACL.

### Named ACL - Reload

##### Actors

* Named ACL Subsystem.
* User or AMI connection.
* Consumers

##### Preconditions

* Updated configuration exists for the Named ACL Subsystem.

##### Scenario

1. The User or an AMI connection initiates a reload operation on the Named ACL Subsystem.
2. The Named ACL subsystem reloads configuration information from its configuration.
3. Atomically, the ACL subsystem replaces its named ACLs with those from its updated configuration.
4. The Named ACL Subsystem notifies Consumers that its configuration was updated.

##### Postconditions

* The Named ACL subsystem is reloaded with an updated configuration.
* Consumers are notified that the Named ACL subsystem was updated.

### Consumer of ACLs is loading and requests a named ACL

##### Actors

* Named ACL Subsystem
* A single Consumer

##### Preconditions

* A loaded and configured named ACL subsystem

##### Scenario - named ACL exists

1. The consumer requests the ACL with the given name from the named ACL Subsystem
2. The consumer receives a copy of the requested ACL

##### Scenario - named ACL does not exist in Named ACL Subsystem

1. The consumer requests the ACL with the given name from the named ACL Subsystem
2. The consumer is unable to obtain ACL information for that named ACL from the named ACL subsystem
3. The consumer warns the system of a configuration error. Any use of the ACL will result in rejection.

### Consumer asks for named ACL information

##### Actors

* Named ACL Subsystem.
* A single Consumer.

##### Preconditions

* A loaded and configured Named ACL Subsystem and Consumer.

##### Scenario - named ACL exists

1. The Consumer receives an address that it must verify against a named ACL.
2. The Consumer verifies the address using the named ACL information from the Named ACL Subsystem.

##### Scenario - named ACL does not exist in Named ACL Subsystem

1. The Consumer receives an address that it must verify against a named ACL.
2. The Consumer is unable to obtain ACL information for that named ACL from the Named ACL Subsystem.
3. The Consumer warns the system (and relevant security frameworks) of a configuration error.

Use Cases - Dynamic Named ACL Updating
======================================

These Use Cases define the behavior specified in Olle's pinequeue branch:

[Pinequeue README](http://svnview.digium.com/svn/asterisk/team/oej/deluxepine-trunk/README.nacl?revision=242040)

Actors
------

In addition to the previously defined actors, the following are also present in these use cases.

* Initiator - either a user initiating an update via a CLI command, a third party via an AMI connection, or some other external mechanism

### Initiator updates a named ACL

##### Actors

* Initiator.
* Named ACL Subsystem.
* Consumers.

##### Preconditions

* A loaded and configured Named ACL Subsystem and Consumer.

##### Scenario

1. Initiator provides information that adds or modified an existing named ACL.
2. Named ACL Subsystem updates its information.
3. Named ACL Subsystem updates its backing storage.
4. The Named ACL Subsystem notifies Consumers that its configuration was updated.
5. Consumer's named ACL information is modified based on the update.

##### Postconditions

* The Named ACL subsystem is updated with the new named ACL information.
* Consumers are notified that the Named ACL subsystem was updated.
* Consumer's named ACL information is changed to reflect the update.

### Consumer updates a named ACL

##### Actors

* Named ACL Subsystem.
* Consumers.

##### Preconditions

* A loaded and configured Named ACL Subsystem and Consumer.
* A Consumer has received information that a named ACL should be added or modified.

##### Scenario - Add or Update Accepted

1. Consumer requests that a named ACL be added or updated with the appropriate information.
2. Named ACL Subsystem determines that the ACL can be added or updated.
3. Named ACL Subsystem updates its information.
4. Named ACL Subsystem updates its backing storage.
5. The Named ACL Subsystem notifies Consumers that its configuration was updated.
6. Consumer's named ACL information is modified based on the update.

##### Postconditions

* The Named ACL subsystem is updated with the new named ACL information.
* Consumers are notified that the Named ACL subsystem was updated.
* Consumer's named ACL information is changed to reflect the update.

##### Scenario - Add or Update Rejected

1. Consumer requests that a named ACL be added or updated with the appropriate information.
2. Named ACL Subsystem determines that the ACL should not be added or updated.
3. The Named ACL Subsystem rejects the request.
4. The Consumer warns the system (and relevant security frameworks) of a configuration error.

##### Postconditions

* No change in the configuration of the Consumer or the Named ACL Subsystem

Design
======

Named ACL subsystem
-------------------

The Named ACL subsystem is responsible for reading ACLs from configurations and the realtime database and pushing events about ACL changes to consumers when required. Changes may occur for numerous reasons including reloads of the ACL configuration, requests made by consumers, and possibly others. When a change occurs, the named ACL subsystem will create and fire an ACL change event indicating the nature of the change so that it can be picked up by the subscriber's callback and reacted to appropriately.

ACL Consumer Usage
------------------

### ast_acl structure

The concept of an ast_acl should replace the usage of ast_ha structs at the consumer level.  

The ast_acl struct is similar to the current ast_ha struct in that it is a linked list of rules. Instead of each node being a single rule though, each node contains a list of rules. The whole thing could be written as an index.  

example:

* The non-named ACL component
	1. deny all
	2. permit ha1
	3. permit ha2
	4. permit ha3
* name1 (blacklist)
	1. permit all
	2. deny ha4
	3. deny ha5
* name2  

...
* name3  

...

When evaluating an ast_acl structure, each individual ACL within the list will be evaluated separately against the provided address.  The application will return with AST_SENSE_PERMIT if and only if all of the applications of that individual ACLs return AST_SENSE_PERMIT. If any of the rules return AST_SENSE_DENY, the whole ACL will return AST_SENSE_DENY.

This approach is useful because it makes updating ACL containers easy.  If we want to update a whole container, we can simply iterate through the named elements of the ast_acl and ast_free_ha the head of each list and attach a fresh duplicate retrieved from the named ACL subsystem.
