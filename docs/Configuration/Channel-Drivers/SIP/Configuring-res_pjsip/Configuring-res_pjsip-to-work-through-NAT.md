---
title: Configuring res_pjsip to work through NAT
pageid: 27198672
---

Here we can show some examples of working configuration for Asterisk's SIP channel driver when Asterisk is behind NAT (Network Address Translation).

If you are migrating from chan_sip to chan_pjsip, then also read the NAT section in [Migrating from chan_sip to res_pjsip](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/Migrating-from-chan_sip-to-res_pjsip) for helpful tips.

Asterisk and Phones Connecting Through NAT to an ITSP
=====================================================

This example should apply for most simple NAT scenarios that meet the following criteria:

* Asterisk and the phones are on a private network.
* There is a router interfacing the private and public networks. Where the public network is the Internet.
* The router is performing Network Address Translation and Firewall functions.
* The router is configured for port-forwarding, where it is mapping the necessary ranges of SIP and RTP traffic to your internal Asterisk server.  
In this example the router is port-forwarding WAN inbound TCP/UDP 5060 and UDP 10000-20000 to LAN 192.0.2.10

This example was based on a configuration for the ITSP [SIP.US](https://www.sip.us/) and assuming you swap out the addresses and credentials for real ones, it should work for a SIP.US SIP account.

### Devices Involved in the Example

Using [RFC5737](http://tools.ietf.org/html/rfc5737) documentation addresses

| Device           | IP in example                                                      |
| :--------------- | :----------------------------------------------------------------- |
| VOIP Phone(6001) | `192.0.2.20`                                                       |
| PC/Asterisk      | `192.0.2.10`                                                       |
| Router           | `LAN: 192.0.2.1`<br>`WAN: 198.51.100.5`                            |
| ITSP SIP gateway | `203.0.113.1 (gw1.example.com)`<br>`203.0.113.2 (gw2.example.com)` |

For the sake of a complete example and clarity, in this example we use the following fake details:

ITSP Account number:  1112223333

DID number provided by ITSP:  19998887777

### pjsip.conf Configuration

We are assuming you have already read the Configuring res_pjsip page and have a basic understanding of Asterisk. For this NAT example, the important config options to note are **local_net**, **external_media_address** and **external_signaling_address** in the transport type section and **direct_media** in the endpoint section. The rest of the options may depend on your particular configuration, phone model, network settings, ITSP, etc. The key is to make sure you have those three options set appropriately.

##### local_net

This is the IP network that we want to consider our local network. For communication to addresses within this range, we won't apply any NAT-related settings, such as the external\* options below.

##### external_media_address

This is the external IP address to use in RTP handling. When a request or response is sent out from Asterisk, if the destination of the message is outside the IP network defined in the option 'local_net', and the media address in the SDP is within the localnet network, then the media address in the SDP will be rewritten to the value defined for 'external_media_address'.

##### external_signaling_address

This is much like the external_media_address setting, but for SIP signaling instead of RTP media. The two external\* options mentioned here should be set to the same address unless you separate your signaling and media to different addresses or servers.

##### direct_media

Determines whether media may flow directly between endpoints

 

Together these options make sure the far end knows where to send back SIP and RTP packets, and direct_media ensures Asterisk stays in the media path. This is important, because our Asterisk system has a private IP address that the ITSP cannot route to. We want to make sure the SIP and RTP traffic comes back to the WAN/Public internet address of our router. The sections prefixed with "sipus" are all configuration needed for inbound and outbound connectivity of the SIP trunk, and the sections named 6001 are all for the VOIP phone.




---

  
  


```

[transport-udp-nat]
type=transport
protocol=udp
bind=0.0.0.0
local_net=192.0.2.0/24
local_net=127.0.0.1/32
external_media_address=198.51.100.5
external_signaling_address=198.51.100.5

[sipus_reg]
type=registration
transport=transport-udp-nat
outbound_auth=sipus_auth
server_uri=sip:gw1.example.com
client_uri=sip:1112223333@gw1.example.com
contact_user=19998887777
retry_interval=60

[sipus_auth]
type=auth
auth_type=userpass
password=************
username=1112223333
realm=gw1.example.com

[sipus_endpoint]
type=endpoint
transport=transport-udp-nat
context=from-external
disallow=all
allow=ulaw
outbound_auth=sipus_auth
aors=sipus_aor
direct_media=no
from_domain=gw1.example.com

[sipus_aor]
type=aor
contact=sip:gw1.example.com
contact=sip:gw2.example.com

[sipus_identify]
type=identify
endpoint=sipus_endpoint
match=203.0.113.1
match=203.0.113.2

[6001]
type=endpoint
context=from-internal
disallow=all
allow=ulaw
transport=transport-udp-nat
auth=6001
aors=6001
direct_media=no

[6001]
type=auth
auth_type=userpass
password=************
username=6001

[6001]
type=aor
max_contacts=2

```


### For Remote Phones Behind NAT

In the above example we assumed the phone was on the same local network as Asterisk. Now, perhaps Asterisk is exposed on a public address, and instead your phones are remote and behind NAT, or maybe you have a double NAT scenario?

In these cases you will want to consider the below settings for the remote endpoints.

##### media_address

IP address used in SDP for media handling

At the time of SDP creation, the IP address defined here will be used as  


##### rtp_symmetric

Enforce that RTP must be symmetric. Send RTP back to the same address/port we received it from.

##### force_rport

Force RFC3581 compliant behavior even when no rport parameter exists. Basically always send SIP responses back to the same port we received SIP requests from.

##### direct_media

Determines whether media may flow directly between endpoints.

##### rewrite_contact

Determine whether SIP requests will be sent to the source IP address and port, instead of the address provided by the endpoint.

Clients Supporting ICE,STUN,TURN
--------------------------------

This is really relevant to media, so look to the [section here](/Interactive-Connectivity-Establishment--ICE--in-Asterisk) for basic information on enabling this support and we'll add relevant examples later.

