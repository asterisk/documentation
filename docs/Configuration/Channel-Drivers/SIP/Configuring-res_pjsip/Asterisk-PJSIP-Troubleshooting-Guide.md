---
title: Asterisk PJSIP Troubleshooting Guide
pageid: 30278355
---




---

**WARNING!:**   
This page is currently under construction. Please refrain from commenting until this warning is removed.

  



---


Overview
========

Are you having problems getting your PJSIP setup working properly? If you are encountering a common problem then hopefully your answer can be found on this page.

Before looking any further here, you should make sure that you have gathered enough information from Asterisk to know what your issue is. It is suggested that you perform the following actions at the Asterisk CLI:

* `core set verbose 4`
* `core set debug 4`
* `pjsip set logger on`

With these options enabled, this will allow you to more easily see what is going on behind the scenes in your failing scenario. It also can help you to cross-reference entries on this page since several debug, warning, and error messages will be quoted here.

Inbound Calls
=============

Unrecognized Endpoint
---------------------

All inbound SIP traffic to Asterisk must be matched to a configured endpoint. If Asterisk is unable to determine which endpoint the SIP request is coming from, then the incoming request will be rejected. If you are seeing messages like:

On this Page





---

  
  


```

[2014-10-13 16:12:17.349] DEBUG[27284]: res\_pjsip\_endpoint\_identifier\_user.c:106 username\_identify: Could not identify endpoint by username 'eggowaffles'

```



---


or




---

  
  


```

[2014-10-13 16:13:07.201] DEBUG[27507]: res\_pjsip\_endpoint\_identifier\_ip.c:113 ip\_identify\_match\_check: Source address 127.0.0.1:5061 does not match identify 'david-ident'

```



---


then this is a good indication that the request is being rejected because Asterisk cannot determine which endpoint the incoming request is coming from.

How does Asterisk determine which endpoint a request is coming from? Asterisk uses something called "endpoint identifiers" to determine this. There are three endpoint identifiers bundled with Asterisk: user, ip, and anonymous.

### Identify by User

The user endpoint identifier is provided by the `res_pjsip_endpoint_identifier_user.so` module. If nothing has been explicitly configured with regards to endpoint identification, this endpoint identifier is the one being used. The way it works is to use the user portion of the From header from the incoming SIP request to determine which endpoint the request comes from. Here is an example INVITE:




---

  
  


```

<--- Received SIP request (541 bytes) from UDP:127.0.0.1:5061 --->
INVITE sip:service@127.0.0.1:5060 SIP/2.0
Via: SIP/2.0/UDP 127.0.0.1:5061;branch=z9hG4bK-27600-1-0
From: breakfast <sip:eggowaffles@127.0.0.1:5061>;tag=27600SIPpTag001
To: sut <sip:service@127.0.0.1>
Call-ID: 1-27600@127.0.0.1
CSeq: 1 INVITE
Contact: sip:eggowaffles@127.0.0.1:5061
Max-Forwards: 70
Content-Type: application/sdp
Content-Length: 163

v=0
o=user1 53655765 2353687637 IN IP4 127.0.0.1
s=-
c=IN IP4 127.0.0.1
t=0 0
m=audio 6000 RTP/AVP 0
a=rtpmap:8 PCMA/8000
a=rtpmap:0 PCMU/8000
a=ptime:20

```



---


In this example, the URI in the From header is "sip:eggowaffles@127.0.0.1:5061". The user portion is "eggowaffles", so Asterisk attempts to look up an endpoint called "eggowaffles" in its configuration. If such an endpoint is not configured, then the INVITE is rejected by Asterisk. The most common cause of the problem is that the user name referenced in the From header is not the name of a configured endpoint in Asterisk.

But what if you have configured an endpoint called "eggowaffles"? It is possible that there was an error in your configuration, such as an option name that Asterisk does not recognize. If this is the case, then the endpoint may not have been loaded at all. Here are some troubleshooting steps to see if this might be the case:

* From the CLI, issue the "pjsip show endpoints" command. If the endpoint in question does not show up, then there likely was a problem attempting to load the endpoint on startup.
* Go through the logs from Asterisk startup. You may find that there was an error reported that got lost in the rest of the startup messages. For instance, be on the lookout for messages like:




---

  
  


```

[2014-10-13 16:25:01.674] ERROR[27771]: config\_options.c:710 aco\_process\_var: Could not find option suitable for category 'eggowaffles' named 'setvar' at line 390 of 
[2014-10-13 16:25:01.674] ERROR[27771]: res\_sorcery\_config.c:275 sorcery\_config\_internal\_load: Could not create an object of type 'endpoint' with id 'eggowaffles' from configuration file 'pjsip.conf'

```



---


In this case, I set an endpoint option called "setvar" instead of the appropriate "set\_var". The result was that the endpoint was not loaded.
* If you do not see such error messages in the logs, but you do not see the endpoint listed in "pjsip show endpoints", it may be that you forgot to put `type = endpoint` in your endpoint section. In this case, the entire section would be ignored since Asterisk did not know that this was an endpoint section.

### Identify by IP address

Asterisk can also recognize endpoints based on the source IP address of the SIP request. This requires setting up a `type = identify` section in your configuration to match IP addresses or networks to a specific endpoint. Here are some troubleshooting steps:

