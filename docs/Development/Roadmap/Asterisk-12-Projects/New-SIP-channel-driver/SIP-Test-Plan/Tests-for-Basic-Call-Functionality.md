---
title: Tests for Basic Call Functionality
pageid: 22088169
---

This page outlines some basic call tests for the new SIP work in Asterisk.

Configuration for Tests
=======================

The configuration for these tests will all be made from a basic template. Some tests will require configuration to be added to the template. This will be specified in the test if necessary.




---

  
res_sip.conf  


```

[local-transport-template](!)
type=transport

[local-transport](local-transport-template)
; Place test-specific transport options here

[endpoint-template](!)
type=endpoint
context=default
transport=local-transport
allow=!all,ulaw,alaw

; alice is the caller
[alice](endpoint-template)
; Place alice-specific options here

; bob is the recipient of outbound calls
[bob](endpoint-template)
host=127.0.0.1:5062
; Place bob-specific options here

[auth-template](!)
type=auth

[alice-auth](auth-template)
username=alice
; Place alice-specific auth options here

[bob-auth](auth-template)
username=bob
; Place bob-specific auth options here
; Note: in the first iteration of tests on
; this page, there will never be any bob-specific
; auth options because we do not respond properly
; to auth challenges.


```




---

  
extensions.conf  


```

exten => echo,1,Answer()
same => n,Echo()
same => n,Hangup()

exten => playback,1,Answer()
same => n,Playback(hello-world)
same => n,Hangup()

exten => early,1,Progress()
same => n,Playback(hello-world,noanswer)
same => n,Hangup(INTERWORKING)

;This dialstring can be altered once endpoints can be used directly
exten => bob,1,Dial(PJSIP/sip:bob@127.0.0.1:5062,10)
same => n,Hangup()

exten => bobv6,1,Dial(PJSIP/sip:bob@[::1]:5062,10)
same => n,Hangup()



```


Incoming Call tests
===================

Incoming call tests involve a call placed from endpoint "alice" to Asterisk.

### Nominal path

All Nominal path tests will be run multiple times. Each iteration of the test is detailed in the table below.



