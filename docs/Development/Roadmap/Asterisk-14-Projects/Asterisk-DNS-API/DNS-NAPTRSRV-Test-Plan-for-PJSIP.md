---
title: DNS NAPTR/SRV Test Plan for PJSIP
pageid: 32375195
---

WORK IN PROGRESS

 

At this stage in development, a resolver has been implemented, and backend support for NAPTR and SRV have been added. However, there are no users of NAPTR or (the new) SRV in Asterisk. The first user of them will be res\_pjsip.so. In writing tests for res\_pjsip, RFC 3263 will be the model for how SIP servers are to be located.

For all of the following tests, we're assuming a scenario where the Asterisk testsuite is being used. Because of this, Asterisk and whatever remote endpoint is being looked up will reside on the same machine. Some of the processes in RFC 3263 require using port 5060 and 5061 as default ports for outbound lookups, so all of these tests should have SIP run on non-standard ports to avoid Asterisk sending requests to itself.

SRV Tests
=========

### Priority

Goal: To ensure that when multiple SRV records are returned, that records with the greatest priority (meaning smallest number) are chosen before others.

Procedure:

* Set `_sip._udp.test.internal` to have the following records

;; Priority Weight Port Target
IN SRV 0 1 5060 main.test.internal.
IN SRV 1 1 5060 backup.test.internal.
* Disable NAPTR lookups for this test. Only allow UDP transport to be used.
* Place an outbound SIP request to `sip:test.internal`.
* Ensure that an SRV lookup of `_sip._udp.test.internal` is performed.
* Ensure that this results in an A and/or AAAA lookup of `main.test.internal`.

It is unknown whether the DNS engine in Asterisk will try to optimize by performing simultaneous lookups of both `main.test.internal` and `backup.test.internal` instead of going sequentially. If the domains are looked up in parallel, then this test cannot determine if the correct priority is being honored simply by monitoring A/AAAA record lookups. The test would have to be expanded in the following way:

Add distinct A records for both `main.test.internal` and `backup.test.internal`. Ensure that the outgoing SIP request ends up being sent to the IP address retrieved from the A record lookup of `main.test.internal` and not the IP address retrieved by an A record lookup of `backup.test.internal`

### Failover order

Goal: To ensure that when returned SRV results fail, that the expected order for failing over is respected.

Procedure:

* Set up the following DNS records

fast.test.internal IN A 127.0.0.1
slow.test.internal IN A 127.0.0.1
 
;; Priority Weight Port Target
\_sip.\_udp.test.internal IN SRV 0 3 5061 fast.test.internal.
 IN SRV 0 1 5062 slow.test.internal.
 IN SRV 1 100 5063 backup.test.internal.
* Set up two SIPp scenarios
	+ `fast.xml` runs at 127.0.0.1, port 5060. It expects an incoming INVITE and responds to the INVITE with a 503 response
	+ `slow.xml` runs at 127.0.0.1, port 5061. It expects an incoming INVITE and does not respond to it
* In Asterisk, disable NAPTR lookups. Enable only UDP as a transport.
* Place an outbound call to `sip:test.internal`.
* Ensure that an SRV lookup of `_sip._udp.test.internal` is performed.
* Ensure that this results in an A lookup of either `fast.test.internal` or `slow.test.internal`. Since SRV weighting has a random factor to it, it is impossible to guarantee which of the two will be chosen first.
* Ensure a SIP INVITE is sent to the chosen target
* Ensure that upon failure of the call to the chosen target, that the remaining of fast or slow is chosen as the next target.
* Ensure a SIP INVITE is sent to the new target. Ensure that the Via header (particularly the branch) is different from the previous outbound INVITE.
* Ensure that upon failure of the second call, that backup is chosen as the next target.
* When the A lookup of `backup.test.internal` returns NXDOMAIN, the test should conclude and not attempt any further lookups.

RFC 3263 section 4.2 states:

"If no SRV records were found, the client performs an A or AAAA record lookup of the domain name."

My interpretation of this is that since we did find SRV records, we should not fail over to A/AAAA record lookups of `test.internal`. However, this may be an overly strict interpretation.

### Failover to A/AAAA

Goal: Ensure that when SRV records are unavailable, that failover to A/AAAA is performed

Procedure:

* Set up the following DNS record:

test.internal IN A 127.0.0.1
* Disable NAPTR lookups for this test. Only enable UDP as the transport.
* Place an outbound call to `sip:test.internal`
* Ensure that an SRV lookup of `_sip._udp.test.internal` is attempted.
* Since there are no SRV records returned, ensure that the call fails over to an A/AAAA record lookup of `test.internal`