* Ensure that `res_pjsip_endpoint_identifier_ip.so` is loaded and running. From the CLI, run `module show like res_pjsip_endpoint_identifier_ip.so`. The output should look like the following:




---

  
  


```

Module Description Use Count Status Support Level
res\_pjsip\_endpoint\_identifier\_ip.so PJSIP IP endpoint identifier 0 Running core

```



---
* Run the troubleshooting steps from the Identify by User section to ensure that the endpoint you have configured has actually been properly loaded.
* From the Asterisk CLI, run the command `pjsip show endpoint <endpoint name>`. Below the headers at the top of the output, you should see something like the following:




---

  
  


```

 Endpoint: david/6001 Unavailable 0 of inf
 InAuth: david-auth/david
 Aor: david 10
 Transport: main-transport udp 0 0 0.0.0.0:5060
 Identify: 10.24.16.36/32

```



---


Notice the bottom line. This states that the endpoint is matched based on the IP address 10.24.16.36. If you do not see such a line for the endpoint that you expect to be matched, then there is likely a configuration error. If the line does appear, then ensure that the IP address listed matches what you expect for the endpoint.
* If you are noticing that Asterisk is matching the incorrect endpoint by IP address, ensure that there are no conflicts in your configuration. Run the `pjsip show endpoints` command and look for issues such as the following:




---

  
  


```

 Endpoint: carol/6000 Unavailable 0 of inf
 InAuth: carol-auth/carol
 Aor: carol 10
 Transport: main-transport udp 0 0 0.0.0.0:5060
 Identify: 10.0.0.0/8

 Endpoint: david/6001 Unavailable 0 of inf
 InAuth: david-auth/david
 Aor: david 10
 Transport: main-transport udp 0 0 0.0.0.0:5060
 Identify: 10.24.16.36/32

```



---


Notice that if a SIP request arrives from 10.24.16.36, it is ambiguous if the request should be matched to carol or david.

If you run `pjsip show endpoint <endpoint name>` and do not see an "Identify" line listed, then there is likely a configuration issue somewhere. Here are some common pitfalls

* Ensure that your identify section has `type = identify` in it. Without this, Asterisk will completely ignore the configuration section.
* Ensure that your identify section has an `endpoint`option set in it and that the endpoint is spelled correctly.
* Double-check your `match` lines for common errors:
	+ You cannot use FQDNs or hostnames. You must use IP addresses.
	+ Ensure that you do not have an invalid netmask (e.g. 10.9.3.4/255.255.255.300, 127.0.0.1/33).
	+ Ensure that you have not mixed up /0 and /32 when using CIDR notation.
* If you are using a configuration method other than a config file, ensure that `sorcery.conf` is configured correctly. Since identify sections are not provided by the base `res_pjsip.so` module, you must ensure that the configuration resides in the `res_pjsip_endpoint_identifier_ip` section of `sorcery.conf`. For example, if you are using dynamic realtime, you might have the following configuration:

sorcery.conf


---

  
  


```

true[res\_pjsip\_endpoint\_identifier\_ip]
identify = realtime,ps\_endpoint\_id\_ips

```



---


And then you would need the corresponding config in `extconfig.conf`:

extconfig.conf


---

  
  


```

true[settings]
ps\_endpoint\_id\_ips => odbc 

```



---

### Anonymous Identification

Anonymous endpoint identification allows for a specially-named endpoint called "anonymous" to be matched if other endpoint identifiers are not able to determine which endpoint a request originates from. The `res_pjsip_endpoint_identifier_anonymous.so` module is responsible for matching the incoming request to the anonymous endpoint. If SIP traffic that you expect to be matched to the anonymous endpoint is being rejected, try the following troubleshooting steps:

* Ensure that `res_pjsip_endpoint_identifier_anonymous.so` is loaded and running. From the Asterisk CLI, run `module show like res_pjsip_endpoint_identifier_anonymous.so`. The output should look like the following:




---

  
  


```

Module Description Use Count Status Support Level
res\_pjsip\_endpoint\_identifier\_anonymous.so PJSIP Anonymous endpoint identifier 0 Running core

```



---
* Ensure that the "anonymous" endpoint has been properly loaded. See the troubleshooting steps in the Identify by User section for more details about how to determine if an endpoint has been loaded.

Authentication is failing
-------------------------

The first thing you should check if you believe that authentication is failing is to ensure that this is the actual problem. Consider the following SIP call from endpoint 200 to Asterisk:




---

  
  