| Iteration | Transport-specific Data | Alice-specific Data | Alice-auth-specific data | modules.conf additions | INVITE details | Comment | Written? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | bind=127.0.0.1:5060 | none | none | none | SDP in INVITE | Identify by username, no auth | Yes |
| 2 | bind=127.0.0.1:5060 | auth = alice-auth | password = swordfish | none | SDP in INVITE | Identify by username, userpass auth | Yes |
| 3 | bind=127.0.0.1:5060 | auth = alice-auth | auth_type=md5 | none | SDP in INVITE | Identify by username, md5 auth | Yes |
| 4 | bind=127.0.0.1:5060protocol=udp | host = 127.0.0.1:5061 | none | noload => res_sip_endpoint_identifier_user.so | SDP in INVITE | Identify by host, no auth | Yes |
| 5 | bind=127.0.0.1:5060protocol=udp | host = 127.0.0.1:5061auth = alice-auth | password = swordfish | noload => res_sip_endpoint_identifier_user.so | SDP in INVITE | Identify by host, userpass auth | Yes |
| 6 | bind=127.0.0.1:5060protocol=udp | host = 127.0.0.1:5061auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | noload => res_sip_endpoint_identifier_user.so | SDP in INVITE | Identify by host, md5 auth | Yes |
| 7 | bind=127.0.0.1:5060protocol=tcp | none | none | none | SDP in INVITE | Identify by username, no auth (TCP) | Yes |
| 8 | bind=127.0.0.1:5060protocol=tcp | auth = alice-auth | password = swordfish | none | SDP in INVITE | Identify by username, userpass auth (TCP) | Yes |
| 9 | bind=127.0.0.1:5060protocol=tcp | auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | none | SDP in INVITE | Identify by username, md5 auth (TCP) | Yes |
| 10 | bind=127.0.0.1:5060protocol=tcp | host = 127.0.0.1:5061 | none | noload => res_sip_endpoint_identifier_user.so | SDP in INVITE | Identify by host, no auth (TCP) |
| 11 | bind=127.0.0.1:5060protocol=tcp | host = 127.0.0.1:5061auth = alice-auth | password = swordfish | noload => res_sip_endpoint_identifier_user.so | SDP in INVITE | Identify by host, userpass auth (TCP) |
| 12 | bind=127.0.0.1:5060protocol=tcp | host = 127.0.0.1:5061auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | noload => res_sip_endpoint_identifier_user.so | SDP in INVITE | Identify by host, md5 auth (TCP) |
| 13 | bind=127.0.0.1:5060protocol=udp | none | none | none | No SDP in INVITE | Identify by username, no auth | Yes |
| 14 | bind=127.0.0.1:5060protocol=udp | auth = alice-auth | password = swordfish | none | No SDP in INVITE | Identify by username, userpass auth | Yes |
| 15 | bind=127.0.0.1:5060protocol=udp | auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | none | No SDP in INVITE | Identify by username, md5 auth | Yes |
| 16 | bind=127.0.0.1:5060protocol=udp | host = 127.0.0.1:5061 | none | noload => res_sip_endpoint_identifier_user.so | No SDP in INVITE | Identify by host, no auth | Yes |
| 17 | bind=127.0.0.1:5060protocol=udp | host = 127.0.0.1:5061auth = alice-auth | password = swordfish | noload => res_sip_endpoint_identifier_user.so | No SDP in INVITE | Identify by host, userpass auth | Yes |
| 18 | bind=127.0.0.1:5060protocol=udp | host = 127.0.0.1:5061auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | noload => res_sip_endpoint_identifier_user.so | No SDP in INVITE | Identify by host, md5 auth | Yes |
| 19 | bind=127.0.0.1:5060protocol=tcp | none | none | none | No SDP in INVITE | Identify by username, no auth (TCP) | Yes |
| 20 | bind=127.0.0.1:5060protocol=tcp | auth = alice-auth | password = swordfish | none | No SDP in INVITE | Identify by username, userpass auth (TCP) | Yes |
| 21 | bind=127.0.0.1:5060protocol=tcp | auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | none | No SDP in INVITE | Identify by username, md5 auth (TCP) | Yes |
| 22 | bind=127.0.0.1:5060protocol=tcp | host = 127.0.0.1:5061 | none | noload => res_sip_endpoint_identifier_user.so | No SDP in INVITE | Identify by host, no auth (TCP) |
| 23 | bind=127.0.0.1:5060protocol=tcp | host = 127.0.0.1:5061auth = alice-auth | password = swordfish | noload => res_sip_endpoint_identifier_user.so | No SDP in INVITE | Identify by host, userpass auth (TCP) |
| 24 | bind=127.0.0.1:5060protocol=tcp | host = 127.0.0.1:5061auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | noload => res_sip_endpoint_identifier_user.so | No SDP in INVITE | Identify by host, md5 auth (TCP) |
| 25 | bind=[::1]:5060protocol=udp | none | none | none | SDP in INVITE | Identify by username, no auth (IPv6) |
| 26 | bind=[::1]:5060protocol=udp | auth = alice-auth | password = swordfish | none | SDP in INVITE | Identify by username, userpass auth (IPv6) |
| 27 | bind=[::1]:5060protocol=udp | auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | none | SDP in INVITE | Identify by username, md5 auth (IPv6) |
| 28 | bind=[::1]:5060protocol=udp | host = [::1]:5061 | none | noload => res_sip_endpoint_identifier_user.so | SDP in INVITE | Identify by host, no auth (IPv6) |
| 29 | bind=[::1]:5060protocol=udp | host = [::1]:5061auth = alice-auth | password = swordfish | noload => res_sip_endpoint_identifier_user.so | SDP in INVITE | Identify by host, userpass auth (IPv6) |
| 30 | bind=[::1]:5060protocol=udp | host = [::1]:5061auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | noload => res_sip_endpoint_identifier_user.so | SDP in INVITE | Identify by host, md5 auth (IPv6) |
| 31 | bind=[::1]:5060protocol=tcp | none | none | none | SDP in INVITE | Identify by username, no auth (TCP) (IPv6) |
| 32 | bind=[::1]:5060protocol=tcp | auth = alice-auth | password = swordfish | none | SDP in INVITE | Identify by username, userpass auth (TCP) (IPv6) |
| 33 | bind=[::1]:5060protocol=tcp | auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | none | SDP in INVITE | Identify by username, md5 auth (TCP) (IPv6) |
| 34 | bind=[::1]:5060protocol=tcp | host = [::1]:5061 | none | noload => res_sip_endpoint_identifier_user.so | SDP in INVITE | Identify by host, no auth (TCP) (IPv6) |
| 35 | bind=[::1]:5060protocol=tcp | host = [::1]:5061auth = alice-auth | password = swordfish | noload => res_sip_endpoint_identifier_user.so | SDP in INVITE | Identify by host, userpass auth (TCP) (IPv6) |
| 36 | bind=[::1]:5060protocol=tcp | host = [::1]:5061auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | noload => res_sip_endpoint_identifier_user.so | SDP in INVITE | Identify by host, md5 auth (TCP) (IPv6) |
| 37 | bind=[::1]:5060protocol=udp | none | none | none | No SDP in INVITE | Identify by username, no auth (IPv6) |
| 38 | bind=[::1]:5060protocol=udp | auth = alice-auth | password = swordfish | none | No SDP in INVITE | Identify by username, userpass auth (IPv6) |
| 39 | bind=[::1]:5060protocol=udp | auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | none | No SDP in INVITE | Identify by username, md5 auth (IPv6) |
| 40 | bind=[::1]:5060protocol=udp | host = [::1]:5061 | none | noload => res_sip_endpoint_identifier_user.so | No SDP in INVITE | Identify by host, no auth (IPv6) |
| 41 | bind=[::1]:5060protocol=udp | host = [::1]:5061auth = alice-auth | password = swordfish | noload => res_sip_endpoint_identifier_user.so | No SDP in INVITE | Identify by host, userpass auth (IPv6) |
| 42 | bind=[::1]:5060protocol=udp | host = [::1]:5061auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | noload => res_sip_endpoint_identifier_user.so | No SDP in INVITE | Identify by host, md5 auth (IPv6) |
| 43 | bind=[::1]:5060protocol=tcp | none | none | none | No SDP in INVITE | Identify by username, no auth (TCP) (IPv6) |
| 44 | bind=[::1]:5060protocol=tcp | auth = alice-auth | password = swordfish | none | No SDP in INVITE | Identify by username, userpass auth (TCP) (IPv6) |
| 45 | bind=[::1]:5060protocol=tcp | auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | none | No SDP in INVITE | Identify by username, md5 auth (TCP) (IPv6) |
| 46 | bind=[::1]:5060protocol=tcp | host = [::1]:5061 | none | noload => res_sip_endpoint_identifier_user.so | No SDP in INVITE | Identify by host, no auth (TCP) (IPv6) |
| 47 | bind=[::1]:5060protocol=tcp | host = [::1]:5061auth = alice-auth | password = swordfish | noload => res_sip_endpoint_identifier_user.so | No SDP in INVITE | Identify by host, userpass auth (TCP) (IPv6) |
| 48 | bind=[::1]:5060protocol=tcp | host = [::1]:5061auth = alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | noload => res_sip_endpoint_identifier_user.so | No SDP in INVITE | Identify by host, md5 auth (TCP) (IPv6) |

