---
title: Configuring chan_iax2 for IPv6
pageid: 34013484
---

Configuration
=============

IAX uses the 'bindaddr' and 'bindport' options to specify on which address and port the IAX2 channel driver will listen for incoming requests. They accept IPv6 as well as IPv4 addresses.

Examples
--------

```
bindport=4569

```

The default port to listen on is 4569. Bindport must be specified **before** bindaddr or may be specified on a specific bindaddr if followed by colon and port (e.g. bindaddr=192.168.0.1:4569).

For IPv6 the address needs to be in brackets then colon and port (e.g. bindaddr=[2001:db8::1]:4569).

```
bindaddr=192.168.0.1:459
bindaddr=[2001:db8::1]:4569

```

You can specify 'bindaddr' more than once to bind to multiple addresses, but the first will be the default. IPv6 addresses are accepted.

!!! tip 
    For details IAX configuration examples see the iax.conf.sample file that comes with the source.

[//]: # (end-tip)