```

<--- Received SIP request (1053 bytes) from UDP:10.24.16.37:5060 --->
INVITE sip:201@10.24.20.249 SIP/2.0
Via: SIP/2.0/UDP 10.24.16.37:5060;rport;branch=z9hG4bKPjQevrxvXqk9Lk5xSW.pzQQb8SAWnJ5Lll
Max-Forwards: 70
From: "200" <sip:200@10.24.20.249>;tag=DTD-tYEwFMmbPyu0YWalLQdbEUGSLGN5
To: <sip:201@10.24.20.249>
Contact: "200" <sip:200@10.24.16.37:5060;ob>
Call-ID: q.TF2SAaX3jn8dtaLTOCuIO8FRyDCsSR
CSeq: 9775 INVITE
Allow: PRACK, INVITE, ACK, BYE, CANCEL, UPDATE, SUBSCRIBE, NOTIFY, REFER, MESSAGE, OPTIONS
Supported: replaces, 100rel, timer, norefersub
Session-Expires: 1800
Min-SE: 90
User-Agent: Digium D40 1\_4\_0\_0\_57389
Content-Type: application/sdp
Content-Length: 430

v=0
o=- 108683760 108683760 IN IP4 10.24.16.37
s=digphn
c=IN IP4 10.24.16.37
t=0 0
a=X-nat:0
m=audio 4046 RTP/AVP 0 8 9 111 18 58 118 58 96
a=rtcp:4047 IN IP4 10.24.16.37
a=rtpmap:0 PCMU/8000
a=rtpmap:8 PCMA/8000
a=rtpmap:9 G722/8000
a=rtpmap:111 G726-32/8000
a=rtpmap:18 G729/8000
a=rtpmap:58 L16/16000
a=rtpmap:118 L16/8000
a=rtpmap:58 L16-256/16000
a=sendrecv
a=rtpmap:96 telephone-event/8000
a=fmtp:96 0-15


<--- Transmitting SIP response (543 bytes) to UDP:10.24.16.37:5060 --->
SIP/2.0 401 Unauthorized
Via: SIP/2.0/UDP 10.24.16.37:5060;rport;received=10.24.16.37;branch=z9hG4bKPjQevrxvXqk9Lk5xSW.pzQQb8SAWnJ5Lll
Call-ID: q.TF2SAaX3jn8dtaLTOCuIO8FRyDCsSR
From: "200" <sip:200@10.24.20.249>;tag=DTD-tYEwFMmbPyu0YWalLQdbEUGSLGN5
To: <sip:201@10.24.20.249>;tag=z9hG4bKPjQevrxvXqk9Lk5xSW.pzQQb8SAWnJ5Lll
CSeq: 9775 INVITE
WWW-Authenticate: Digest realm="asterisk",nonce="1413305427/8dd1b7f56aba97da45754f7052d8a688",opaque="3b9c806b61adf911",algorithm=md5,qop="auth"
Content-Length: 0


<--- Received SIP request (370 bytes) from UDP:10.24.16.37:5060 --->
ACK sip:201@10.24.20.249 SIP/2.0
Via: SIP/2.0/UDP 10.24.16.37:5060;rport;branch=z9hG4bKPjQevrxvXqk9Lk5xSW.pzQQb8SAWnJ5Lll
Max-Forwards: 70
From: "200" <sip:200@10.24.20.249>;tag=DTD-tYEwFMmbPyu0YWalLQdbEUGSLGN5
To: <sip:201@10.24.20.249>;tag=z9hG4bKPjQevrxvXqk9Lk5xSW.pzQQb8SAWnJ5Lll
Call-ID: q.TF2SAaX3jn8dtaLTOCuIO8FRyDCsSR
CSeq: 9775 ACK
Content-Length: 0


<--- Received SIP request (1343 bytes) from UDP:10.24.16.37:5060 --->
INVITE sip:201@10.24.20.249 SIP/2.0
Via: SIP/2.0/UDP 10.24.16.37:5060;rport;branch=z9hG4bKPjCrZnx79augJPtGcTbYlXEs2slZNtwYeC
Max-Forwards: 70
From: "200" <sip:200@10.24.20.249>;tag=DTD-tYEwFMmbPyu0YWalLQdbEUGSLGN5
To: <sip:201@10.24.20.249>
Contact: "200" <sip:200@10.24.16.37:5060;ob>
Call-ID: q.TF2SAaX3jn8dtaLTOCuIO8FRyDCsSR
CSeq: 9776 INVITE
Allow: PRACK, INVITE, ACK, BYE, CANCEL, UPDATE, SUBSCRIBE, NOTIFY, REFER, MESSAGE, OPTIONS
Supported: replaces, 100rel, timer, norefersub
Session-Expires: 1800
Min-SE: 90
User-Agent: Digium D40 1\_4\_0\_0\_57389
Authorization: Digest username="200", realm="asterisk", nonce="1413305427/8dd1b7f56aba97da45754f7052d8a688", uri="sip:201@10.24.20.249", response="2da759314909af8507a59cd1b6bc0baa", algorithm=md5, cnonce="-me-qsYc.rGU-I5A6n-Dy8IhCBg9wKe8", opaque="3b9c806b61adf911", qop=auth, nc=00000001
Content-Type: application/sdp
Content-Length: 430

v=0
o=- 108683760 108683760 IN IP4 10.24.16.37
s=digphn
c=IN IP4 10.24.16.37
t=0 0
a=X-nat:0
m=audio 4046 RTP/AVP 0 8 9 111 18 58 118 58 96
a=rtcp:4047 IN IP4 10.24.16.37
a=rtpmap:0 PCMU/8000
a=rtpmap:8 PCMA/8000
a=rtpmap:9 G722/8000
a=rtpmap:111 G726-32/8000
a=rtpmap:18 G729/8000
a=rtpmap:58 L16/16000
a=rtpmap:118 L16/8000
a=rtpmap:58 L16-256/16000
a=sendrecv
a=rtpmap:96 telephone-event/8000
a=fmtp:96 0-15


<--- Transmitting SIP response (543 bytes) to UDP:10.24.16.37:5060 --->
SIP/2.0 401 Unauthorized
Via: SIP/2.0/UDP 10.24.16.37:5060;rport;received=10.24.16.37;branch=z9hG4bKPjCrZnx79augJPtGcTbYlXEs2slZNtwYeC
Call-ID: q.TF2SAaX3jn8dtaLTOCuIO8FRyDCsSR
From: "200" <sip:200@10.24.20.249>;tag=DTD-tYEwFMmbPyu0YWalLQdbEUGSLGN5
To: <sip:201@10.24.20.249>;tag=z9hG4bKPjCrZnx79augJPtGcTbYlXEs2slZNtwYeC
CSeq: 9776 INVITE
WWW-Authenticate: Digest realm="asterisk",nonce="1413305427/8dd1b7f56aba97da45754f7052d8a688",opaque="0b5a53ab6484480a",algorithm=md5,qop="auth"
Content-Length: 0


<--- Received SIP request (370 bytes) from UDP:10.24.16.37:5060 --->
ACK sip:201@10.24.20.249 SIP/2.0
Via: SIP/2.0/UDP 10.24.16.37:5060;rport;branch=z9hG4bKPjCrZnx79augJPtGcTbYlXEs2slZNtwYeC
Max-Forwards: 70
From: "200" <sip:200@10.24.20.249>;tag=DTD-tYEwFMmbPyu0YWalLQdbEUGSLGN5
To: <sip:201@10.24.20.249>;tag=z9hG4bKPjCrZnx79augJPtGcTbYlXEs2slZNtwYeC
Call-ID: q.TF2SAaX3jn8dtaLTOCuIO8FRyDCsSR
CSeq: 9776 ACK
Content-Length: 0

```