##### Test 1: File Playback

Procedure:  
 Alice places a call to extension playback@default

Pass conditions:  
 Ensure that the audio reaches Alice properly  
 Ensure that Asterisk sends a BYE to Alice

##### Test 2: Echo

Procedure:  
 Alice places a call to extension echo@default.  
 Alice plays audio towards Asterisk. The audio is reflected back to her.  
 After 5 seconds, Alice hangs up.

Pass conditions:  
 Ensure that audio from Alice reaches Asterisk  
 Ensure that echoed audio from Asterisk reaches Alice  
 Ensure that Asterisk responds to Alice's BYE with a 200 OK

### Off-nominal paths

All off-nominal tests will need to be run multiple times. Details on each iteration are given below:



| Iteration | Transport-specific options | Comment |
| --- | --- | --- |
| 1 | bind = 127.0.0.1:5060protocol = udp | IPv4 UDP |
| 2 | bind = 127.0.0.1:5060protocol = tcp | IPv4 TCP |
| 3 | bind = [::1]:5060protocol = udp | IPv6 UDP |
| 4 | bind = [::1]:5060protocol = tcp | IPv6 TCP |

Note that if a specific test requires multiple iteration, the total number of test iterations will be the product of the test's number of iteration multiplied by the number of iterations in the above table.

##### Test 1: Unknown Source

**Written**: Yes

Procedure:  
 Carol places a call to extension playback@default

Pass conditions:  
 Ensure Asterisk sends a 403 to Carol

##### Test 2: Authentication failure

This test requires several iterations. The differences in each iteration are detailed in the table below