NAPTR Tests
===========

NAPTR tests provided here are designed around the context of how SIP should be handling NAPTR lookups and their results.

The following NAPTR tests may have a flaw in them. From RFC 3263 section 4.1:

'If a SIP proxy, redirect server, or registrar is to be contacted through the lookup of NAPTR records, there MUST be at least three records - one with a "SIP+D2T" service field, one with a "SIP+D2U" service field, and one with a "SIPS+D2T" service field.'

Many of the NAPTR tests below do NOT have three records. The problems I have with this snippet are:

* It is not clear who this "MUST" language is directed to. Is this directed at nameservers that serve the NAPTR records, or is this aimed at SIP clients that look up the NAPTR records? My interpretation is that this restriction applies to those who are populating the DNS servers. We take the approach that as a SIP client, if not all three records exist, then we do not automatically consider the NAPTR lookup to have failed, and we will work with what we've been given.
* How are we supposed to know whether the entity we are contacting is a proxy, redirect server, or registrar? When sending a REGISTER, we might infer that we are contacting a registrar. For other types of requests, we have no idea what type of SIP entity we will be contacting. This reinforces my belief that this statement is directed towards the people that add the NAPTR records to DNS and that clients should be prepared to handle whatever SIP NAPTR records it gets from a lookup.

So as far as these tests are concerned, since they involve placing outbound calls to simulated phones, we're technically not in violation by not providing the required three NAPTR records. But even if the tests were testing outbound registrations, the client behavior described in these tests would be the same, even if the required NAPTR records are not present in the lookup.

Nominal Tests
-------------

### Correct Order

Goal: Ensure that when multiple NAPTR records are returned, that the record with the lowest order is used.

Procedure:

* Set up the following DNS records for `test.internal`:

; order pref flags service regexp replacement
IN NAPTR 50 50 "s" "SIP+D2T" "" \_sip.\_tcp.test.internal.
IN NAPTR 90 40 "s" "SIP+D2U" "" \_sip.\_udp.test.internal.
* Enable NAPTR lookups for outbound SIP calls. Allow both UDP and TCP transports to be used for the outgoing call.
* Place an outbound SIP call to `sip:test.internal`.
* Ensure that a NAPTR lookup of `test.internal` occurs
* Ensure that the NAPTR lookup results in an SRV lookup of `_sip._tcp.test.internal`

### Correct Preference

Goal: Ensure that when multiple NAPTR records with the same order are returned, that the one with the lowest preference is chosen first

Procedure:

* Set up the following DNS records for `test.internal`:

; order pref flags service regexp replacement
IN NAPTR 50 50 "s" "SIP+D2T" "" \_sip.\_tcp.test.internal.
IN NAPTR 50 90 "s" "SIP+D2U" "" \_sip.\_udp.test.internal.
* Enable NAPTR lookups for outbound SIP calls. Allow both UDP and TCP transports to be used for the outgoing call.
* Place an outbound SIP call to `sip:test.internal`
* Ensure that a NAPTR lookup of `test.internal` occurs
* Ensure that an SRV lookup occurs for `_sip._tcp.test.internal`

It is unknown whether the DNS engine in Asterisk will try to optimize by performing simultaneous SRV lookups of both `_sip._tcp.test.internal` and `_sip._udp.test.internal` instead of going sequentially. If the domains are looked up in parallel, then this test cannot determine if the correct preference is being honored simply by monitoring SRV record lookups. The test would have to be expanded in the following way:

Add distinct SRV records for `_sip._tcp.test.internal` and `_sip._udp.test.internal`. Each of the domains pointed to by those SRV records should be distinct A records. Ensure that the outgoing SIP request ends up being sent to the IP address retrieved from the A record lookup of the domain pointed to by the `_sip._tcp.test.internal` SRV record.

### Restricted Transport

Goal: Ensure that an appropriate NAPTR record is chosen based on the configured transports.

Procedure:

* Set up the following DNS records for `test.internal`:

; order pref flags service regexp replacement
IN NAPTR 50 50 "s" "SIP+D2T" "" \_sip.\_tcp.test.internal.
IN NAPTR 60 50 "s" "SIP+D2U" "" \_sip.\_udp.test.internal.
* Enable NAPTR lookups for outbound SIP calls. Only allow UDP to be used for the outgoing call.
* Place an outbound call to `sip:test.internal`
* Ensure that a NAPTR lookup of `test.internal` occurs
* Ensure that the NAPTR lookup results in an SRV for `_sip._udp.test.internal` and no SRV lookup occurs for `_sip._tcp.test.internal`