---


At first glance, it would appear that the incoming call was challenged for authentication, and that 200 then failed to authenticate on the second INVITE sent. The actual problem here is that the endpoint 200 does not exist within Asterisk. Whenever a SIP request arrives and Asterisk cannot match the request to a configured endpoint, Asterisk will respond to the request with a 401 Unauthorized response. The response will contain a WWW-Authenticate header to make it look as though Asterisk is requesting authentication. Since no endpoint was actually matched, the authentication challenge created by Asterisk is just dummy information and is actually impossible to authenticate against.

The reason this is done is to prevent an information leak. Consider an attacker that sends SIP INVITEs to an Asterisk box, each from a different user. If the attacker happens to send a SIP INVITE from a user name that matches an actual endpoint on the system, then Asterisk will respond to that INVITE with an authentication challenge using that endpoint's authentication credentials. But what happens if the attacker sends a SIP INVITE from a user name that does not match an endpoint on the system? If Asterisk responds differently, then Asterisk has leaked information by responding differently. If Asterisk sends a response that looks the same, though, then the attacker is unable to easily determine what user names are valid for the Asterisk system.

So if you are seeing what appears to be authentication problems, the first thing you should do is to read the Unrecognized Endpoint section above and ensure that the endpoint you think the SIP request is coming from is actually configured properly. If it turns out that the endpoint is configured properly, here are some trouble-shooting steps to ensure that authentication is working as intended:

* Ensure that username and password in the `type = auth` section are spelled correctly and that they are **using the correct case**. If you have "Alice" as the username on your phone and "alice" as the username in Asterisk, things will go poorly.
* If you are using the `md5_cred` option in an auth section, ensure the following:
	+ Ensure that you have set `auth_type = md5`.
	+ Ensure that the calculated MD5 sum is composed of *username:realm:password*
	+ Ensure that the calculated MD5 sum did not contain any extraneous whitespace, such as a newline character at the end.
	+ Ensure there were no copy-paste errors. An MD5 sum is exactly 32 hexadecimal characters. If the option in your config file contains fewer or greater than 32 characters, or if any of the characters are not hexadecimal characters, then the MD5 sum is invalid.
* Ensure that you have specified a `username`. Asterisk does not imply a username based on the name of the auth section.
* Ensure that the configured `realm` is acceptable. In most cases, simple SIP devices like phones will authenticate to whatever realm is presented to them, so you do not need to configure one explicitly. However, if a specific realm is required, be sure it is configured. Be sure that if you are using the `md5_cred` option that this realm name is used in the calculation of the MD5 sum.
* Ensure that the endpoint that is communicating with Asterisk uses the "Digest" method of authentication and the "md5" algorithm. If they use something else, then Asterisk will not understand and reject the authentication attempt.

Authentication Not Attempted
----------------------------

The opposite problem of authentication failures is that incoming calls are not being challenged for authentication where it would be expected. Asterisk chooses to challenge for authentication if the endpoint from which the request arrives has a configured `auth` option on it. From the CLI, run the `pjsip show endpoint <endpoint name>` command. Below the initial headers should be something like the following:




---

  
  


```

 Endpoint: david/6001 Unavailable 0 of inf
 InAuth: david-auth/david
 Aor: david 10
 Transport: main-transport udp 0 0 0.0.0.0:5060
 Identify: 10.24.16.36/32

```



---


Notice the "InAuth" on the second line of output. This shows that the endpoint's auth is pointing to a configuration section called "david-auth" and that the auth section has a username of "david". If you do not see an "InAuth" specified for the endpoint, then this means that Asterisk does not see that the endpoint is configured for authentication. Check the following:

* Ensure that there is an `auth`line in your endpoint's configuration.
* Ensure that the auth that your endpoint is pointing to actually exists. Spelling is important.
* Ensure that the auth that your endpoint is pointing to has `type = auth` specified in it.

Asterisk cannot find the specified extension
--------------------------------------------

If you are seeing a message like the following on your CLI when you place an incoming call:




---

  
  


```

[2014-10-14 13:22:45.886] NOTICE[1583]: res\_pjsip\_session.c:1538 new\_invite: Call from '201' (UDP:10.24.18.87:5060) to extension '456789' rejected because extension not found in context 'default'.

```



---


then it means that Asterisk was not able to direct the incoming call to an appropriate extension in the dialplan. In the case above, I dialled "456789" on the phone that corresponds with endpoint 201. Endpoint 201 is configured with `context = default` and the "default" context in my dialplan does not have an extension "456789".

The NOTICE message can be helpful in this case, since it tells what endpoint the call is from, what extension it is looking for, and in what context it is searching. Here are some helpful tips to be sure that calls are being directed where you expect:

* Be sure that the endpoint has the expected context configured. Be sure to check spelling.
* Be sure that the extension being dialled exists in the dialplan. From the Asterisk CLI, run `dialplan show <context name>` to see the extensions for a particular context. If the extension you are dialing is not listed, then Asterisk does not know about the extension.

ARGH! NAT!
----------

NAT is objectively terrible. Before having a look at this section, have a look at [this page](/Configuring-res_pjsip-to-work-through-NAT) to be sure that you understand the options available to help combat the problems NAT can cause.

NAT can adversely affect all areas of SIP calls, but we'll focus for now on how they can negatively affect the ability to allow for incoming calls to be set up. The most common issues are the following:

* Asterisk routes responses to incoming SIP requests to the wrong location.
* Asterisk gives the far end an unroutable private address to send SIP traffic to during the call.

### Asterisk sends traffic to unroutable address

The endpoint option that controls how Asterisk routes responses is `force_rport`. By default, this option is enabled and causes Asterisk to send responses to the address and port from which the request was received. This default behavior works well when Asterisk is on a different side of a NAT from the device that is calling in. Since Asterisk presumably cannot route responses to the device itself, Asterisk instead routes the response back to where it received the request from.

### Asterisk gives unroutable address to device

By default, Asterisk will place its own IP address into Contact headers when responding to SIP requests. This can be a problem if the Asterisk server is not routable from the remote device. The `local_net`, `external_signaling_address`, and `external_signaling_port` transport options can assist in preventing this. By setting these options, Asterisk can detect an address as being a "local" address and replace them with "external" addresses instead.

Outbound Calls
==============

Asterisk says my endpoint does not exist
----------------------------------------

If you see a message like the following:




---

  
  


```

[2014-10-14 15:50:50.407] ERROR[2004]: chan\_pjsip.c:1767 request: Unable to create PJSIP channel - endpoint 'hammerhead' was not found

```



---


then this means that Asterisk thinks the endpoint you are trying to dial does not exist. For troubleshooting tips about how to ensure that endpoints are loaded as expected, check the Identify by User subsection in the Incoming Calls section.

Alternatively, if you see a message like the following:




---

  
  


```

[2014-10-14 15:55:06.292] ERROR[2578][C-00000000]: netsock2.c:303 ast\_sockaddr\_resolve: getaddrinfo("hammerhead", "(null)", ...): Name or service not known
[2014-10-14 15:55:06.292] WARNING[2578][C-00000000]: chan\_sip.c:6116 create\_addr: No such host: hammerhead
[2014-10-14 15:55:06.292] DEBUG[2578][C-00000000]: chan\_sip.c:29587 sip\_request\_call: Cant create SIP call - target device not registered

```



---


or




---

  
  


```

[2014-10-14 15:55:58.440] WARNING[2700][C-00000000]: channel.c:5946 ast\_request: No channel type registered for 'SIP'
[2014-10-14 15:55:58.440] WARNING[2700][C-00000000]: app\_dial.c:2431 dial\_exec\_full: Unable to create channel of type 'SIP' (cause 66 - Channel not implemented)

```



---


then it means that your dialplan is referencing "SIP/hammerhead" instead of "PJSIP/hammerhead". Change your dialplan to refer to the correct channel driver, and don't forget to `dialplan reload` when you are finished.

Asterisk cannot route my call
-----------------------------

If Asterisk is finding your endpoint successfully, it may be that Asterisk has no address information when trying to dial the endpoint. You may see a message like the following:




---

  
  


```

[2014-10-14 15:58:06.690] WARNING[2743]: res\_pjsip/location.c:155 ast\_sip\_location\_retrieve\_contact\_from\_aor\_list: Unable to determine contacts from empty aor list
[2014-10-14 15:58:06.690] WARNING[2834][C-00000000]: app\_dial.c:2431 dial\_exec\_full: Unable to create channel of type 'PJSIP' (cause 3 - No route to destination)

```



---