| Iteration | Alice-specific Data | Alice-auth-specific data | Supplied Credentials | Comment | Written? |
| --- | --- | --- | --- | --- | --- |
| 1 | auth=alice-auth | password=swordfish | realm=asterisk  username=alice  password=halibut | Userpass authentication, wrong password | Yes |
| 2 | auth=alice-auth | password=swordfish | realm=asterisk  username=carol  password=swordfish | Userpass authentication, wrong username | Yes |
| 3 | auth=alice-auth | password=swordfish | realm=ampersand  username=alice  password=swordfish | Userpass authentication, wrong realm | Yes |
| 4 | auth=alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | realm=asterisk  username=alice  password=halibut | MD5 authentication, wrong password | Yes |
| 5 | auth=alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | realm=asterisk  username=carol  password=swordfish | MD5 authentication, wrong username | Yes |
| 6 | auth=alice-auth | auth_type=md5md5_cred=c9b9e23e2160fd69b19f99116da19711 | realm=ampersand  username=alice  password=swordfish | MD5 authentication, wrong realm | Yes |

Procedure:  
 Alice places a call to extension playback@default

Pass Conditions:  
 Ensure that Asterisk rejects all INVITEs with credentials with 401s.

##### Test 3: Unknown Destination

**Written**: Yes

Procedure:  
 Alice places a call to extension carol@default

Pass Conditions:  
 Ensure that Asterisk sends a 404 to Alice

##### Test 4: Incompatible codecs

**Written**: Yes

Procedure:  
 Alice places a call to extension playback@default, offering G.729 audio.

Pass Conditions:  
 Ensure that Asterisk sends a 488 to Alice

Outgoing Call Tests
===================

These tests all describe calls from Asterisk to endpoint "bob".

All outgoing tests will require multiple iterations. The details of each iteration are given in the following table:



| Iteration | Transport-specific data | Originate channel | Comment |
| --- | --- | --- | --- |
| 1 | bind = 127.0.0.1:5060protocol=udp | PJSIP/sip:bob@127.0.0.1:5062 | IPv4 UDP |
| 2 | bind = 127.0.0.1:5060protocol=tcp | PJSIP/sip:bob@127.0.0.1:5062 | IPv4 TCP |
| 3 | bind = [::1]:5060protocol=udp | PJSIP/sip:bob@[::1]:5062 | IPv6 UDP |
| 4 | bind = [::1]:5060protocol=udp | PJSIP/sip:bob@[::1]:5062 | IPv6 TCP |

### Nominal Tests

##### Test 1: Playback

**Written**: Yes

Procedure:  
 Originate a call from Asterisk to Bob and direct the answered call to playback@default

Pass Conditions:  
 Ensure that audio flows properly from Asterisk to Bob  
 Ensure that Asterisk sends a BYE to Bob after the playback has completed

##### Test 2: Echo

**Written**: Yes

Procedure:  
 Originate a call from Asterisk to Bob and direct the answered call to echo@default  
 Bob plays audio to Asterisk  
 After five seconds, Bob hangs up

Pass Conditions:  
 Ensure that audio flows properly from Bob to Asterisk  
 Ensure that audio from Bob to Asterisk is echoed properly back to Bob  
 Ensure that Asterisk responds to Bob's BYE with a 200 OK

### Off-nominal Tests

##### Test 1: Bob does not exist

**Written**: Yes

Procedure:  
 Remove Bob from the network.  
 Originate a call from Asterisk to Bob.

Pass Conditions:  
 Ensure that Asterisk tears down the created session properly after timer B expires (32 seconds by default)

##### Test 2: Bob does not answer

**Written**: Yes

Procedure:  
 Originate a call from Asterisk to Bob.  
 Bob rings but never answers the phone.

Pass Conditions:  
 Ensure that Asterisk cancels the outgoing call after the Dial timeout is reached.

##### Test 3: Bob is busy

**Written**: Yes

Procedure:  
 Originate a call from Asterisk to Bob.  
 Bob responds with a busy response.

Pass Conditions:  
 Ensure that Asterisk receives the 486 from Bob and ACKs it.  
 Ensure that this results in the outgoing session being destroyed.

##### Test 4: Call abandoned

**Written**: Yes

Procedure:  
 Originate a call from Asterisk to Bob.  
 Hang up the outbound call before Bob answers.

Pass Conditions:  
 Ensure that Asterisk sends a CANCEL to Bob.  
 Ensure that this results in the outgoing session being destroyed.

##### Test 5: Bob is incompatible

**Written**: Yes

