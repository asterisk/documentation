---
title: Realtime Database Configuration
pageid: 4620317
---

# Realtime Database Configuration

## Introduction

The Asterisk Realtime Architecture is a new set of drivers and functions implemented in Asterisk.  
 The benefits of this architecture are many, both from a code management standpoint and from an installation perspective.  
 The ARA is designed to be independent of storage. Currently, most drivers are based on SQL, but the architecture should be able to handle other storage methods in the future, like LDAP.

The main benefit comes in the database support. In Asterisk v1.0 some functions supported MySQL database, some PostgreSQL and other ODBC. With the ARA, we have a unified database interface internally in Asterisk, so if one function supports database integration, all databases that has a realtime driver will be supported in that function.  
 Currently there are three realtime database drivers:

1. ODBC: Support for UnixODBC, integrated into Asterisk The UnixODBC subsystem supports many different databases, please check www.unixodbc.org for more information.
2. MySQL: Native support for MySQL, integrated into Asterisk
3. PostgreSQL: Native support for Postgres, integrated into Asterisk

## Two modes: Static and Realtime

The ARA realtime mode is used to dynamically load and update objects. This mode is used in the SIP and IAX2 channels, as well as in the voicemail system. For SIP and IAX2 this is similar to the v1.0 MYSQL\_FRIENDS functionality. With the ARA, we now support many more databases for dynamic configuration of phones.

The ARA static mode is used to load configuration files. For the Asterisk modules that read configurations, there's no difference between a static file in the file system, like extensions.conf, and a configuration loaded from a database.  
 You just have to always make sure the var\_metric values are properly set and ordered as you expect in your database server if you're using the static mode with ARA (either sequentially or with the same var\_metric value for everybody).

If you have an option that depends on another one in a given configuration file (i.e, 'musiconhold' depending on 'agent' from agents.conf) but their var\_metric are not sequential you'll probably get default values being assigned for those options instead of the desired ones. You can still use the same var\_metric for all entries in your DB, just make sure the entries are recorded in an order that does not break the option dependency.

That doesn't happen when you use a static file in the file system. Although this might be interpreted as a bug or limitation, it is not.


**Information:**  To use static realtime with certain core configuration files (e.g. `features.conf`, `cdr.conf`, `cel.conf`, `indications.conf`, etc.) the realtime backend you wish to use must be preloaded in `modules.conf`.

```
[modules]
preload => res_odbc.so
preload => res_config_odbc.so
```

## Realtime SIP friends

The SIP realtime objects are users and peers that are loaded in memory when needed, then deleted. This means that Asterisk currently can't handle voicemail notification and NAT keepalives for these peers. Other than that, most of the functionality works the same way for realtime friends as for the ones in static configuration.

With caching, the device stays in memory for a specified time. More information about this is to be found in the sip.conf sample file.

If you specify a separate family called "sipregs" SIP registration data will be stored in that table and not in the "sippeers" table.

## Realtime H.323 friends

Like SIP realtime friends, H.323 friends also can be configured using dynamic realtime objects.

## New function in the dial plan: The Realtime Switch

The realtime switch is more than a port of functionality in v1.0 to the new architecture, this is a new feature of Asterisk based on the ARA. The realtime switch lets your Asterisk server do database lookups of extensions in realtime from your dial plan. You can have many Asterisk servers sharing a dynamically updated dial plan in real time with this solution.  


## Capabilities

The realtime Architecture lets you store all of your configuration in databases and reload it whenever you want. You can force a reload over the AMI, Asterisk Manager Interface or by calling Asterisk from a shell script with

```
asterisk -rx "reload"
```

You may also dynamically add SIP and IAX devices and extensions and making them available without a reload, by using the realtime objects and the realtime switch.

## Configuration in extconfig.conf

You configure the ARA in extconfig.conf (yes, it's a strange name, but is was defined in the early days of the realtime architecture and kind of stuck).

The part of Asterisk that connects to the ARA use a well defined family name to find the proper database driver. The syntax is easy:

```
<family> => <realtime driver>,<res_<driver>.conf class name>[,<table>]
```

The options following the realtime driver identified depends on the driver.

Defined well-known family names are:

* sippeers, sipusers - SIP peers and users
* sipregs - SIP registrations
* iaxpeers, iaxusers - IAX2 peers and users
* voicemail - Voicemail accounts
* extensions - Realtime extensions (switch)
* meetme - MeetMe conference rooms
* queues - Queues
* queue\_members - Queue members
* musiconhold - Music On Hold classes
* queue\_log - Queue logging

Voicemail storage with the support of ODBC described in [ODBC Voicemail Storage](/ODBC-Voicemail-Storage).

## Limitations

Currently, realtime extensions do not support realtime hints. There is a workaround available by using func\_odbc. See the sample func\_odbc.conf for more information.

## FreeTDS supported with connection pooling

In order to use a FreeTDS-based database with realtime, you need to turn connection pooling on in res\_odbc.conf. This is due to a limitation within the FreeTDS protocol itself. Please note that this includes databases such as MS SQL Server and Sybase. This support is new in the current release.

You may notice a performance issue under high load using UnixODBC. The UnixODBC driver supports threading but you must specifically enable threading within the UnixODBC configuration file like below for each engine:

```
Threading = 2
```

This will enable the driver to service many requests at a time, rather than serially.

## Notes on use of the sipregs family

The community provided some additional recommendations on the JIRA issue [ASTERISK-21315](https://issues.asterisk.org/jira/browse/ASTERISK-21315):

* It is a good idea to avoid using sipregs altogether by NOT enabling it in extconfig. Using a writable sipusers table should be enough. If you cannot write to your base sipusers table because it is readonly, you could consider making a separate sipusers view that joins the readonly table with a writable sipregs table.