If you see this, then the endpoint you are dialling either has no associated address of record (AoR) or the associated AoR does not have any contact URIs bound to it. AoRs are necessary in order to determine the appropriate destination of the call. To see if your endpoint has an associated AoR, run `pjsip show endpoint <endpoint name>` from the Asterisk CLI. The following is sample output of an endpoint that **does** have an AoR configured on it:




---

  
  


```

 Endpoint: david/6001 Unavailable 0 of inf
 InAuth: david-auth/david
 Aor: david 10
 Transport: main-transport udp 0 0 0.0.0.0:5060
 Identify: 10.24.16.36/32

```



---


Notice the third line. The endpoint points to the AoR section called "david". If your endpoint does not have an AoR associated with it, this third line will be absent.

If you think you have associated your endpoint with an AoR, but one does not appear in the CLI, then here are some troubleshooting steps:

* Ensure that you have set the `aors` option on the endpoint. Notice that the option is not `aor` (there is an 's' at the end).
* Ensure that the AoR pointed to by the `aors` option exists. Check your spelling!

If those appear to be okay, it may be that there was an error when attempting to load the AoR from configuration. From the Asterisk CLI, run the command `pjsip show aor <aor name>`. If you see a message like




---

  
  


```

Unable to find object heman.

```



---


Then it means the AoR did not get loaded properly. Here are some troubleshooting steps to ensure your AoR is configured correctly:

* Ensure that your AoR has `type = aor` set on it.
* Ensure that there were no nonexistent configuration options set. You can check the logs at Asterisk startup to see if there were any options Asterisk did not understand. For instance, you may see something like:




---

  
  


```

[2014-10-14 16:16:20.658] ERROR[2939]: config\_options.c:710 aco\_process\_var: Could not find option suitable for category '1000' named 'awesomeness' at line 219 of 
[2014-10-14 16:16:20.659] ERROR[2939]: res\_sorcery\_config.c:275 sorcery\_config\_internal\_load: Could not create an object of type 'aor' with id '1000' from configuration file 'pjsip.conf'

```



---


In this case, I tried to set an option called "awesomeness" on the AoR 1000. Since Asterisk did not recognize this option, AoR 1000 was unable to be loaded.
* The `contact` option can be a pitfall. There is an object type called "contact" that is documented on the wiki, which may make you think that the AoR option should point to the name of a contact object that you have configured. On the contrary, the `contact` option for an AoR is meant to be a SIP URI. The resulting contact object will be created by Asterisk based on the provided URI. Make sure when setting the `contact` that you use a full SIP URI and not just an IP address.

Another issue you may encounter is that you have properly configured an AoR on the endpoint but that this particular AoR has no contact URIs bound to it. From the CLI, run the `pjsip show aor <aor name>` command to see details about the AoR. Here is an example of an AoR that has a contact URI bound to it.




---

  
  


```

 Aor: 201 1
 Contact: 201/sip:201@10.24.18.87:5060;ob Unknown nan

```



---


The "Contact:" line shows the URI "sip:201@10.24.18.87:5060;ob" is bound to the AoR 201. If the AoR does not have any contacts bound to it, then no Contact lines would appear. The absence of Contact lines can be explained by any of the following:

* If the device is expected to register, then it may be that the device is either not properly configured or that there was a registration failure. See the Inbound Registrations section for details on how to resolve that problem.
* If the device is not intended to register, then the AoR needs to have a `contact` option set on it. See the previous bulleted list for possible `contact`-related pitfalls.

ARGH! NAT! (Part 2)
-------------------

NAT makes babies cry.

For outbound calls, the main NAT issue you are likely to come across is Asterisk publishing an unroutable private address in its Contact header. If this is an issue you are facing, this can be corrected by setting the `local_net`, `external_signaling_address`, and `external_signaling_port` options for the transport you are using when communicating with the endpoint. For more information on how this can be set up, please see [this page](/Configuring-res_pjsip-to-work-through-NAT).

Bridged Calls
=============

Direct media is not being used
------------------------------

Direct media is a feature that allows for media to bypass Asterisk and flow directly between two endpoints. This can save resources on the Asterisk system and allow for more simultaneous calls. The following conditions are required for direct media. If any are not met, then direct media is not possible:

* There must only be two endpoints involved in the call.
* Both endpoints involved in the call must have the `direct_media` option enabled.
* The call must be a regular person-to-person call. Calls through ConfBridge() and Meetme() cannot use direct media.
* The sets of codecs in use by each endpoint during the call must have a non-empty intersection. In other words, each endpoint must be using at least one codec that the other endpoint is using.
* Any features in Asterisk that manipulate, record, or inject media may not be used. This includes:
	+ The Monitor() and Mixmonitor() applications
	+ The Chanspy() application
	+ The JACK() application
	+ The VOLUME() function
	+ The TALK\_DETECT() function
	+ The SPEEX() function
	+ The PERIODIC\_HOOK() function
	+ The 'L' option to the Dial() application
	+ An ARI snoop
	+ A jitter buffer
	+ A FAX gateway
* No features that require that Asterisk intercept DTMF may be used. This includes the T, t, K, k, W, w, X, and x options to the Dial() application.
* If either endpoint has the `disable_direct_media_on_nat` option set, and a possible media NAT is detected, then direct media will not be used. This option is disabled by default, so you would have to explicitly set this option for this to be a problem.
* The two endpoints must be in the same bridge with each other. If the two endpoints are in separate bridges, and those two bridges are connected with one or more local channels, then direct media is not possible.