Procedure:  
 Originate a call from Asterisk to Bob.  
 Bob answers the call but with codecs that are incompatible with what we offered.

Pass Conditions:  
 Ensure that Asterisk sends an immediate BYE after ACKing the 200 OK from Bob.

Two-party Call tests
====================

### Nominal Tests, Alice-initiated

The following tests require multiple iterations. Details about each iteration are in the following table:



| Iteration | Transport-specific data | Extension Alice calls |
| --- | --- | --- |
| 1 | bind = 127.0.0.1:5060protocol=udp | bob@default |
| 2 | bind = 127.0.0.1:5060protocol=tcp | bob@default |
| 3 | bind = [::1]:5060protocol=udp | bobv6@default |
| 4 | bind = [::1]:5060protocol=tcp | bobv6@default |

##### Test 1: Alice hangs up

**Written**: Yes

Procedure:  
 Alice calls Bob via Asterisk  
 Bob answers the call.  
 Alice and Bob exchange audio.  
 Alice hangs up the call after 5 seconds.

Pass Conditions:  
 Ensure that Alice can hear Bob's audio and Bob can hear Alice's audio.  
 Ensure that Asterisk sends a 200 OK to Alice's BYE  
 Ensure that Asterisk sends a BYE to Bob

##### Test 2: Bob hangs up

**Written**: Yes

Procedure:  
 Alice calls Bob via Asterisk  
 Bob answers the call.  
 Alice and Bob exchange audio.  
 Bob Hangs up the call after 5 seconds.

Pass Conditions:  
 Ensure that Alice can hear Bob's audio and Bob can hear Alice's audio.  
 Ensure that Asterisk sends a 200 OK to Bob's BYE  
 Ensure that Asterisk sends a BYE to Alice

### Nominal Tests, Asterisk-initiated

The following tests require multiple iterations. Details about each iteration are in the following table:



| Iteration | Transport-specific data | Originate channel | Originate extension | INVITE details |
| --- | --- | --- | --- | --- |
| 1 | bind = 127.0.0.1:5060protocol=udp | PJSIP/sip:alice@127.0.0.1:5061 | bob@default | SDP in offer from Alice |
| 2 | bind = 127.0.0.1:5060protocol=tcp | PJSIP/sip:alice@127.0.0.1:5061 | bob@default | SDP in offer from Alice |
| 3 | bind = [::1]:5060protocol=udp | PJSIP/sip:alice@[::1]:5061 | bobv6@default | SDP in offer from Alice |
| 4 | bind = [::1]:5060protocol=tcp | PJSIP/sip:alice@[::1]:5061 | bobv6@default | SDP in offer from Alice |
| 5 | bind = 127.0.0.1:5060protocol=udp | PJSIP/sip:alice@127.0.0.1:5061 | bob@default | No SDP in offer from Alice |
| 6 | bind = 127.0.0.1:5060protocol=tcp | PJSIP/sip:alice@127.0.0.1:5061 | bob@default | No SDP in offer from Alice |
| 7 | bind = [::1]:5060protocol=udp | PJSIP/sip:alice@[::1]:5061 | bobv6@default | No SDP in offer from Alice |
| 8 | bind = [::1]:5060protocol=tcp | PJSIP/sip:alice@[::1]:5061 | bobv6@default | No SDP in offer from Alice |

##### Test 1: Alice hangs up

Procedure:  
 Asterisk originates a call to Alice and directs the answered call to Bob  
 Bob answers the call.  
 Alice and Bob exchange audio.  
 Alice hangs up after 5 seconds.

Pass Conditions:  
 Ensure that Alice can hear Bob's audio and Bob can hear Alice's audio.  
 Ensure that Asterisk sends a 200 OK to Alice's BYE  
 Ensure that Asterisk sends a BYE to Bob

##### Test 2: Bob hangs up

Procedure:  
 Asterisk originates a call to Alice and directs the answered call to Bob  
 Bob answers the call.  
 Alice and Bob exchange audio.  
 Bob hangs up after 5 seconds.

Pass Conditions:  
 Ensure that Alice can hear Bob's audio and Bob can hear Alice's audio.  
 Ensure that Asterisk sends a 200 OK to Bob's BYE  
 Ensure that Asterisk sends a BYE to Alice

### Off-nominal Tests, Alice-initiated

The following tests require multiple iterations. Details about each iteration are in the following table:



