---
title: PJSIP Configuration Wizard
pageid: 31096871
---

The PJSIP Configuration Wizard (module `res_pjsip_config_wizard`) is a new feature in Asterisk 13.2.0.  While the basic `chan_pjsip` configuration objects (endpoint, aor, etc.) allow a great deal of flexibility and control they can also make configuring standard scenarios like `trunk` and `user` more complicated than similar scenarios in `sip.conf` and `users.conf`.  The PJSIP Configuration Wizard aims to ease that burden by providing a single object called 'wizard' that be used to configure most common `chan_pjsip` scenarios.

The following configurations demonstrate a simple ITSP scenario.



| `pjsip_wizard.conf`[my-itsp]
type = wizard
sends\_auth = yes
sends\_registrations = yes
remote\_hosts = sip.my-itsp.net
outbound\_auth/username = my\_username
outbound\_auth/password = my\_password
endpoint/context = default
aor/qualify\_frequency = 15


  
```
 
```
 | `pjsip.conf`[my-itsp]
type = endpoint
aors = my-itsp
outbound\_auth = my-itsp-auth
context = default
 
[my-itsp]
type = aor
contact = sip:sip.my-itsp.net
qualify\_frequency = 15

[my-itsp-auth]
type = auth
auth\_type = userpass
username = my\_username
password = my\_password

[my-itsp-reg]
type = registration
outbound\_auth = my-itsp-auth
server\_uri = sip:sip.my-itsp.net
client\_uri = sip:my\_username@sip.my-itsp.net

[my-itsp-identify]
type = identify
endpoint = my-itsp
match = sip.my-itsp.net

  |
| --- | --- |

 

Both produce the same result.  In fact, the wizard creates standard `chan_pjsip` objects behind the scenes.  In the above example...

* An endpoint and aor are created with the same name as the wizard.
* The `endpoint/context` and `aor/qualify_fequency` parameters are added to them.
* `remote_hosts` captures the remote host for all objects.
* A contact for the aor is created for each remote host.
* `sends_auth=yes` causes an auth object to be created.
* `outbound_auth/username` and `outbound_auth/password` are added to it.
* An `outbound_auth` line is added to the endpoint.
* `sends_registrations=yes` causes a registration object to be created.
* An `outbound_auth` line is added to the registration.
* The `server_uri` and `client_uri` are constructed using the remote host and username.
* An identify object is created and a match is added for each remote host.

 

Configuration Reference:
------------------------



| Parameter | Description |
| --- | --- |
| type | Must be `wizard` |
| sends\_auth | Will create an outbound auth object for the endpoint andregistration. At least `outbound/username` must be specified.default = `no`  |
| accepts\_auth | Will create an inbound auth object for the endpoint.At least 'inbound/username' must be specified.default = `no`  |
| sends\_registrations | Will create an outbound registration object for eachhost in remote\_hosts.default = `no` |
| remote\_hosts | A comma separated list of remote hosts in the form of`<ipaddress | hostname>[:port][, ... ]`If specified, a static contact for each host will be createdin the aor. If `accepts_registrations` is no, an identifyobject is also created with a match line for each remote host.Hostnames must resolve to A, AAAA or CNAME records.SRV records are not currently supported.default = `""` |
| transport | The transport to use for the endpoint and registrationsdefault = the pjsip default |
| server\_uri\_pattern | The pattern used to construct the registration `server_uri`.The replaceable parameter `${REMOTE_HOST`} is available for use.default = `sip:${REMOTE_HOST`} |
| client\_uri\_pattern | The pattern used to construct the registration `client_uri`.The replaceable parameters ${REMOTE\_HOST} and${USERNAME} are available for use.default = {{sip:${USERNAME}@${REMOTE\_HOST}}} |
| contact\_pattern | The pattern used to construct the aor contact.The replaceable parameter ${REMOTE\_HOST} is available for use.default = `sip:${REMOTE_HOST`} |
| has\_phoneprov | Will create a phoneprov object. If yes, both `phoneprov/MAC` and `phoneprov/PROFILE`must be specified.default = `no`  |
| has\_hint | Enables the automatic creation of dialplan hints.Two entries will be created.  One hint for 'hint\_exten' and one application to execute when 'hint\_exten' is dialed. |
| hint\_context | The context into which hints are placed. |
| hint\_exten | The extension this hint will be registered with. |
| hint\_application | An application with parameters to execute when 'hint\_exten' is dialed.
```
Example: Gosub(stdexten,${EXTEN},1(${HINT}))
```
 |
| <object>/<parameter> | These parameters are passed unmodified to the native object. |

 

 

Configuration Notes:
--------------------

* Wizards must be defined in `pjsip_wizard.conf`.
* Using pjsip\_wizard.conf doesn't remove the need for pjsip.conf or any other config file.
* Transport, system and global sections still need to be defined in pjsip.conf.
* You can continue to create discrete endpoint, aor, etc. objects in pjsip.conf but there can be no name collisions between wizard created objects and discretely created objects.
* An endpoint and aor are created for each wizard.
	+ The endpoint and aor are named the same as the wizard.
	+ Parameters are passed to them using the `endpoint/` and `aor/` prefixes.
	+ A contact is added to the aor for each remote host using the `contact_pattern` and `${REMOTE_HOST`}.
* `sends_auth` causes an auth object to be created.
	+ The name will be `<wizard_name>-oauth`.
	+ Parameters are passed to it using the `outbound_auth/` prefix.
	+ The endpoint automatically has an `outbound_auth` parameter added to it.
	+ Registrations automatically have an `outbound_auth` parameter added to them (if registrations are created, see below).
