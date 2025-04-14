---
title: Overview
pageid: 32375920
---

The Asterisk Resource
=====================

While the [primary purpose of ARI](/Configuration/Interfaces/Asterisk-REST-Interface-ARI/#ari-an-interface-for-communications-applications) is to allow developers to build their own communications applications using Asterisk as a media engine, there are other resources in the API that are useful outside of this use case. One of these is the `asterisk` resource. This resource not only provides information about the running Asterisk instance, but also exposes resources and operations that allow an external system to manipulate the overall Asterisk system.

On This PageMore DetailRetrieving System Information
=============================

The `asterisk` resource provides the ability to retrieve basic information about the running Asterisk process. This includes:

* Information about how Asterisk was compiled
* Information about Asterisk's configuration
* Current status of the Asterisk process
* Information about the system the Asterisk process is running on

An example of this is shown below:

```bash title=" " linenums="1"
$ curl -X GET -u asterisk:SECRET https://localhost:8088/ari/asterisk/info

{
 "status":
 {
 "startup_time": "2015-07-16T21:01:37.273-0500",
 "last_reload_time": "2015-07-16T21:01:37.273-0500"
 },
 "build":
 {
 "user": "mjordan",
 "options": "AST_DEVMODE, LOADABLE_MODULES, OPTIONAL_API, TEST_FRAMEWORK",
 "machine": "x86_64",
 "os": "Linux",
 "kernel": "3.13.0-24-generic",
 "date": "2015-07-11 15:51:57 UTC"
 },
 "system":
 {
 "version": "GIT-master-0b2cbeaM",
 "entity_id": "ec:f4:bb:67:a6:d0"
 },
 "config":
 {
 "default_language": "en",
 "name":"mjordan-laptop",
 "setid":
 {
 "user": "asterisk",
 "group": "asterisk"
 }
 }
}

```
