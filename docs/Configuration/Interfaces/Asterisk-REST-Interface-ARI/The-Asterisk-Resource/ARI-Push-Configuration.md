---
title: ARI Push Configuration
pageid: 32375922
---

Overview
========

Asterisk typically retrieves its configuration information by *pulling* it from some configuration source - whether that be a static configuration file or a relational database. This page describes an alternative way to provide configuration information to Asterisk using a *push* model through ARI. Note that only modules whose configuration is managed by the [Sorcery](/Fundamentals/Asterisk-Configuration/Sorcery) data abstraction framework in Asterisk can make use of this mechanism. Predominately, this implies configuration of the [PJSIP](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip) stack.

 

On This PageVersion Information


!!! note 
    This feature was introduced in ARI version 1.8.0, or Asterisk 13.5.0 or later.

      
[//]: # (end-note)



Push Configuration Workflow
===========================

![](ARI-Push-Configuration.png)

With push configuration, an external process uses ARI to perform a configuration operation. The configuration operation could be any one of the four classic operations for persistent storage - [Create, Retrieve, Update, or Delete](https://en.wikipedia.org/wiki/Create-_read-_update_and_delete). For the purposes of this workflow, we'll assume that the operation is to create a configuration change in Asterisk.

The ARI client makes a `PUT` request, where the body contains the configuration object to create, encoded in JSON. This is first handled by ARI, which performs basic validation on the inbound request and its contents. Once the request is validated, ARI asks the Sorcery framework to create the actual object.

Sorcery requires three pieces of information, at a minimum, to create an object:

* The overall class of configuration types. This is usually a module or namespace that provides multiple types of objects to be created, e.g., 'res_pjsip'.
* The type of configuration object to create, e.g., 'endpoint'.
* A unique identifier (amongst objects of the same type) for the object, e.g., 'alice'.

Once Sorcery has determined that it knows how to create the type of object, it creates it using the provided data in the JSON body. If some piece of data in the body can't be converted to an attribute on the object, the inbound request is rejected.

If the object is created successfully, Sorcery then has to determine what to do with it. While we've just had a piece of configuration pushed to Asterisk, Sorcery is responsible for storing it in some permanent - or semi-permanent - storage. For this, it looks to its configuration in `sorcery.conf`. We'll assume that our object should be created in the AstDB, a SQLite database. In that case, Asterisk pushes the newly created object to `res_sorcery_astdb`, which is the Sorcery driver for the AstDB. This module then writes the information to the SQLite database.

When the PJSIP stack next needs the object - such as when an `INVITE` request is received that maps to Alice's endpoint - it queries Sorcery for the object. At this point, from Sorcery's perspective, the retrieval of the configuration information is exactly the same as if a static configuration file or a relational database was providing the information, and it returns the pushed configuration information.

Asterisk Configuration
======================

To make use of push configuration, you **must** configure Sorcery to persist the pushed configuration somewhere. If you don't want the information to persist beyond reloads, you can use the in-memory Sorcery driver, `res_sorcery_memory`. The example below assumes that we will push configuration to the PJSIP stack, and that we want information to persist even if Asterisk is restarted. For that reason, we'll use the AstDB.




---

  
sorcery.conf  


```

truetext[res_pjsip] 
endpoint=astdb,ps_endpoints
auth=astdb,ps_auths
aor=astdb,ps_aors
domain_alias=astdb,ps_domain_aliases
contact=astdb,ps_contacts
system=astdb,ps_systems

[res_pjsip_endpoint_identifier_ip]
identify=astdb,ps_endpoint_id_ips

[res_pjsip_outbound_registration]
registration=astdb,ps_registrations 

```




!!! warning 
    You **must** configure `sorcery.conf` for this feature to work. The standard data provider Sorcery uses for PJSIP objects is the static configuration file driver. This driver does not support creation, updating, or deletion of objects - which means only the `GET` request will succeed. Any of the following drivers will work to support push configuration:

    * `res_sorcery_memory`
    * `res_sorcery_astdb`
    * `res_sorcery_realtime`
      
[//]: # (end-warning)



Pushing PJSIP Configuration
===========================

This walk-through will show how we can use the `asterisk` resource in ARI to push a PJSIP endpoint into the AstDB, and then later remove the endpoint.

Original PJSIP Configuration
----------------------------

Assume we have the following static PJSIP configuration file that defines an endpoint for Alice:




---

  
pjsip.conf  


```

truetext[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0:5060

[transport-tcp]
type=transport
protocol=tcp
bind=0.0.0.0:5060

[alice]
type=aor
support_path=yes
remove_existing=yes
max_contacts=1

[alice]
type=auth
auth_type=userpass
username=alice
password=secret

[alice]
type=endpoint
from_user=alice
allow=!all,g722,ulaw,alaw
ice_support=yes
force_rport=yes
rewrite_contact=yes
rtp_symmetric=yes
context=default
auth=alice
aors=alice

```


If we then ask Asterisk what endpoints we have, it will show us something like the following:




---

  
Asterisk CLI  


```

\*CLI> pjsip show endpoints
 Endpoint: <Endpoint/CID.....................................> <State.....> <Channels.>
 I/OAuth: <AuthId/UserName...........................................................>
 Aor: <Aor............................................> <MaxContact>
 Contact: <Aor/ContactUri...............................> <Status....> <RTT(ms)..>
 Transport: <TransportId........> <Type> <cos> <tos> <BindAddress..................>
 Identify: <Identify/Endpoint.........................................................>
 Match: <ip/cidr.........................>
 Channel: <ChannelId......................................> <State.....> <Time(sec)>
 Exten: <DialedExten...........> CLCID: <ConnectedLineCID.......>
 =========================================================================================
 Endpoint: alice Unavailable 0 of inf
 InAuth: alice/alice
 Aor: alice 1
\*CLI> 

```


**Our goal is to recreate alice, using ARI.**

New Configuration
-----------------

### PJSIP

Remove Alice from `pjsip.conf`:




---

  
pjsip.conf  


```

truetext[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0:5060

[transport-tcp]
type=transport
protocol=tcp
bind=0.0.0.0:5060


```


### Sorcery

Tell the Sorcery data abstraction framework to pull *endpoint*, *aor*, and *auth* objects from the Asterisk Database:




---

  
sorcery.conf  


```

truetext[res_pjsip]
endpoint=astdb,ps_endpoints
auth=astdb,ps_auths
aor=astdb,ps_aors

```


### Asterisk CLI

Now, if we ask Asterisk for the PJSIP endpoints, it will tell us none are defined:




---

  
Asterisk CLI  


```

text\*CLI> pjsip show endpoints
No objects found.

```


Pushing Configuration
---------------------

First, let's push in Alice's authentication:




```bash title=" " linenums="1"
$ curl -X PUT -H "Content-Type: application/json" -u asterisk:secret -d '{"fields": [ { "attribute": "auth_type", "value": "userpass"}, {"attribute": "username", "value": "alice"}, {"attribute": "password", "value": "secret" } ] }' https://localhost:8088/ari/asterisk/config/dynamic/res_pjsip/auth/alice

[{"attribute":"md5_cred","value":""},{"attribute":"realm","value":""},{"attribute":"auth_type","value":"userpass"},{"attribute":"password","value":"secret"},{"attribute":"nonce_lifetime","value":"32"},{"attribute":"username","value":"alice"}]

```


We can note a few things from this:

1. We supply the non-default values that make up Alice's authentication in the JSON body of the request. The body specifies the "fields" to update, which is a list of attributes to modify on the object we're creating.
2. We don't have to provide default values for the object. This includes the "type" attribute - ARI is smart enough to figure out what that is from the request URI, where we specify that we are creating an "auth" object.
3. When we've created the object successfully, ARI returns back all the attributes that make up that object as a list of attribute/value pairs - even the attributes we didn't specify.

Next, we can push in Alice's AoRs:




```bash title=" " linenums="1"
$ curl -X PUT -H "Content-Type: application/json" -u asterisk:secret -d '{"fields": [ { "attribute": "support_path", "value": "yes"}, {"attribute": "remove_existing", "value": "yes"}, {"attribute": "max_contacts", "value": "1"} ] }' https://localhost:8088/ari/asterisk/config/dynamic/res_pjsip/aor/alice

[{"attribute":"support_path","value":"true"},{"attribute":"default_expiration","value":"3600"},{"attribute":"qualify_timeout","value":"3.000000"},{"attribute":"mailboxes","value":""},{"attribute":"minimum_expiration","value":"60"},{"attribute":"outbound_proxy","value":""},{"attribute":"maximum_expiration","value":"7200"},{"attribute":"qualify_frequency","value":"0"},{"attribute":"authenticate_qualify","value":"false"},{"attribute":"contact","value":""},{"attribute":"max_contacts","value":"1"},{"attribute":"remove_existing","value":"true"}]

```


Finally, we can push in Alice's endpoint:




```bash title=" " linenums="1"
$ curl -X PUT -H "Content-Type: application/json" -u asterisk:secret -d '{"fields": [ { "attribute": "from_user", "value": "alice" }, { "attribute": "allow", "value": "!all,g722,ulaw,alaw"}, {"attribute": "ice_support", "value": "yes"}, {"attribute": "force_rport", "value": "yes"}, {"attribute": "rewrite_contact", "value": "yes"}, {"attribute": "rtp_symmetric", "value": "yes"}, {"attribute": "context", "value": "default" }, {"attribute": "auth", "value": "alice" }, {"attribute": "aors", "value": "alice"} ] }' https://localhost:8088/ari/asterisk/config/dynamic/res_pjsip/endpoint/alice

[{"attribute":"timers_sess_expires","value":"1800"},{"attribute":"device_state_busy_at","value":"0"},{"attribute":"dtls_cipher","value":""},{"attribute":"from_domain","value":""},{"attribute":"dtls_rekey","value":"0"},{"attribute":"dtls_fingerprint","value":"SHA-256"},{"attribute":"direct_media_method","value":"invite"},{"attribute":"send_rpid","value":"false"},{"attribute":"pickup_group","value":""},{"attribute":"sdp_session","value":"Asterisk"},{"attribute":"dtls_verify","value":"No"},{"attribute":"message_context","value":""},{"attribute":"mailboxes","value":""},{"attribute":"named_pickup_group","value":""},{"attribute":"record_on_feature","value":"automixmon"},{"attribute":"dtls_private_key","value":""},{"attribute":"named_call_group","value":""},{"attribute":"t38_udptl_maxdatagram","value":"0"},{"attribute":"media_encryption_optimistic","value":"false"},{"attribute":"aors","value":"alice"},{"attribute":"rpid_immediate","value":"false"},{"attribute":"outbound_proxy","value":""},{"attribute":"identify_by","value":"username"},{"attribute":"inband_progress","value":"false"},{"attribute":"rtp_symmetric","value":"true"},{"attribute":"transport","value":""},{"attribute":"t38_udptl_ec","value":"none"},{"attribute":"fax_detect","value":"false"},{"attribute":"t38_udptl_nat","value":"false"},{"attribute":"allow_transfer","value":"true"},{"attribute":"tos_video","value":"0"},{"attribute":"srtp_tag_32","value":"false"},{"attribute":"timers_min_se","value":"90"},{"attribute":"call_group","value":""},{"attribute":"sub_min_expiry","value":"0"},{"attribute":"100rel","value":"yes"},{"attribute":"direct_media","value":"true"},{"attribute":"g726_non_standard","value":"false"},{"attribute":"dtmf_mode","value":"rfc4733"},{"attribute":"dtls_cert_file","value":""},{"attribute":"media_encryption","value":"no"},{"attribute":"media_use_received_transport","value":"false"},{"attribute":"direct_media_glare_mitigation","value":"none"},{"attribute":"trust_id_inbound","value":"false"},{"attribute":"force_avp","value":"false"},{"attribute":"record_off_feature","value":"automixmon"},{"attribute":"send_diversion","value":"true"},{"attribute":"language","value":""},{"attribute":"mwi_from_user","value":""},{"attribute":"rtp_ipv6","value":"false"},{"attribute":"ice_support","value":"true"},{"attribute":"callerid","value":"<unknown>"},{"attribute":"aggregate_mwi","value":"true"},{"attribute":"one_touch_recording","value":"false"},{"attribute":"moh_passthrough","value":"false"},{"attribute":"cos_video","value":"0"},{"attribute":"accountcode","value":""},{"attribute":"allow","value":"(g722|ulaw|alaw)"},{"attribute":"rewrite_contact","value":"true"},{"attribute":"t38_udptl_ipv6","value":"false"},{"attribute":"tone_zone","value":""},{"attribute":"user_eq_phone","value":"false"},{"attribute":"allow_subscribe","value":"true"},{"attribute":"rtp_engine","value":"asterisk"},{"attribute":"auth","value":"alice"},{"attribute":"from_user","value":"alice"},{"attribute":"disable_direct_media_on_nat","value":"false"},{"attribute":"set_var","value":""},{"attribute":"use_ptime","value":"false"},{"attribute":"outbound_auth","value":""},{"attribute":"media_address","value":""},{"attribute":"tos_audio","value":"0"},{"attribute":"dtls_ca_path","value":""},{"attribute":"dtls_setup","value":"active"},{"attribute":"force_rport","value":"true"},{"attribute":"connected_line_method","value":"invite"},{"attribute":"callerid_tag","value":""},{"attribute":"timers","value":"yes"},{"attribute":"sdp_owner","value":"-"},{"attribute":"trust_id_outbound","value":"false"},{"attribute":"use_avpf","value":"false"},{"attribute":"context","value":"default"},{"attribute":"moh_suggest","value":"default"},{"attribute":"send_pai","value":"false"},{"attribute":"t38_udptl","value":"false"},{"attribute":"dtls_ca_file","value":""},{"attribute":"callerid_privacy","value":"allowed_not_screened"},{"attribute":"cos_audio","value":"0"}]

```


We can now verify that Alice's endpoint exists:




---

  
Asterisk CLI  


```

text\*CLI> pjsip show endpoints
 Endpoint: <Endpoint/CID.....................................> <State.....> <Channels.>
 I/OAuth: <AuthId/UserName...........................................................>
 Aor: <Aor............................................> <MaxContact>
 Contact: <Aor/ContactUri...............................> <Status....> <RTT(ms)..>
 Transport: <TransportId........> <Type> <cos> <tos> <BindAddress..................>
 Identify: <Identify/Endpoint.........................................................>
 Match: <ip/cidr.........................>
 Channel: <ChannelId......................................> <State.....> <Time(sec)>
 Exten: <DialedExten...........> CLCID: <ConnectedLineCID.......>
 =========================================================================================
 Endpoint: alice/unknown Invalid 0 of inf
 InAuth: alice/alice
 Aor: alice 1

```




!!! note Order Matters!
    While ARI itself won't care about the order you create objects in, PJSIP will. A PJSIP endpoint is used to look-up the endpoint's authentication and AoRs. Asterisk and ARI will let you create the endpoint first, referencing an authentication and AoR object that don't yet exist. If an inbound request arrives for that endpoint, the request will be rejected because the endpoint won't be able to find the authentication or store the Contact on a REGISTER request! By creating things in the order that we did, we can guarantee that everything will be in place when the endpoint is instantiated.

      
[//]: # (end-note)



We can also verify that Alice exists in the AstDB:




---

  
Asterisk CLI  


```

text\*CLI> database show
/ps_aors/aor/alice : {"qualify_frequency":"0","maximum_expiration":"7200","minimum_expiration":"60","qualify_timeout":"3.000000","support_path":"true","default_expiration":"3600","mailboxes":"","authenticate_qualify":"false","outbound_proxy":"","max_contacts":"1","remove_existing":"true"}
/ps_auths/auth/alice : {"realm":"","md5_cred":"","nonce_lifetime":"32","auth_type":"userpass","password":"secret","username":"alice"}
/ps_endpoints/endpoint/alice : {"send_diversion":"true","device_state_busy_at":"0","direct_media_method":"invite","sdp_owner":"-","pickup_group":"","timers_sess_expires":"1800","message_context":"","accountcode":"","dtls_fingerprint":"SHA-256","rpid_immediate":"false","force_avp":"false","aors":"alice","trust_id_inbound":"false","ice_support":"true","fax_detect":"false","outbound_proxy":"","t38_udptl_maxdatagram":"0","direct_media_glare_mitigation":"none","dtls_rekey":"0","context":"default","media_encryption_optimistic":"false","named_pickup_group":"","from_domain":"","mailboxes":"","sdp_session":"Asterisk","cos_video":"0","identify_by":"username","t38_udptl":"false","send_rpid":"false","rtp_engine":"asterisk","t38_udptl_ec":"none","dtls_verify":"No","aggregate_mwi":"true","moh_suggest":"default","media_encryption":"no","callerid":"<unknown>","named_call_group":"","record_on_feature":"automixmon","dtls_setup":"active","inband_progress":"false","timers_min_se":"90","tos_video":"0","rtp_symmetric":"true","rtp_ipv6":"false","transport":"","t38_udptl_nat":"false","connected_line_method":"invite","allow_transfer":"true","allow_subscribe":"true","srtp_tag_32":"false","g726_non_standard":"false","100rel":"yes","use_avpf":"false","call_group":"","moh_passthrough":"false","user_eq_phone":"false","allow":"(g722|ulaw|alaw)","sub_min_expiry":"0","force_rport":"true","direct_media":"true","dtmf_mode":"rfc4733","media_use_received_transport":"false","record_off_feature":"automixmon","language":"","mwi_from_user":"","one_touch_recording":"false","rewrite_contact":"true","cos_audio":"0","t38_udptl_ipv6":"false","trust_id_outbound":"false","tone_zone":"","auth":"alice","from_user":"alice","disable_direct_media_on_nat":"false","tos_audio":"0","use_ptime":"false","media_address":"","timers":"yes","send_pai":"false","callerid_privacy":"allowed_not_screened"}
3 results found.
\*CLI> 

```


Deleting Configuration
----------------------

If we no longer want Alice to have an endpoint, we can remove it and its related objects using the `DELETE` operation:




```bash title=" " linenums="1"
$ curl -X DELETE -u asterisk:secret https://localhost:8088/ari/asterisk/config/dynamic/res_pjsip/endpoint/alice
$ curl -X DELETE -u asterisk:secret https://localhost:8088/ari/asterisk/config/dynamic/res_pjsip/aor/alice
$ curl -X DELETE -u asterisk:secret https://localhost:8088/ari/asterisk/config/dynamic/res_pjsip/auth/alice

```


And we can confirm that Alice no longer exists:




---

  
Asterisk CLI  


```

text\*CLI> pjsip show endpoints
No objects found.
\*CLI> database show
0 results found.
\*CLI>  

```




!!! note Order Matters!
    Note that we remove Alice in reverse order of how her endpoint was created - we first remove the endpoint, then its related objects. Once the endpoint is removed, further requests will no longer be serviced, which allows us to safely remove the auth and aor objects.

      
[//]: # (end-note)



 

 