Double-check that all requirements are met. Unfortunately, Asterisk does not provide much in the way of debug for determining why it has chosen **not** to use direct media.

Inbound Registrations
=====================

For inbound registrations, a lot of the same problems that can happen on inbound calls may occur. Asterisk goes through the same endpoint identification and authentication process as for incoming calls, so if your registrations are failing for those reasons, consult the troubleshooting guide for incoming calls to determine what the problem may be.

If your problem is not solved by looking in those sections, then you may have a problem that relates directly to the act of registering. Before continuing, here is a sample REGISTER request sent to an Asterisk server:




---

  
  


```

REGISTER sip:10.24.20.249:5060 SIP/2.0
Via: SIP/2.0/UDP 10.24.16.37:5060;rport;branch=z9hG4bKPj.rPtUH-P33vMFd68cLZjQj0QQxdu6mNx
Max-Forwards: 70
From: "200" <sip:200@10.24.20.249>;tag=BXs-nct8-XOe7Q7tspK3Vl3iqUa0cmzc
To: "200" <sip:200@10.24.20.249>
Call-ID: C0yYQJ8h776wbheBiUEqCin.ZhcBB.tZ
CSeq: 5200 REGISTER
User-Agent: Digium D40 1\_4\_0\_0\_57389
Contact: "200" <sip:200@10.24.16.37:5060;ob>
Expires: 300
Allow: PRACK, INVITE, ACK, BYE, CANCEL, UPDATE, SUBSCRIBE, NOTIFY, REFER, MESSAGE, OPTIONS
Content-Length: 0

```



---


This REGISTER was sent by the endpoint 200. The URI in the To header is "sip:200@10.24.20.249". Asterisk extracts the username portion of this URI to determine the address of record (AoR) that the REGISTER pertains to. In this case, the AoR has the same name as the endpoint, 200. The URI in the Contact header is "sip:200@10.24.16.37:5060;ob". The REGISTER request is attempting to bind this contact URI to the AoR. Ultimately, what this means is that when someone requests to reach endpoint 200, Asterisk will check the AoRs associated with the endpoint, and send requests to all contact URIs that have been bound to the AoR. In other words, the REGISTER gives Asterisk the means to locate the endpoint.

You can ensure that your configuration is sane by running the the `pjsip show endpoint <endpoint name>` CLI command. Part of the output is to show all AoRs associated with a particular endpoint, as well as contact URIs that have been bound to those AoRs. Here is sample output from running `pjsip show endpoint 200` on a system where registration has succeeded:




---

  
  


```

 Endpoint: 200/200 Not in use 0 of inf
 Aor: 200 1
 Contact: 200/sip:200@10.24.16.37:5060;ob Unknown nan
 Transport: main-transport udp 0 0 0.0.0.0:5060

```



---


This shows that endpoint 200 has AoR 200 associated with it. And you can also see that the contact "sip:200@10.24.16.37:5060;ob" has been bound to the AoR.

If running this command shows no AoR, then ensure that the endpoint has the `aors` option set. Note that the name is `aors`, not `aor`.

More likely, the issue will be that an AoR will be listed, but there will be no associated contact. If this is the case, here are some possible troubleshooting steps:

* Ensure that the AoR has actually been loaded. Run the CLI command `pjsip show aor <aor name>`. If no AoR is displayed, then that means the AoR was not loaded.
	+ Ensure that the configuration section has `type = aor` specified.
	+ Ensure that all configuration options specified on the AoR are options that Asterisk recognizes.
* Ensure that the `res_pjsip_registrar.so` module is loaded and running. Running `module show like res_pjsip_registrar.so` should show the following:




---

  
  


```

Module Description Use Count Status Support Level
res\_pjsip\_registrar.so PJSIP Registrar Support 0 Running core

```



---
* Ensure that the AoR has a `max_contacts` value configured on it. If this option is not set, then registration cannot succeed. You will see this message on the CLI:




---

  
  


```

[2014-10-16 11:34:07.887] WARNING[2940]: res\_pjsip\_registrar.c:685 registrar\_on\_rx\_request: AOR '200' has no configured max\_contacts. Endpoint '200' unable to register

```



---


Asterisk will transmit a 403 Forbidden in response to the registration attempt.

If you initially have successful registrations but they later start failing, then here are some further troubleshooting steps for you to try:

* If you intend for new registrations to replace old ones, then enable the `remove_existing` option for the AoR.
* Ensure that if you are attempting to bind multiple contacts to an AoR that the `max_contacts` for the AoR is large enough. If the `max_contacts` value is not high enough, you will see the following CLI message:




---

  
  


```

[2014-10-16 11:34:07.887] WARNING[2940]: res\_pjsip\_registrar.c:411 rx\_task: Registration attempt from endpoint '200' to AOR '200' will exceed max contacts of 1

```



---


Asterisk will respond to the registration attempt with a 403 Forbidden.

Outbound Registrations
======================

If you are having troubles with outbound registrations and unfamiliar with the mechanics involved, please see [this page](/Configuring-Outbound-Registrations). It will explain quite a few of the concepts that Asterisk uses and may give you some clues for solving your issue.

If you are still having trouble, here are some troubleshooting steps:

* If Asterisk is not sending an outbound REGISTER at all, then it is likely that there was an error when trying to load the outbound registration.
	+ Ensure that the outbound registration has `type = registration` in it.
	+ Ensure that there are no configuration options that Asterisk does not recognize.
* Another reason Asterisk may not be sending an outbound REGISTER is that you do not have a valid SIP URI for your `server_uri` or `client_uri`. You may see a message like this on the CLI if this is the case:




---

  
  


```

[2014-10-16 12:05:16.064] ERROR[3187]: res\_pjsip\_outbound\_registration.c:724 sip\_outbound\_registration\_regc\_alloc: Invalid server URI 'registrar@example.com' specified on outbound registration 'outreg'

```



---


In this case, I left off the initial "sip:" from the URI.
* If your outbound REGISTER receives no response, then you may have misconfigured the `server_uri` to point somewhere the REGISTER is not meant to be sent.
* If Asterisk has stopped sending REGISTER requests, then either the maximum number of retries has been attempted or the response that Asterisk received from the registrar was considered to be a permanent failure. If you want to get Asterisk to start sending REGISTER requests again after making configuration adjustments, you can do so by running the `module reload res_pjsip_registrar.so` CLI command.

Inbound Subscriptions
=====================

The first thing to acknowledge with inbound subscriptions is that the handling of the inbound SUBSCRIBE messages starts the same as for inbound calls. This means that if you are having troubles where Asterisk does not recognize the endpoint sending the SUBSCRIBE or if authentication is failing, you should check the troubleshooting guide for incoming calls for details on how to solve these issues.

It is also important to ensure that `res_pjsip_pubsub.so` is loaded and running. This module is the core of all of Asterisk's handling of subscriptions, and if it is not loaded, then Asterisk will not be able to set up subscriptions properly.

Presence/Dialog Info
--------------------

A tutorial about subscribing to presence and dialog-info can be found on [this page](/Configuring-res_pjsip-for-Presence-Subscriptions). Reading that page may point you towards how to resolve the issue you are facing.

If you are attempting to subscribe to the presence or dialog event packages, then here are some troubleshooting steps for determining what is going wrong.

* Ensure that the `res_pjsip_exten_state.so` module is loaded.
* Ensure that the Event header in inbound subscribe messages are one of "presence" or "dialog".
* Ensure all necessary modules are loaded, depending on what values are in the Accept header of inbound SUBSCRIBE requests.
* When subscribing, you may see a message like the following on the CLI:




---

  
  


```

[2014-10-16 12:56:58.605] WARNING[3780]: res\_pjsip\_exten\_state.c:337 new\_subscribe: Extension blah does not exist or has no associated hint

```



---


The warning message is self-explanatory. If you think you have placed extension "blah" in your `extensions.conf` file and it contains a hint, then be sure that it exists in the same context as the `context` option on the endpoint that is attempting to subscribe. Also be sure that if you have recently changed your `extensions.conf` file that you have saved the changes and run the `dialplan reload` CLI command.

MWI
---

If you are attempting to subscribe to the message-summary package, then here are some troubleshooting steps for determining what is going wrong.

* Ensure that the `res_pjsip_mwi.so` and the `res_pjsip_mwi_body_generator.so` modules are loaded.
* Ensure that the AoR that the MWI SUBSCRIBE is being sent to has `mailboxes` configured on it. Note that the option name is `mailboxes` and not `mailbox`.
* When subscribing to MWI, you may see a message like the following:




---

  
  


```

[2014-10-16 13:06:51.323] NOTICE[3963]: res\_pjsip\_mwi.c:566 mwi\_validate\_for\_aor: Endpoint '200' already configured for unsolicited MWI for mailbox '200'. Denying MWI subscription to 200

```



---


The most likely cause of something like this is that you have an endpoint and an AoR that both have `mailboxes = 200` in your configuration. The endpoint with `mailboxes = 200` attempts to subscribe to the AoR that has `mailboxes = 200`. In this case, since Asterisk is already sending MWI notifications about mailbox 200 to the endpoint, the subscription to the AoR is denied. To fix this, remove the `mailboxes` option from your endpoint, or configure your device not to attempt to subscribe to MWI.
* Asterisk has multiple ways of having MWI state set, but the most common way is to use `app_voicemail` that comes with Asterisk. `app_voicemail` has a requirement that mailbox names must follow the format "mailbox@context". If you are using `app_voicemail` and you configure MWI in `pjsip.conf` and only provide the mailbox name without a context, then you will not receive MWI updates when the state of the mailbox changes.

Configuration Issues
====================

Can't create an IPv6 transport
------------------------------

You've configured a transport in pjsip.conf to bind to an IPv6 address or block. However, Asterisk fails to create the transport when loading!

If you look into your logs you might messages similar to the following:




---

  
  


```

[Dec 12 00:58:31] ERROR[10157] config\_options.c: Error parsing bind=:: at line 8 of 
[Dec 12 00:58:31] ERROR[10157] res\_sorcery\_config.c: Could not create an object of type 'transport' with id 'my-ipv6-transport' from configuration file 'pjsip.conf'

```



---


The most likely issue is that you have not compiled **pjproject** with support for IPv6. You can find instructions at [PJSIP-pjproject](/PJSIP-pjproject).

