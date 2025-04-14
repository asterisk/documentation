---
title: res_pjsip Configuration Examples
pageid: 30278066
---

Below are some sample configurations to demonstrate various scenarios with complete pjsip.conf files. To see examples side by side with old chan_sip config head to [Migrating from chan_sip to res_pjsip](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/Migrating-from-chan_sip-to-res_pjsip). Explanations of the config sections found in each example can be found in [PJSIP Configuration Sections and Relationships](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/PJSIP-Configuration-Sections-and-Relationships).

A tutorial on secure and encrypted calling is located in the [Secure Calling](/Deployment/Secure-Calling) section of the wiki.

An endpoint with a single SIP phone with inbound registration to Asterisk
-------------------------------------------------------------------------

EXAMPLE CONFIGURATION

```
;===============TRANSPORT

[simpletrans]
type=transport
protocol=udp
bind=0.0.0.0

;===============EXTENSION 6001

[6001]
type=endpoint
context=internal
disallow=all
allow=ulaw
auth=auth6001
aors=6001

[auth6001]
type=auth
auth_type=userpass
password=6001
username=6001

[6001]
type=aor
max_contacts=1

```

* auth= is used for the endpoint as opposed to outbound_auth= since we want to allow inbound registration for this endpoint
* max_contacts= is set to something non-zero as we want to allow contacts to be created through registration

On this Page

A SIP trunk to your service provider, including outbound registration
---------------------------------------------------------------------

EXAMPLE CONFIGURATIONTrunks are a little tricky since many providers have unique requirements. Your final configuration may differ from what you see here.

```
;==============TRANSPORTS

[simpletrans]
type=transport
protocol=udp
bind=0.0.0.0

;===============TRUNK

[mytrunk]
type=registration
outbound_auth=mytrunk
server_uri=sip:sip.example.com
client_uri=sip:1234567890@sip.example.com
retry_interval=60

[mytrunk]
type=auth
auth_type=userpass
password=1234567890
username=1234567890

[mytrunk]
type=aor
contact=sip:sip.example.com:5060

[mytrunk]
type=endpoint
context=from-external
disallow=all
allow=ulaw
outbound_auth=mytrunk
aors=mytrunk

[mytrunk]
type=identify
endpoint=mytrunk
match=sip.example.com

```

* "contact=sip:203.0.113.1:5060", we don't define the user portion statically since we'll set that dynamically in dialplan when we call the Dial application.
* "outbound_auth=mytrunk", we use "outbound_auth" instead of "auth" since the provider isn't typically going to authenticate with us when calling, but we will probably
* We use an identify object to map all traffic from the provider's IP as traffic to that endpoint since the user portion of their From: header may vary with each call.
* This example assumes that [sip.example.com](http://sip.example.com) resolves to 203.0.113.1

!!! tip 
    You can specify the transport type by appending it to the server_uri and client_uri parameters. e.g.:
[//]: # (end-tip)

```
[mytrunk]
type=registration
outbound_auth=mytrunk
server_uri=sip:sip.example.com\;transport=tcp
client_uri=sip:1234567890@sip.example.com\;transport=tcp
retry_interval=60  

---

```

Multiple endpoints with phones registering to Asterisk, using templates
-----------------------------------------------------------------------

EXAMPLE CONFIGURATIONWe want to show here that generally, with a large configuration you'll end up using templates to make configuration easier to handle when scaling. This avoids having redundant code in every similar section that you create.

```
 ;===============TRANSPORT

[simpletrans]
type=transport
protocol=udp
bind=0.0.0.0

;===============ENDPOINT TEMPLATES

[endpoint-basic](!)
type=endpoint
context=internal
disallow=all
allow=ulaw

[auth-userpass](!)
type=auth
auth_type=userpass

[aor-single-reg](!)
type=aor
max_contacts=1

;===============EXTENSION 6001

[6001](endpoint-basic)
auth=auth6001
aors=6001

[auth6001](auth-userpass)
password=6001
username=6001

[6001](aor-single-reg)

;===============EXTENSION 6002

[6002](endpoint-basic)
auth=auth6002
aors=6002

[auth6002](auth-userpass)
password=6002
username=6002

[6002](aor-single-reg)

;===============EXTENSION 6003

[6003](endpoint-basic)
auth=auth6003
aors=6003

[auth6003](auth-userpass)
password=6003
username=6003

[6003](aor-single-reg)

```

Obviously the larger your configuration is, the more templates will benefit you. Here we just break apart the endpoints with templates, but you could do that with any config section that needs instances with variation, but where each may share common settings with their peers.
