---
title: Configuring res_pjsip for IPv6
pageid: 34013468
---

Tell Asterisk and PJSIP to Speak IPv6
=====================================

The configuration described here happens in the pjsip.conf file within transport and endpoint sections. For more information about the transport side of things see [PJSIP Transport Selection](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/PJSIP-Transport-Selection)

Bind PJSIP to a specific interface
----------------------------------

To configure res_pjsip for communication over an IPv6 interface you must modify the bind address for your transports in pjsip.conf.

```
[transport-udp6]
type=transport
protocol=udp
bind=[fe80::5e26:aff:fe4b:4399]

[transport-tcp6]
type=transport
protocol=tcp
bind=[fe80::5e26:aff:fe4b:4399]

```

Bind PJSIP to the first available IPv6 interface
------------------------------------------------

A transport can be configured to automatically bind to the first available IPv6 interface. You use "::" as the bind address.

```
[transport-auto-ipv6]
type=transport
protocol=udp
bind=::

```

Configure a PJSIP endpoint to use RTP over IPv6
-----------------------------------------------

There is no additional configuration required to have an endpoint use RTP over IPv6. IPv4 or IPv6 will be automatically chosen based on the address family of the address for signaling. That is: If an endpoint is using IPv4 it will be IPv4, if it is using IPv6 it will be IPv6.

```
[mytrunk]
type=endpoint
transport=transport-udp6
context=from-external
disallow=all
allow=ulaw

```