* `accepts_auth` causes an auth object to be created.
	+ The name will be `<wizard_name>-iauth`.
	+ Parameters are passed to it using the `inbound_auth/` prefix.
	+ The endpoint automatically has an `auth` parameter added to it.
* `sends_registrations` causes an outbound registration object to be created for each remote host.
	+ The name will be `<wizard_name>-reg-<n>` where n starts at 0 and increments by 1 for each remote host.
	+ Parameters are passed to them using the `registration/` prefix.
	+ You should not use a wizard in situations whereyou need to pass different parameters to each registration.
	+ `server_uri` and `client_uri` are constructed using their respective patterns using `${REMOTE_HOST`} and `${USERNAME`}.
* If `accepts_registrations` is specified, `remote_hosts` must NOT be specified and no contacts are added to the aor.  This causes registrations to be accepted.
* If `accepts_registrations` is NOT specified or set to `no`, then an identify object is created to match incoming requests to the endpoint.  

	+ The name will be `<wizard_name>-identify`.
	+ Parameters are passed to it using the `identify/` prefix although there really aren't any to pass.
* If `has_phoneprov` is specified, a phoneprov object object is created.
	+ The name will be `<wizard_name>-phoneprov`.
	+ Both `phoneprov/MAC` and `phoneprov/PROFILE` must be specified.
* `has_hint` causes hints to be automatically created.  

	+ `hint_exten` must be specified.
* All created objects must pass the same edit criteria they would have to pass if they were specified discretely.
* All created objects will have a `@pjsip_wizard=<wizard_name>` parameter added to them otherwise they are indistinguishable from discretely created ones.
* All created object are visible via the CLI and AMI as though they were created discretely.
Full Examples:
--------------

###  Phones:



| Configuration | Notes |
| --- | --- |
| [user\_defaults](!)
type = wizard
transport = ipv4
accepts\_registrations = yes
sends\_registrations = no
accepts\_auth = yes
sends\_auth = no
has\_hint = yes
hint\_context = DLPN\_DialPlan1
hint\_application = Gosub(stdexten,${EXTEN},1(${HINT}))
endpoint/context = DLPN\_DialPlan1
endpoint/allow\_subscribe = yes
endpoint/allow = !all,ulaw,gsm,g722
endpoint/direct\_media = yes
endpoint/force\_rport = yes
endpoint/disable\_direct\_media\_on\_nat = yes
endpoint/direct\_media\_method = invite
endpoint/ice\_support = yes
endpoint/moh\_suggest = default
endpoint/send\_rpid = yes
endpoint/rewrite\_contact = yes
endpoint/send\_pai = yes
endpoint/allow\_transfer = yes
endpoint/trust\_id\_inbound = yes
endpoint/device\_state\_busy\_at = 1
endpoint/trust\_id\_outbound = yes
endpoint/send\_diversion = yes
aor/qualify\_frequency = 30
aor/authenticate\_qualify = no
aor/max\_contacts = 1
aor/remove\_existing = yes
aor/minimum\_expiration = 30
aor/support\_path = yes
phoneprov/PROFILE = profile1

[bob](user\_defaults)
hint\_exten = 1000
inbound\_auth/username = bob
inbound\_auth/password = bobspassword

[alice](user\_defaults)
hint\_exten = 1001
endpoint/callerid = Alice <1001>
endpoint/allow = !all,ulaw
inbound\_auth/username = alice
inbound\_auth/password = alicespassword
has\_phoneprov = yes
phoneprov/MAC = deadbeef4dad

  | This example demonstrates the power of both wizards and templates.Once the template is created, adding a new phone could be as simple as creating a wizard objectwith nothing more than a username and password.  You don't even have to specify 'type' because it'sinherited from the template.Of course, you can override ANYTHING in the wizard object or specify everything and not use templates at all. |

### Trunk to an ITSP requiring registration:



| Configuration | Notes |
| --- | --- |
| [trunk\_defaults](!)
type = wizard
transport = ipv4
endpoint/allow\_subscribe = no
endpoint/allow = !all,ulaw
aor/qualify\_frequency = 30
registration/expiration = 1800
 
[myitsp](trunk\_defaults)
sends\_auth = yes
sends\_registrations = yes
endpoint/context = DID\_myitsp
remote\_hosts = sip1.myitsp.net,sip2.myitsp.net
accepts\_registrations = no
endpoint/send\_rpid = yes
endpoint/send\_pai = yes
outbound\_auth/username = my\_username
outbound\_auth/password = my\_password
 
[my\_other\_itsp](trunk\_defaults)
sends\_auth = yes
sends\_registrations = yes
endpoint/context = DID\_myitsp
remote\_hosts = sip1.my-other-itsp.net,sip2.my-other-itsp.net
accepts\_registrations = no
endpoint/send\_rpid = yes
endpoint/send\_pai = yes
outbound\_auth/username = my\_username
outbound\_auth/password = my\_password
registration/expiration = 900
registration/support\_path = no | This is an example of trunks to 2 different ITSPs each of which has a primary andbackup server.It also shows most of the endpoint and aor parameters being left at their defaults.In this scenario, each wizard object takes the place of an endpoint, aor, auth,identify and 2 registrations. |

### Trunk between trusted peers:



| Configuration | Notes |
| --- | --- |
| [trusted-peer](trunk\_defaults)
endpoint/context = peer\_context
remote\_hosts = sip1.peer.com:45060
sends\_registrations = no
accepts\_registrations = no
sends\_auth = no
accepts\_auth = no | This one's even simpler. The `sends_` and `accepts_` parameters all default to `no` so you don't reallyeven have to specify them unless your template has them set to `yes`. |

