---
title: PJSIP Configuration Wizard
pageid: 31096871
---

The PJSIP Configuration Wizard (module `res_pjsip_config_wizard`) is a new feature in Asterisk 13.2.0.  While the basic `chan_pjsip` configuration objects (endpoint, aor, etc.) allow a great deal of flexibility and control they can also make configuring standard scenarios like `trunk` and `user` more complicated than similar scenarios in `sip.conf` and `users.conf`.  The PJSIP Configuration Wizard aims to ease that burden by providing a single object called 'wizard' that be used to configure most common `chan_pjsip` scenarios.

The following configurations demonstrate a simple ITSP scenario.



| `pjsip_wizard.conf`


---



```

[my-itsp]
type = wizard
sends_auth = yes
sends_registrations = yes
remote_hosts = sip.my-itsp.net
outbound_auth/username = my_username
outbound_auth/password = my_password
endpoint/context = default
aor/qualify_frequency = 15




```


   | `pjsip.conf`


---



```

[my-itsp]
type = endpoint
aors = my-itsp
outbound_auth = my-itsp-auth
context = default
 
[my-itsp]
type = aor
contact = sip:sip.my-itsp.net
qualify_frequency = 15

[my-itsp-auth]
type = auth
auth_type = userpass
username = my_username
password = my_password

[my-itsp-reg]
type = registration
outbound_auth = my-itsp-auth
server_uri = sip:sip.my-itsp.net
client_uri = sip:my_username@sip.my-itsp.net

[my-itsp-identify]
type = identify
endpoint = my-itsp
match = sip.my-itsp.net



```


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
| sends_auth | Will create an outbound auth object for the endpoint anddefault = `no`  |
| accepts_auth | Will create an inbound auth object for the endpoint.default = `no`  |
| sends_registrations | Will create an outbound registration object for eachdefault = `no` |
| remote_hosts | A comma separated list of remote hosts in the form ofdefault = `""` |
| transport | The transport to use for the endpoint and registrationsdefault = the pjsip default |
| server_uri_pattern | The pattern used to construct the registration `server_uri`.The replaceable parameter `${REMOTE_HOST`} is available for use.default = `sip:${REMOTE_HOST`} |
| client_uri_pattern | The pattern used to construct the registration `client_uri`.The replaceable parameters ${REMOTE_HOST} and${USERNAME} are available for use.default = {{sip:${USERNAME}@${REMOTE_HOST}}} |
| contact_pattern | The pattern used to construct the aor contact.The replaceable parameter ${REMOTE_HOST} is available for use.default = `sip:${REMOTE_HOST`} |
| has_phoneprov | Will create a phoneprov object. If yes, both `phoneprov/MAC` and `phoneprov/PROFILE`must be specified.default = `no`  |
| has_hint | Enables the automatic creation of dialplan hints.Two entries will be created.  One hint for 'hint_exten' and one application to execute when 'hint_exten' is dialed. |
| hint_context | The context into which hints are placed. |
| hint_exten | The extension this hint will be registered with. |
| hint_application | An application with parameters to execute when 'hint_exten' is dialed.`Example: Gosub(stdexten,${EXTEN},1(${HINT}))` |
| <object>/<parameter> | These parameters are passed unmodified to the native object. |

 

 

Configuration Notes:
--------------------

* Wizards must be defined in `pjsip_wizard.conf`.
* Using pjsip_wizard.conf doesn't remove the need for pjsip.conf or any other config file.
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
	+ Registrations automatically have an `outbound_auth` parameter added to them (if registrations are created, see below).
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

	+ The name will be `<wizard_name>-identify`.
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
| 

---



```

[user_defaults](!)
type = wizard
transport = ipv4
accepts_registrations = yes
sends_registrations = no
accepts_auth = yes
sends_auth = no
has_hint = yes
hint_context = DLPN_DialPlan1
hint_application = Gosub(stdexten,${EXTEN},1(${HINT}))
endpoint/context = DLPN_DialPlan1
endpoint/allow_subscribe = yes
endpoint/allow = !all,ulaw,gsm,g722
endpoint/direct_media = yes
endpoint/force_rport = yes
endpoint/disable_direct_media_on_nat = yes
endpoint/direct_media_method = invite
endpoint/ice_support = yes
endpoint/moh_suggest = default
endpoint/send_rpid = yes
endpoint/rewrite_contact = yes
endpoint/send_pai = yes
endpoint/allow_transfer = yes
endpoint/trust_id_inbound = yes
endpoint/device_state_busy_at = 1
endpoint/trust_id_outbound = yes
endpoint/send_diversion = yes
aor/qualify_frequency = 30
aor/authenticate_qualify = no
aor/max_contacts = 1
aor/remove_existing = yes
aor/minimum_expiration = 30
aor/support_path = yes
phoneprov/PROFILE = profile1

[bob](user_defaults)
hint_exten = 1000
inbound_auth/username = bob
inbound_auth/password = bobspassword

[alice](user_defaults)
hint_exten = 1001
endpoint/callerid = Alice <1001>
endpoint/allow = !all,ulaw
inbound_auth/username = alice
inbound_auth/password = alicespassword
has_phoneprov = yes
phoneprov/MAC = deadbeef4dad

 

```

 | This example demonstrates the power of both wizards and templates.Once the template is created, adding a new phone could be as simple as creating a wizard objectOf course, you can override ANYTHING in the wizard object or specify everything and not use templates at all. |

### Trunk to an ITSP requiring registration:



| Configuration | Notes |
| --- | --- |
| 

---



```

[trunk_defaults](!)
type = wizard
transport = ipv4
endpoint/allow_subscribe = no
endpoint/allow = !all,ulaw
aor/qualify_frequency = 30
registration/expiration = 1800
 
[myitsp](trunk_defaults)
sends_auth = yes
sends_registrations = yes
endpoint/context = DID_myitsp
remote_hosts = sip1.myitsp.net,sip2.myitsp.net
accepts_registrations = no
endpoint/send_rpid = yes
endpoint/send_pai = yes
outbound_auth/username = my_username
outbound_auth/password = my_password
 
[my_other_itsp](trunk_defaults)
sends_auth = yes
sends_registrations = yes
endpoint/context = DID_myitsp
remote_hosts = sip1.my-other-itsp.net,sip2.my-other-itsp.net
accepts_registrations = no
endpoint/send_rpid = yes
endpoint/send_pai = yes
outbound_auth/username = my_username
outbound_auth/password = my_password
registration/expiration = 900
registration/support_path = no

```

 | This is an example of trunks to 2 different ITSPs each of which has a primary andIt also shows most of the endpoint and aor parameters being left at their defaults.In this scenario, each wizard object takes the place of an endpoint, aor, auth, |

### Trunk between trusted peers:



| Configuration | Notes |
| --- | --- |
| 

---



```

[trusted-peer](trunk_defaults)
endpoint/context = peer_context
remote_hosts = sip1.peer.com:45060
sends_registrations = no
accepts_registrations = no
sends_auth = no
accepts_auth = no

```

 | This one's even simpler. The `sends_` and `accepts_` parameters all default to `no` so you don't really |

