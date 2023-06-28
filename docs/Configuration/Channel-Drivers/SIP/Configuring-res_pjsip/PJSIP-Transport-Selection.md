---
title: PJSIP Transport Selection
pageid: 31097159
---

Sending Messages
================

 

The process by which an underlying transport is chosen for sending of a message is broken up into different steps depending on the type of message.SIP Request Handling
--------------------

### 1. URI Parsing

 The PJSIP stack fundamentally acts on URIs. When sending to a URI it is parsed into the various parts (user, host, port, user parameters). For the purposes of transport selection the transport parameter is examined. This specifies the type of transport. If this parameter is not present it is assumed to be UDP. This is important because it is used in DNS resolution. If a "sips" URI scheme is used an automatic switchover to TLS will occur.

### 2. DNS SRV Resolution (If host portion is not an IP address and no port is present in the URI)

The transport type from above is used to determine which SRV record to look up. This means that the original URI **must** include the transport type for TCP and TLS types UNLESS the "sips" URI scheme is used which automatically switches to TLS.### 3a. Transport Selection (No explicit transport provided)

Now that the underlying type of transport is known and the resolved target exists the transport selection process can begin.

#### Connection-less protocols (such as UDP)

A transport, decided upon by a hashing mechanism, matching the transport type and address family is selected.

#### Connection-oriented protocols (such as TCP or TLS)

An already open connection to the resolved IP address and port is searched for. If the connection exists it is reused for the request. If no connection exists the first transport matching the transport type and address family as configured in pjsip.conf is chosen. It is instructed to establish a new connection to the resolved IP address and port.

On this Page


### 3b. Transport Selection (Explicit transport provided)

#### Connection-less protocols (such as UDP)

The provided transport is used.

#### Connection-oriented protocols (such as TCP or TLS)

The provided transport is instructed to establish a new connection to the resolved IP address and port.




!!! info ""
    If an existing connection exists to the IP address and port using the specific transport type then it is reused and a new one is not established.

      
[//]: # (end-info)



### 

Before the message is sent out the transport the routing table is queried to determine what interface it will be going out on.#### Local source interface IP address matches source IP address in message

The message is left untouched and passed to the transport.#### Local source interface IP address differs from source IP address in message

The message contents are updated with the different source address information. If a transport is bound to the new source address the outgoing transport for the message is changed to it.### 5. Message is sent

  
 The message is provided to the transport and it is instructed to send it.

SIP Response Handling
---------------------

###  1. Transport Selection

#### Connection-oriented protocols (such as TCP or TLS)

If the connection the request was received on is still open it is used to send the response.  
 If no connection exists or the connection is no longer open the first configured transport in pjsip.conf matching the transport type and address family is selected. It is instructed to establish a new connection to the destination IP address and port.#### Connection-less protocol with maddr in URI of the topmost Via header

A transport, decided upon by a hashing mechanism, matching the transport type and address family is selected. The transport type and address family of the transport the request was received on is used.#### Connection-less protocol with rport in URI of the topmost Via header

The transport the request is received on is used as the transport for the response.#### Connection-less protocol without rport in URI of the topmost Via header

A transport, decided upon by a hashing mechanism, matching the transport type and address family is selected. The transport type and address family of the transport the request was received on is used.### 2. Message is sent

The message is provided to the selected transport and it is instructed to send it. 

Best Configuration Strategies
=============================

IPv4 Only (Single Interface)
----------------------------

Configure a wildcard transport. This is simple as it requires no special configuration such as knowing the IP address and has no downsides.




---

  
  


```

[system-udp]
type=transport
protocol=udp
bind=0.0.0.0


[system-tcp]
type=transport
protocol=tcp
bind=0.0.0.0
 
 
[system-tls]
type=transport
protocol=tls
bind=0.0.0.0:5061
cert_file=certificate
 
 
[phone]
type=endpoint

```


This example includes an endpoint without a transport explicitly defined. Since there is only one transport configured for each address family and transport type each respective one will be used depending on the URI dialed. For requests to this endpoint the logic in section 3a will be used.

IPv4 Only (Multiple Interfaces)
-------------------------------

Configure a transport for each interface. This allows each transport to be specified on endpoints and also ensures that the SIP messages contain the right information. 




---

  
  


```

[system-internet-udp]
type=transport
protocol=udp
bind=5.5.5.5


[system-internet-tcp]
type=transport
protocol=tcp
bind=5.5.5.5
 
[system-internet-tls]
type=transport
protocol=tls
bind=5.5.5.5:5061
cert_file=certificate


[system-local-udp]
type=transport
protocol=udp
bind=192.168.1.1


[system-local-tcp]
type=transport
protocol=tcp
bind=192.168.1.1
 
 
[system-local-tls]
type=transport
protocol=tls
bind=192.168.1.1:5061
cert_file=certificate
 
[phone-internet]
type=endpoint
transport=system-internet-udp
 
 
[phone-local]
type=endpoint
transport=system-local-udp
 
 
 
[phone-unspecified]
type=endpoint

```


 

This example includes three endpoints which are each present on different networks. To ensure that outgoing requests to the first two endpoints travel over the correct transport the transport has been explicitly specified on each. For requests to these endpoints the logic in section 3b will be used. For requests to the "phone-unspecified" endpoint since no transport has been explicitly specified the logic in section 3a will be used.

IPv6 Only (Single Interface)
----------------------------

Configure a transport with the IPv6 address:

 




---

  
  


```

[system-udp6]
type=transport
protocol=udp
bind=[2001:470:e20f:42::42]


[system-tcp6]
type=transport
protocol=tcp
bind=[2001:470:e20f:42::42]

```


 

IPv4+IPv6 Combined (Single Interface)
-------------------------------------

Configure two transports, one with the IPv4 address and one with the IPv6 address.

 




---

  
  


```

[system-udp]
type=transport
protocol=udp
bind=192.168.1.1


[system-tcp]
type=transport
protocol=tcp
bind=192.168.1.1


[system-udp6]
type=transport
protocol=udp
bind=[2001:470:e20f:42::42]


[system-tcp6]
type=transport
protocol=tcp
bind=[2001:470:e20f:42::42]

```





!!! warning 
    It might be tempting to use a wildcard IPv6 address to bind a single transport to allow both IPv6 and IPv4. In this configuration IPv6 mapped IPv4 addresses will be used which is unsupported by PJSIP. This will cause a SIP message parsing failure.

      
[//]: # (end-warning)



Common Issues
=============

Changeover to TCP when sending via UDP
--------------------------------------

If you turn the "disable_tcp_switch" option off in the pjsip.conf system section it is possible for an automatic switch to TCP to occur when sending a large message out using UDP. If your system has not been configured with a TCP transport this will fail. The sending of the message may also fail if the remote side is not listening on TCP.Sending using a transport that is not available
-----------------------------------------------

If a transport can not be found during the transport selection process you will receive a warning message: 




---

  
  


```

Failed to send Request msg INVITE/cseq=7846 (tdta0x7fa920002e50)! err=171060 (Unsupported transport (PJSIP_EUNSUPTRANSPORT))

```


 

This can occur due to using a transport type (such as TCP) or address family when a transport meeting the requirements does not exist. 

