---
title: PJSIP with Proxies
pageid: 36802159
---

There are many different proxy scenarios Asterisk can be involved in.  Not all can be explained here but a few examples can help you adapt to your specific situation.  The first, and simplest, scenario is where Asterisk is functioning as a PBX on the same private network that the phones are on but needs connectivity to an Internet telephony Service Provider (ITSP).

Outbound Proxy
==============

We'll assume that the ITSP requires Asterisk to register in order to receive calls.   Of course, even with Asterisk behind a NAT firewall or router, a proxy isn't really necessary but the configuration is a good one to start with.  While configuration of a proxy such as Kamailio is beyond the scope of this document, this scenario requires only the simplest of proxy configurations and would probably work with the samples provides by Kamailio.   We'll assume that the proxy is dual homed with one interface on the private network and one interface on the public network.  We'll also assume that the proxy is relaying media as well as signalling.  We'll use `192.168.0.1` as the proxy's private address and `192.168.0.2` as Asterisk's address.

Asterisk Configuration
----------------------

There are several pjsip objects that need to be configured for this situation.

* `transport`: Actually, this is an un-configure action.   If Asterisk were not using a proxy you might have parameters in the transport like `external_signalling_address`, `external_media_address`, `local_net`, etc.  These must NOT be set when Asterisk and the proxy are on the same network.  Asterisk shouldn't know anything about what's on the other side of the proxy since the proxy's job is to make that invisible.  
Example:  
`[ipv4-udp]`  
`type = transport`  
`protocol = udp`  
`bind = 0.0.0.0:5060`
* `endpoint`:  Configure the ITSP's endpoint as you normally would but add an `outbound_proxy` parameter with a URI that points to the proxy's internal address.  This will direct (almost) all outbound requests for this endpoint to the proxy.  You should also not enable any NAT related parameters like `force_rport`, `ice_support`, etc.  
Example:  
`[myitsp]`  
`type = endpoint`  
`; other stuff`  
`outbound_proxy = sip:192.168.0.1\;lr`
* `aor`:  In order for Asterisk to send `OPTIONS` requests to the ITSP via the proxy, the `outbound_proxy` parameter needs to be added here as well.  All other aor parameters, including `contact` should be left just as though there were no proxy.  
Example:  
`[myitsp]`  
`type = aor`  
`contact = sip:my.itsp.com:5060```outbound_proxy = sip:192.168.0.1\;lr`  
qualify_frequency = 60`
* `registration`:  Same as aor.  The client and server URIs should remain as they were for the non-proxy situation and the `outbound_proxy` parameter should be added.  
Example:  
`[myitsp]`  
`type = registration`  
`client_uri = sip:my_account@my.itsp.com`  
`server_uri = sip:my.itsp.com`  
`outbound_proxy = sip:192.168.0.1\;lr`
* `identify`:  Now things get just a little complicated.  Most ITSPs don't authenticate back to their clients when sending them calls and they may be sending the caller's CallerID as the From header's user so the (almost) only way to identify calls from the ITSP is by IP address.   If there were no proxy in the picture, you'd probably set up an `identify` object with a `match = my.itsp.com` parameter.  In the proxy case though, the match needs to be against the proxy's private address since that's the ip address where the packets will come from.  
Example:  
`[myitsp]`  
`type = identify`   
`match = 192.168.0.1`  
`endpoint = myitsp`

You'll have noticed that the proxy URIs have the "lr" parameter added.  This is because most proxies these days follow RFC 3261 and are therefore "loose-routing".  If you don't have it set, you'll probably get a 404 response from the proxy.  The `"\"` before the semicolon is important to keep the semicolon from being treated as a comment start character in the config file.

At this point you should have a working ITSP trunk for both inbound and outbound calls.

Direct Media
------------

If your proxy supports it, you can enable direct media between the phones and the proxy by setting d`irect_media = yes` on the phone and ITSP endpoints.  The proxy should take care of the rest.  Attempting to do direct media directly between the phones and the ITSP is unlikely to work at all.

Multiple ITSPs
--------------

There's a slight issue with the above configuration if you have more than 1 ITSP trunk through the proxy.  In the configuration above, the `identify` object is used to direct incoming requests from the proxy to a single endpoint and you can't direct the same ip address to multiple endpoints for obvious reasons.  You could define 1 `endpoint` and 1 `identify` for the proxy to act as the receiver of calls from all service providers but that's not always convenient or possible with some front end GUIs.  In this case, and if your ITSP supports it, you can use the `line` parameter of the `registration` object as the mechanism to match incoming requests to an endpoint and eliminate the use of `identify` altogether.  Here's how it works:  When you specify `line = true` and `endpoint = <endpoint>` on a registration, Asterisk appends a "line" parameter to the outgoing REGISTER's Contact URI that contains a unique string.  It'll look like this: "`Contact: <sip:s@192.168.0.2.245:5060;line=eylpkkv>"`.  If the ITSP supports it, when it sends an `INVITE` request to Asterisk, it will include that "line" parameter in either the Request URI or the To header like so: "`INVITE sip:8005551212@192.168.0.2:5060;line=eylpkkv SIP/2.0`" .  Asterisk will then use that unique string to match the request to the endpoint specified in the registration.

Example:  
`[myitsp]`  
`type = registration`  
`client_uri = sip:my_account@[my.itsp.com](http://my.itsp.com)`  
`server_uri = sip:[my.itsp.com](http://my.itsp.com)`  
`outbound_proxy = sip:192.168.0.1  
`line = yes`  
`endpoint = myitsp``

### Header Matching

Some ITSPs include "X-" headers in their requests that contain account numbers or other identifying information.  Asterisk 13.15 and 14.5 have a new `identify` feature which enables matching incoming requests to endpoints via those headers.

Example:   
`[myitsp]`  
`type = identify`  
`match_header = X-My-Account-Number: 12345678`  
`endpoint = myitsp` 

Inbound Proxy
=============

In a service provider scenario, Asterisk will most likely be behind a proxy separated from the public internet and the clients, be they phones or PBXes or whatever.  In this case, the configuration burden shifts from Asterisk to the proxy.   You'll probably want to set the proxy up to handle authentication, qualification, direction of media to media gateways, voicemail servers, etc, and that's all well beyond the scope of this document.   Contributions that contain instructions for popular proxies would be most welcomed.

 