| Iteration | Transport-specific data | Extension Alice calls |
| --- | --- | --- |
| 1 | bind = 127.0.0.1:5060protocol=udp | bob@default |
| 2 | bind = 127.0.0.1:5060protocol=tcp | bob@default |
| 3 | bind = [::1]:5060protocol=udp | bobv6@default |
| 4 | bind = [::1]:5060protocol=tcp | bobv6@default |

##### Test 1: Bob does not exist

Procedure:  
 Remove Bob from the network.  
 Alice places a call to Asterisk to Bob

Pass Conditions:  
 Ensure that Asterisk tears down the outgoing session properly after timer B expires (32 seconds by default)  
 Ensure that Asterisk sends an error response to Alice

##### Test 2: Bob does not answer

Procedure:  
 Alice places a call to Asterisk to Bob  
 Bob rings but never answers the phone.

Pass Conditions:  
 Ensure that Asterisk cancels the outgoing call to Bob after the Dial timeout is reached.  
 Ensure that Asterisk sends an error response to Alice

##### Test 3: Bob is busy

Procedure:  
 Alice places a call to Asterisk to Bob  
 Bob responds with a busy response.

Pass Conditions:  
 Ensure that Asterisk receives the 486 from Bob and ACKs it.  
 Ensure that Asterisk sends an error response (preferably a 486) to Alice.

##### Test 4: Call abandoned

Procedure:  
 Alice places a call to Asterisk to Bob.  
 Alice hangs up the outbound call before Bob answers.

Pass Conditions:  
 Ensure that Asterisk sends a CANCEL to Bob.  
 Ensure that Asterisk sends a 200 OK to Alice's CANCEL and a 487 to Alice's INVITE

##### Test 5: Bob is incompatible

Procedure:  
 Alice places a call to Asterisk to Bob.  
 Bob answers the call but with codecs that are incompatible with what we offered.

Pass Conditions:  
 Ensure that Asterisk sends an immediate BYE after ACKing the 200 OK from Bob.  
 Ensure that Asterisk sends a BYE to Alice.

### Off-nominal tests, Asterisk-initiated

The following tests require multiple iterations. Details about each iteration are in the following table:



| Iteration | Transport-specific data | Originate channel | Originate extension |
| --- | --- | --- | --- |
| 1 | bind = 127.0.0.1:5060protocol=udp | PJSIP/sip:alice@127.0.0.1:5061 | bob@default |
| 2 | bind = 127.0.0.1:5060protocol=tcp | PJSIP/sip:alice@127.0.0.1:5061 | bob@default |
| 3 | bind = [::1]:5060protocol=udp | PJSIP/sip:alice@[::1]:5061 | bobv6@default |
| 4 | bind = [::1]:5060protocol=tcp | PJSIP/sip:alice@[::1]:5061 | bobv6@default |

##### Test 1: Bob does not exist

Procedure:  
 Remove Bob from the network.  
 Asterisk originates a call to Alice and directs the answered call to Bob

Pass Conditions:  
 Ensure that Asterisk tears down Bob's session properly after timer B expires (32 seconds by default)  
 Ensure that Asterisk sends a BYE to Alice

##### Test 2: Bob does not answer

Procedure:  
 Asterisk originates a call to Alice and directs the answered call to Bob  
 Bob rings but never answers the phone.

Pass Conditions:  
 Ensure that Asterisk cancels the outgoing call to Bob after the Dial timeout is reached.  
 Ensure that Asterisk sends a BYE to Alice

##### Test 3: Bob is busy

Procedure:  
 Asterisk originates a call to Alice and directs the answered call to Bob  
 Bob responds with a busy response.

Pass Conditions:  
 Ensure that Asterisk receives the 486 from Bob and ACKs it.  
 Ensure that Asterisk sends a BYE to Alice

##### Test 4: Call abandoned

Procedure:  
 Asterisk originates a call to Alice and directs the answered call to Bob  
 Hang up the outbound call before Bob answers.

Pass Conditions:  
 Ensure that Asterisk sends a CANCEL to Bob.  
 Ensure that Asterisk sends a 200 OK to Alice's BYE

##### Test 5: Bob is incompatible

Procedure:  
 Asterisk originates a call to Alice and directs the answered call to Bob.  
 Bob answers the call but with codecs that are incompatible with what we offered.

Pass Conditions:  
 Ensure that Asterisk sends an immediate BYE after ACKing the 200 OK from Bob.  
 Ensure that Asterisk sends a BYE to Alice.

