---
title: Sorcery
pageid: 27200342
---

Under Construction

Sorcery Overview
================

Added in Asterisk 12, Asterisk has a data abstraction and object persistence CRUD API called Sorcery. Sorcery provides Asterisk modules with a useful abstraction on top of the many storage mechanisms in Asterisk. Such as the:

* Asterisk Database
* Static Configuration Files
* Asterisk Realtime Architecture
* In-Memory

Sorcery also provides a caching service as well as the capability for push configuration through the Asterisk REST Interface. See the section  for more information on that topic.

On This Page3

In This Section 

Modules Supporting Sorcery
==========================

The PJSIP modules and resources were the first to use the Sorcery DAL. All future modules which utilize Sorcery for object persistence must have a column named id within their schema when using the Sorcery realtime module. This column must be able to contain a string of up to 128 characters in length.

Sorcery API Actions
===================

AMI actions existing at the time of Asterisk 14.2.1

* SorceryMemoryCacheExpire
* SorceryMemoryCacheExpireObject
* SorceryMemoryCachePopulate
* SorceryMemoryCacheStale
* SorceryMemoryCacheStaleObject

Sorcery Functions
=================

Sorcery functions existing at the time of Asterisk 14.2.1

* AST\_SORCERY()

Sorcery Mapping Configuration
=============================

Users can configure a hierarchy of data storage layers for specific modules in sorcery.conf.

You can view the sorcery.conf sample in your configs/samples/ Asterisk source subdirectory. Or you can check it out on github: <https://github.com/asterisk/asterisk/blob/master/configs/samples/sorcery.conf.sample>

We've included roughly the same instructions below while taking advantage of wiki formatting.

Constructing a Mapping
----------------------

To allow configuration of where and how an object is persisted, object mappings can be defined within sorcery.conf on a per-module basis. The mapping consists of the **object type**, **options**, **wizard name**, and **wizard configuration data**.

### Format

The basic format follows:

[module\_name] ;The brackets around the module name are literal, just as in most other Asterisk configuration files.
object\_type[/options] = wizard\_name[,wizard\_configuration\_data] ;Bracketed items here are optional### Module name

Object/Wizard mappings are defined within sections denoted by the module name in brackets. The section name must match the module.

### Object types

Note that an object type can have multiple mappings defined. Each mapping will be consulted in the order in which it appears within the configuration file. This means that if you are configuring a wizard as a cache it should appear as the first mapping so the cache is consulted before all other mappings.

Object types available depend on the modules loaded and what objects they provide. There are PJSIP types for all the configuration objects in PJSIP, such as endpoint, auth,aor, etc. You can find a more exhaustive list of PJSIP objects in the  page.

### Wizards

Wizards are the persistence mechanism for objects. They are loaded as Asterisk modules and register themselves with the sorcery core. All implementation specific details of how objects are persisted is isolated within wizards.

A wizard can optionally be marked as an object cache by adding "/cache" to the object type within the mapping. If an object is returned from a non-object cache it is immediately given to the cache to be created. Multiple object caches can be configured for a single object type.

Wizards available at the time of writing:

* astdb
* config
* memory
* realtime
* memory\_cache (For further details on this wizard type see the documentation [here](https://wiki.asterisk.org/wiki/display/AST/Sorcery+Caching))

Example Mapping Configurations
------------------------------

The following object mappings are used by the unit test to test certain functionality of sorcery.

[test\_sorcery\_section]
test=memory
[test\_sorcery\_cache]
test/cache=test
test=memoryThe following object mapping is the default mapping of external MWI mailbox objects to give persistence to the message counts.

[res\_mwi\_external]
mailboxes=astdb,mwi\_externalThe following object mappings set PJSIP objects to use realtime database mappings from extconfig with the table names used when automatically generating configuration from the alembic script.

[res\_pjsip]
endpoint=realtime,ps\_endpoints
auth=realtime,ps\_auths
aor=realtime,ps\_aors
domain\_alias=realtime,ps\_domain\_aliases
contact=realtime,ps\_contacts
 
[res\_pjsip\_endpoint\_identifier\_ip]
identify=realtime,ps\_endpoint\_id\_ipsPJSIP Default Wizard Configurations
-----------------------------------

When configuring PJSIP sorcery mappings it can be useful to allow both the configuration file and other wizards to be used. The below configuration matches the default configuration for the PJSIP sorcery usage.

[res\_pjsip]
auth=config,pjsip.conf,criteria=type=auth
domain\_alias=config,pjsip.conf,criteria=type=domain\_alias
global=config,pjsip.conf,criteria=type=global
system=config,pjsip.conf,criteria=type=system
transport=config,pjsip.conf,criteria=type=transport
aor=config,pjsip.conf,criteria=type=aor
endpoint=config,pjsip.conf,criteria=type=endpoint
contact=astdb,registrator
 
[res\_pjsip\_endpoint\_identifier\_ip]
identify=config,pjsip.conf,criteria=type=identify
 
[res\_pjsip\_outbound\_publish]
outbound-publish=config,pjsip.conf,criteria=type=outbound-publish
 
[res\_pjsip\_outbound\_registration]
registration=config,pjsip.conf,criteria=type=registration 

  
  


