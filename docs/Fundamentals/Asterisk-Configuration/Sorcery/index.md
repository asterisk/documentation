---
title: Overview
pageid: 27200342
---




!!! warning 
    Under Construction

      
[//]: # (end-warning)



Sorcery Overview
================

Added in Asterisk 12, Asterisk has a data abstraction and object persistence CRUD API called Sorcery. Sorcery provides Asterisk modules with a useful abstraction on top of the many storage mechanisms in Asterisk. Such as the:

* Asterisk Database
* Static Configuration Files
* Asterisk Realtime Architecture
* In-Memory

Sorcery also provides a caching service as well as the capability for push configuration through the Asterisk REST Interface. See the section [ARI Push Configuration](/Configuration/Interfaces/Asterisk-REST-Interface-ARI/The-Asterisk-Resource/ARI-Push-Configuration) for more information on that topic.

On This Page


In This Section

Modules Supporting Sorcery
==========================

The PJSIP modules and resources were the first to use the Sorcery DAL. All future modules which utilize Sorcery for object persistence must have a column named id within their schema when using the Sorcery realtime module. This column must be able to contain a string of up to 128 characters in length.

Sorcery API Actions
===================

AMI actions existing at the time of Asterisk 14.2.1

* [SorceryMemoryCacheExpire](/latest_api/AMI_Actions/SorceryMemoryCacheExpire)
* [SorceryMemoryCacheExpireObject](/latest_api/AMI_Actions/SorceryMemoryCacheExpireObject)
* [SorceryMemoryCachePopulate](/latest_api/AMI_Actions/SorceryMemoryCachePopulate)
* [SorceryMemoryCacheStale](/latest_api/AMI_Actions/SorceryMemoryCacheStale)
* [SorceryMemoryCacheStaleObject](/latest_api/AMI_Actions/SorceryMemoryCacheStaleObject)

Sorcery Functions
=================

Sorcery functions existing at the time of Asterisk 14.2.1

* [AST_SORCERY()](/latest_api/Dialplan_Functions/AST_SORCERY)

Sorcery Mapping Configuration
=============================

Users can configure a hierarchy of data storage layers for specific modules in sorcery.conf.

You can view the sorcery.conf sample in your configs/samples/ Asterisk source subdirectory. Or you can check it out on github: <https://github.com/asterisk/asterisk/blob/master/configs/samples/sorcery.conf.sample>

We've included roughly the same instructions below while taking advantage of wiki formatting.

Constructing a Mapping
----------------------

To allow configuration of where and how an object is persisted, object mappings can be defined within sorcery.conf on a per-module basis. The mapping consists of the **object type**, **options**, **wizard name**, and **wizard configuration data**.

### Format

The basic format follows:

```
[module_name] ;The brackets around the module name are literal, just as in most other Asterisk configuration files.
object_type[/options] = wizard_name[,wizard_configuration_data] ;Bracketed items here are optional

```

### Module name

Object/Wizard mappings are defined within sections denoted by the module name in brackets. The section name must match the module.

### Object types

Note that an object type can have multiple mappings defined. Each mapping will be consulted in the order in which it appears within the configuration file. This means that if you are configuring a wizard as a cache it should appear as the first mapping so the cache is consulted before all other mappings.

Object types available depend on the modules loaded and what objects they provide. There are PJSIP types for all the configuration objects in PJSIP, such as endpoint, auth,aor, etc. You can find a more exhaustive list of PJSIP objects in the [Sorcery Caching](/Fundamentals/Asterisk-Configuration/Sorcery/Sorcery-Caching) page.

### Wizards

Wizards are the persistence mechanism for objects. They are loaded as Asterisk modules and register themselves with the sorcery core. All implementation specific details of how objects are persisted is isolated within wizards.

A wizard can optionally be marked as an [object cache](/Fundamentals/Asterisk-Configuration/Sorcery/Sorcery-Caching) by adding "/cache" to the object type within the mapping. If an object is returned from a non-object cache it is immediately given to the cache to be created. Multiple object caches can be configured for a single object type.

Wizards available at the time of writing:

* astdb
* config
* memory
* realtime
* memory_cache (For further details on this wizard type see the documentation [here](/Fundamentals/Asterisk-Configuration/Sorcery/Sorcery-Caching))

Example Mapping Configurations
------------------------------

The following object mappings are used by the unit test to test certain functionality of sorcery.

```
[test_sorcery_section]
test=memory
[test_sorcery_cache]
test/cache=test
test=memory

```

The following object mapping is the default mapping of external MWI mailbox objects to give persistence to the message counts.

```
[res_mwi_external]
mailboxes=astdb,mwi_external

```

The following object mappings set PJSIP objects to use realtime database mappings from extconfig with the table names used when automatically generating configuration from the alembic script.

```
[res_pjsip]
endpoint=realtime,ps_endpoints
auth=realtime,ps_auths
aor=realtime,ps_aors
domain_alias=realtime,ps_domain_aliases
contact=realtime,ps_contacts
 
[res_pjsip_endpoint_identifier_ip]
identify=realtime,ps_endpoint_id_ips

```

PJSIP Default Wizard Configurations
-----------------------------------

When configuring PJSIP sorcery mappings it can be useful to allow both the configuration file and other wizards to be used. The below configuration matches the default configuration for the PJSIP sorcery usage.

```
[res_pjsip]
auth=config,pjsip.conf,criteria=type=auth
domain_alias=config,pjsip.conf,criteria=type=domain_alias
global=config,pjsip.conf,criteria=type=global
system=config,pjsip.conf,criteria=type=system
transport=config,pjsip.conf,criteria=type=transport
aor=config,pjsip.conf,criteria=type=aor
endpoint=config,pjsip.conf,criteria=type=endpoint
contact=astdb,registrator
 
[res_pjsip_endpoint_identifier_ip]
identify=config,pjsip.conf,criteria=type=identify
 
[res_pjsip_outbound_publish]
outbound-publish=config,pjsip.conf,criteria=type=outbound-publish
 
[res_pjsip_outbound_registration]
registration=config,pjsip.conf,criteria=type=registration

```



  