### Failover of preferences

Goal: Ensure that failover occurs between NAPTR records of the same order

Procedure:

* Set up the following DNS records for `test.internal`:

test.internal IN NAPTR 50 50 "s" "SIP+D2T" "" \_sip.\_tcp.test.internal.
 IN NAPTR 50 60 "s" "SIP+D2U" "" \_sip.\_udp.test.internal.
 
\_sip.\_udp.test.internal IN SRV 1 1 5060 sip.test.internal
* Enable NAPTR lookups for outbound SIP calls. Allow both UDP and TCP to be used for the outgoing call.
* Place an outbound call to `sip:test.internal`
* Ensure that a NAPTR lookup of `test.internal` occurs.
* Ensure that the NAPTR lookup results in an SRV lookup for `_sip._tcp.test.internal`.
* Ensure that the SRV lookup fails.
* Ensure that an SRV lookup then occurs for `_sip._udp.test.internal`

Off-nominal tests
-----------------

Off-nominal tests are designed to detect NAPTR records that are correct by the core definition of NAPTR but erroneous in the context of SIP.

### No NAPTR

Goal: To ensure that if no NAPTR records are configured on the DNS server that we fail over to SRV lookups instead.

* Set up no NAPTR records for `test.internal`
* Enable NAPTR lookups for outbound SIP calls. Enable TCP, UDP, and TLS transports to be used.
* Place an outbound call to `sip:test.internal`
* Ensure that a NAPTR lookup is performed for `test.internal`
* Ensure that lookups for `_sips._tcp.test.internal`, `_sip.tcp.test.internal`, and `_sip._udp.test.internal` are performed.

### No SIP services

This test is based on an interpretation of RFC 3263 section 4.1:

"If no NAPTR records are found, the client constructs SRV queries for those transport protocols it supports, and does a query for each."

My interpretation of "no NAPTR records are found" can mean either that there are no NAPTR records at all OR that there are NAPTR records but not for SIP services.

Goal: To ensure that if a NAPTR lookup gives no recognized SIP services, that we fail over to an SRV lookup instead.

Procedure:

* Set up the following DNS records for `test.internal` (taken from RFC 3403):

;; order pref flags service regexp replacement
IN NAPTR 100 50 "a" "z3950+N2L+N2C" "" cidserver.test.internal.
IN NAPTR 100 50 "a" "rcds+N2C" "" cidserver.test.internal.
IN NAPTR 100 50 "s" "http+N2L+N2C+N2R" "" www.test.internal.
* Enable NAPTR lookups for outbound SIP calls. Enable TCP, UDP, and TLS transports to be used.
* Place an outbound call to `sip:test.internal`
* Ensure that none of the returned NAPTR records are used for further lookups.
* Ensure that SRV lookups are performed for `_sip._tcp.test.internal`, `_sips._tcp.test.internal`, and `_sip._udp.test.internal`.

### No Compatible SIP services

Goal: To ensure that if SIP NAPTR records are returned for incompatible services, that we fail over to an SRV lookup instead.

Procedure:

* Set up the following DNS records for `test.internal`:

; order pref flags service regexp replacement
IN NAPTR 50 50 "s" "SIPS+D2T" "" \_sips.\_tcp.test.internal.
IN NAPTR 60 50 "s" "SIP+D2T" "" \_sip.\_tcp.test.internal.
* Enable NAPTR lookups for outbound SIP calls. Enable only UDP transport to be used.
* Place an outbound call to `sip:test.internal`
* Ensure that none of the returned NAPTR records are used for further lookups.
* Ensure that an SRV lookup is performed for `_sip._udp.test.internal`

### Non-"S" flag in SIP record

This test is based around the following text in RFC 3263 section 4.1:

"These NAPTR records provide a mapping from a domain to the SRV record for contacting a server with the specific transport protocol in the NAPTR services field"

My interpretation of this is that NAPTR records for SIP services MUST have the "s" flag set, and any records with other flags set are not compatible with RFC 3263

Goal: To ensure that only NAPTR records which indicate SRV lookups are considered.

Procedure:

* Set up the following DNS records for `test.internal`:

; order pref flags service regexp replacement
IN NAPTR 50 50 "a" "SIP+D2T" "" sip.tcp.test.internal.
IN NAPTR 60 50 "s" "SIP+D2T" "" \_sip.\_tcp.test.internal.
* Enable NAPTR lookups for outbound SIP calls. Enable UDP, TCP, and TLS transports to be used.
* Place an outbound call to `sip:test.internal`
* Ensure that an SRV lookup is performed for `_sip._tcp.test.internal`, and no A or AAAA lookup is performed for `sip.tcp.test.internal`.

### Regexp in SIP record

This test is based around the following text from RFC 3263 section 4.1:

"The resource record will contain an empty regular expression and a replacement value, which is the SRV record for that particular transport protocol"

My interpretation is that NAPTR records for SIP services MUST NOT have regular expressions in them. Records that have regular expressions are ignored.

Goal: Ensure that only NAPTR records without regular expressions are processed

Procedure:

* Set up the following DNS records for `test.internal`:

; order pref flags service regexp replacement
IN NAPTR 50 50 "s" "SIP+D2T" "!.\*!\_sip.\_tcp.test.internal!" .
IN NAPTR 60 50 "s" "SIP+D2U" "" \_sip.\_udp.test.internal.
* Enable NAPTR lookups for outbound SIP calls. Enable UDP, TCP, and TLS transports to be used.
* Place an outbound call to `sip:test.internal`
* Ensure that an SRV lookup is performed for `_sip._udp.test.internal`, and no other SRV lookups are performed.

### No Failover of Order

Goal: Ensure that no processing of NAPTR records occurs for higher order values than the first record processed (grammar ftw).

Procedure:

* Set up the following DNS records:

test.internal IN NAPTR 50 50 "s" "SIP+D2T" "" \_sip.\_tcp.test.internal.
 IN NAPTR 60 50 "s" "SIP+D2U" "" \_sip.\_udp.test.internal.
 
\_sip.\_udp.test.internal IN SRV 1 1 5060 sip.test.internalNote that there is no SRV record for `_sip._tcp.test.internal`
* Enable NAPTR lookups for outbound SIP calls. Enable UDP and TCP transports to be used.
* Place an outbound call to `sip:test.internal`
* Ensure that an SRV lookup is performed for `_sip._tcp.test.internal`.
* When the SRV lookup fails, ensure that no other SRV lookups are attempted.

 

Other RFC 3263-related Tests
============================

The majority of these tests rely on using the proper lookup method based on the construction of the URI.

### SIP URI Extravaganza

This is a mega-test that will require many sub-tests. The following DNS entries will be needed for the test:

; NAPTR records
test.internal IN NAPTR 50 50 "s" "SIPS+D2T" "" \_sips.\_tcp.test.internal.
 IN NAPTR 60 50 "s" "SIP+D2T" "" \_sip.\_tcp.test.internal.
 IN NAPTR 90 50 "s" "SIP+D2U" "" \_sip.\_udp.test.internal.
 
; SRV records
\_sips.\_tcp.test.internal IN SRV 0 100 5061 tls.test.internal.
\_sip.\_tcp.test.internal IN SRV 0 100 5060 tcp.test.internal.
\_sip.\_udp.test.internal IN SRV 0 100 5060 udp.test.internal.
 
; A/AAAA records
tls.test.internal IN A 127.0.0.1
 IN AAAA ::1
 
tcp.test.internal IN A 127.0.0.1
 IN AAAA ::1
 
udp.test.internal IN A 127.0.0.1
 IN AAAA ::1 

The parts of a SIP URI can be used to determine what transport should be used and/or what type of lookup should be used. Consult the following table



|  | Numeric host | Numeric host with port | Non-numeric host | Non-numeric host with port |
| --- | --- | --- | --- | --- |
| ;transport=tls | Transport: TLSLookup: nonePort: 5061 | Transport: TLSLookup: nonePort: As specified | Transport: TLSLookup: SRV `_sips._tcp.<domain>`Port: Determined by lookup | Transport: TLSLookup: A/AAAAPort: As specified |
| ;transport=tcp | Transport: TCPLookup: nonePort: 5060 | Transport: TCPLookup: nonePort: As specified | Transport: TCPLookup: SRV `_sip._tcp.<domain>`Port: Determined by lookup | Transport: TCPLookup: A/AAAAPort: As specified |
| ;transport=udp | Transport: UDPLookup: nonePort: 5060 | Transport: UDPLookup: nonePort: As specified | Transport: UDPLookup: SRV `_sip._udp.<domain>`Port: Determined by lookup | Transport: UDPLookup: A/AAAAPort: As specified |
| No transport | Transport: UDPLookup: nonePort: 5060 | Transport: UDPLookup: nonePort: As specified | Transport: Determined by lookupLookup: NAPTRPort: Determined by lookup | Transport: UDPLookup: A/AAAAPort: As specified |
| SIPS URI | Transport: TLSLookup: nonePort: 5061 | Transport: TLSLookup: nonePort: As specified | Transport: TLSLookup: NAPTRPort: Determined by lookup | Transport: TLSLookup: A/AAAAPort: As specified |

 

Goal: Ensure that SIP URIs of different construction result in proper lookups being carried out.

Procedure:

* Construct 20 SIP URIs such that each satisfies a unique row/column combination in the above table. The domain used for all URIs should be `test.internal`. If the column says to include a port, use 5060 as the explicit port unless the transport is TLS. If the transport in the cell is TLS, then use port 5061.
* For each URI:
	+ Place an outbound call to that URI
	+ Ensure that if a lookup should be done that the correct one is performed. If no lookup is required, ensure none is performed.
	+ Ensure that the outbound SIP request is sent to the proper place as dictated by the table. The proper destination may require several DNS lookups to determine.

### SIP URI with username

Goal: Ensure that the username portion of a SIP username is not included in any NAPTR or SRV lookups.

Procedure:

* Place a call to `sip:alice@test.internal`
* Ensure that this results in a NAPTR lookup of `test.internal` and not a NAPTR lookup of `alice@test.internal`

### SIP URI with maddr

Goal: Ensure that the maddr URI parameter is used instead of the URI host if present

Procedure:

* Place a call to `sip:test.internal;maddr=mtest.internal`
* Ensure that a NAPTR lookup of `mtest.internal` is performed and not a NAPTR lookup of `test.internal`

### SIP A/AAAA failover

Goal: Ensure that when multiple A or AAAA records are returned, failover between records occurs.

Procedure:

* Set up the following records for `test.internal`

main.test.internal IN A 127.0.0.1
 IN AAAA ::1
 
;; Priority Weight Port Target
\_sip.\_udp.test.internal IN SRV 0 100 5060 main.test.internal.
 IN SRV 1 100 5060 backup.test.internal.
 
test.internal IN NAPTR 0 0 "s" "SIP+D2U" "" \_sip.\_udp.test.internal
* Place a call to `sip:test.internal`
* Ensure that a NAPTR lookup is performed for `test.internal`
* Ensure that an SRV lookup is performed for `_sip._udp.test.internal`
* Ensure that an A and AAAA lookup is performed for `main.test.internal`. It is unknown which of the two records for `main.test.internal` will be returned first. However, since neither actually has anything running on them, either should work fine.
* Ensure that when the SIP request to the first returned record from `main.test.internal` fails (due to transaction timeout due to no response), that the second record from `main.test.internal` is attempted before performing any lookup on `backup.test.internal`

### Response Via header extravaganza



|  | Numeric sent-by | Non-numeric sent-by |
| --- | --- | --- |
| Port present | Lookup: NonePort: As specified | Lookup: A/AAAAPort: As specified |
| Port not present | Lookup: NonePort: Default (5060 for UDP and TCP, 5061 for TLS) | Lookup: SRV\*Port: Determined by lookup |

\* The SRV lookups are as follows:

* UDP: `_sip._udp.<domain>`
* TCP: `_sip._tcp.<domain>`
* TLS: `_sips._tcp.<domain>`

Goal: Ensure that SIP responses are sent to the correct location given different types of Via headers

Procedure:

* Set up a series of SIPp scenarios that will send an INVITE and then immediately end. Each scenario should use a Via that satisfies one of the cells in the above table. There should be scenarios for UDP, TCP, and TLS, meaning there should be a total of 12 scenarios. For scenarios that use a non-numeric sent-by, use `test.internal`. For tests that require a port to be present in the sent-by, use 5060 for UDP and TCP, and use 5061 for TLS.
* Run each scenario. Ensure that Asterisk initially attempts to use the appropriate destination for the response
	+ For UDP, this will be the sender's source address
	+ For TCP/TLS, this will use the connection that the incoming request arrived on.
* Ensure that the initial attempt to send the response fails.
* Ensure that after the failure, the appropriate lookup is performed, and that the response is tried again using the data retrieved from the lookup.

 

