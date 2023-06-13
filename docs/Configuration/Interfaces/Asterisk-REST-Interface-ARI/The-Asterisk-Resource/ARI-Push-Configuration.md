---
title: ARI Push Configuration
pageid: 32375922
---

Overview
========

Asterisk typically retrieves its configuration information by *pulling* it from some configuration source - whether that be a static configuration file or a relational database. This page describes an alternative way to provide configuration information to Asterisk using a *push* model through ARI. Note that only modules whose configuration is managed by the  data abstraction framework in Asterisk can make use of this mechanism. Predominately, this implies configuration of the PJSIP stack.

 

On This PageVersion InformationThis feature was introduced in ARI version 1.8.0, or Asterisk 13.5.0 or later.

Push Configuration Workflow
===========================

ARI Push Configuration

With push configuration, an external process uses ARI to perform a configuration operation. The configuration operation could be any one of the four classic operations for persistent storage - [Create, Retrieve, Update, or Delete](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete). For the purposes of this workflow, we'll assume that the operation is to create a configuration change in Asterisk.

The ARI client makes a `PUT` request, where the body contains the configuration object to create, encoded in JSON. This is first handled by ARI, which performs basic validation on the inbound request and its contents. Once the request is validated, ARI asks the Sorcery framework to create the actual object.

Sorcery requires three pieces of information, at a minimum, to create an object:

* The overall class of configuration types. This is usually a module or namespace that provides multiple types of objects to be created, e.g., 'res\_pjsip'.
* The type of configuration object to create, e.g., 'endpoint'.
* A unique identifier (amongst objects of the same type) for the object, e.g., 'alice'.

Once Sorcery has determined that it knows how to create the type of object, it creates it using the provided data in the JSON body. If some piece of data in the body can't be converted to an attribute on the object, the inbound request is rejected.

If the object is created successfully, Sorcery then has to determine what to do with it. While we've just had a piece of configuration pushed to Asterisk, Sorcery is responsible for storing it in some permanent - or semi-permanent - storage. For this, it looks to its configuration in `sorcery.conf`. We'll assume that our object should be created in the AstDB, a SQLite database. In that case, Asterisk pushes the newly created object to `res_sorcery_astdb`, which is the Sorcery driver for the AstDB. This module then writes the information to the SQLite database.

When the PJSIP stack next needs the object - such as when an `INVITE` request is received that maps to Alice's endpoint - it queries Sorcery for the object. At this point, from Sorcery's perspective, the retrieval of the configuration information is exactly the same as if a static configuration file or a relational database was providing the information, and it returns the pushed configuration information.

Asterisk Configuration
======================

To make use of push configuration, you **must** configure Sorcery to persist the pushed configuration somewhere. If you don't want the information to persist beyond reloads, you can use the in-memory Sorcery driver, `res_sorcery_memory`. The example below assumes that we will push configuration to the PJSIP stack, and that we want information to persist even if Asterisk is restarted. For that reason, we'll use the AstDB.

sorcery.conftruetext[res\_pjsip] 
endpoint=astdb,ps\_endpoints
auth=astdb,ps\_auths
aor=astdb,ps\_aors
domain\_alias=astdb,ps\_domain\_aliases
contact=astdb,ps\_contacts
system=astdb,ps\_systems

[res\_pjsip\_endpoint\_identifier\_ip]
identify=astdb,ps\_endpoint\_id\_ips

[res\_pjsip\_outbound\_registration]
registration=astdb,ps\_registrations You **must** configure `sorcery.conf` for this feature to work. The standard data provider Sorcery uses for PJSIP objects is the static configuration file driver. This driver does not support creation, updating, or deletion of objects - which means only the `GET` request will succeed. Any of the following drivers will work to support push configuration:

* `res_sorcery_memory`
* `res_sorcery_astdb`
* `res_sorcery_realtime`
Pushing PJSIP Configuration
===========================

This walk-through will show how we can use the `asterisk` resource in ARI to push a PJSIP endpoint into the AstDB, and then later remove the endpoint.

Original PJSIP Configuration
----------------------------

Assume we have the following static PJSIP configuration file that defines an endpoint for Alice:

pjsip.conftruetext[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0:5060

[transport-tcp]
type=transport
protocol=tcp
bind=0.0.0.0:5060

[alice]
type=aor
support\_path=yes
remove\_existing=yes
max\_contacts=1

[alice]
type=auth
auth\_type=userpass
username=alice
password=secret

[alice]
type=endpoint
from\_user=alice
allow=!all,g722,ulaw,alaw
ice\_support=yes
force\_rport=yes
rewrite\_contact=yes
rtp\_symmetric=yes
context=default
auth=alice
aors=aliceIf we then ask Asterisk what endpoints we have, it will show us something like the following:

Asterisk CLI\*CLI> pjsip show endpoints
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
\*CLI> **Our goal is to recreate alice, using ARI.**

New Configuration
-----------------

### PJSIP

Remove Alice from `pjsip.conf`:

pjsip.conftruetext[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0:5060

[transport-tcp]
type=transport
protocol=tcp
bind=0.0.0.0:5060
### Sorcery

Tell the Sorcery data abstraction framework to pull *endpoint*, *aor*, and *auth* objects from the Asterisk Database:

sorcery.conftruetext[res\_pjsip]
endpoint=astdb,ps\_endpoints
auth=astdb,ps\_auths
aor=astdb,ps\_aors### Asterisk CLI

Now, if we ask Asterisk for the PJSIP endpoints, it will tell us none are defined:

Asterisk CLItext\*CLI> pjsip show endpoints
No objects found.Pushing Configuration
---------------------

First, let's push in Alice's authentication:

$ curl -X PUT -H "Content-Type: application/json" -u asterisk:secret -d '{"fields": [ { "attribute": "auth\_type", "value": "userpass"}, {"attribute": "username", "value": "alice"}, {"attribute": "password", "value": "secret" } ] }' https://localhost:8088/ari/asterisk/config/dynamic/res\_pjsip/auth/alice

[{"attribute":"md5\_cred","value":""},{"attribute":"realm","value":""},{"attribute":"auth\_type","value":"userpass"},{"attribute":"password","value":"secret"},{"attribute":"nonce\_lifetime","value":"32"},{"attribute":"username","value":"alice"}]We can note a few things from this:

1. We supply the non-default values that make up Alice's authentication in the JSON body of the request. The body specifies the "fields" to update, which is a list of attributes to modify on the object we're creating.
2. We don't have to provide default values for the object. This includes the "type" attribute - ARI is smart enough to figure out what that is from the request URI, where we specify that we are creating an "auth" object.
3. When we've created the object successfully, ARI returns back all the attributes that make up that object as a list of attribute/value pairs - even the attributes we didn't specify.

Next, we can push in Alice's AoRs:

$ curl -X PUT -H "Content-Type: application/json" -u asterisk:secret -d '{"fields": [ { "attribute": "support\_path", "value": "yes"}, {"attribute": "remove\_existing", "value": "yes"}, {"attribute": "max\_contacts", "value": "1"} ] }' https://localhost:8088/ari/asterisk/config/dynamic/res\_pjsip/aor/alice

[{"attribute":"support\_path","value":"true"},{"attribute":"default\_expiration","value":"3600"},{"attribute":"qualify\_timeout","value":"3.000000"},{"attribute":"mailboxes","value":""},{"attribute":"minimum\_expiration","value":"60"},{"attribute":"outbound\_proxy","value":""},{"attribute":"maximum\_expiration","value":"7200"},{"attribute":"qualify\_frequency","value":"0"},{"attribute":"authenticate\_qualify","value":"false"},{"attribute":"contact","value":""},{"attribute":"max\_contacts","value":"1"},{"attribute":"remove\_existing","value":"true"}]Finally, we can push in Alice's endpoint:

$ curl -X PUT -H "Content-Type: application/json" -u asterisk:secret -d '{"fields": [ { "attribute": "from\_user", "value": "alice" }, { "attribute": "allow", "value": "!all,g722,ulaw,alaw"}, {"attribute": "ice\_support", "value": "yes"}, {"attribute": "force\_rport", "value": "yes"}, {"attribute": "rewrite\_contact", "value": "yes"}, {"attribute": "rtp\_symmetric", "value": "yes"}, {"attribute": "context", "value": "default" }, {"attribute": "auth", "value": "alice" }, {"attribute": "aors", "value": "alice"} ] }' https://localhost:8088/ari/asterisk/config/dynamic/res\_pjsip/endpoint/alice

[{"attribute":"timers\_sess\_expires","value":"1800"},{"attribute":"device\_state\_busy\_at","value":"0"},{"attribute":"dtls\_cipher","value":""},{"attribute":"from\_domain","value":""},{"attribute":"dtls\_rekey","value":"0"},{"attribute":"dtls\_fingerprint","value":"SHA-256"},{"attribute":"direct\_media\_method","value":"invite"},{"attribute":"send\_rpid","value":"false"},{"attribute":"pickup\_group","value":""},{"attribute":"sdp\_session","value":"Asterisk"},{"attribute":"dtls\_verify","value":"No"},{"attribute":"message\_context","value":""},{"attribute":"mailboxes","value":""},{"attribute":"named\_pickup\_group","value":""},{"attribute":"record\_on\_feature","value":"automixmon"},{"attribute":"dtls\_private\_key","value":""},{"attribute":"named\_call\_group","value":""},{"attribute":"t38\_udptl\_maxdatagram","value":"0"},{"attribute":"media\_encryption\_optimistic","value":"false"},{"attribute":"aors","value":"alice"},{"attribute":"rpid\_immediate","value":"false"},{"attribute":"outbound\_proxy","value":""},{"attribute":"identify\_by","value":"username"},{"attribute":"inband\_progress","value":"false"},{"attribute":"rtp\_symmetric","value":"true"},{"attribute":"transport","value":""},{"attribute":"t38\_udptl\_ec","value":"none"},{"attribute":"fax\_detect","value":"false"},{"attribute":"t38\_udptl\_nat","value":"false"},{"attribute":"allow\_transfer","value":"true"},{"attribute":"tos\_video","value":"0"},{"attribute":"srtp\_tag\_32","value":"false"},{"attribute":"timers\_min\_se","value":"90"},{"attribute":"call\_group","value":""},{"attribute":"sub\_min\_expiry","value":"0"},{"attribute":"100rel","value":"yes"},{"attribute":"direct\_media","value":"true"},{"attribute":"g726\_non\_standard","value":"false"},{"attribute":"dtmf\_mode","value":"rfc4733"},{"attribute":"dtls\_cert\_file","value":""},{"attribute":"media\_encryption","value":"no"},{"attribute":"media\_use\_received\_transport","value":"false"},{"attribute":"direct\_media\_glare\_mitigation","value":"none"},{"attribute":"trust\_id\_inbound","value":"false"},{"attribute":"force\_avp","value":"false"},{"attribute":"record\_off\_feature","value":"automixmon"},{"attribute":"send\_diversion","value":"true"},{"attribute":"language","value":""},{"attribute":"mwi\_from\_user","value":""},{"attribute":"rtp\_ipv6","value":"false"},{"attribute":"ice\_support","value":"true"},{"attribute":"callerid","value":"<unknown>"},{"attribute":"aggregate\_mwi","value":"true"},{"attribute":"one\_touch\_recording","value":"false"},{"attribute":"moh\_passthrough","value":"false"},{"attribute":"cos\_video","value":"0"},{"attribute":"accountcode","value":""},{"attribute":"allow","value":"(g722|ulaw|alaw)"},{"attribute":"rewrite\_contact","value":"true"},{"attribute":"t38\_udptl\_ipv6","value":"false"},{"attribute":"tone\_zone","value":""},{"attribute":"user\_eq\_phone","value":"false"},{"attribute":"allow\_subscribe","value":"true"},{"attribute":"rtp\_engine","value":"asterisk"},{"attribute":"auth","value":"alice"},{"attribute":"from\_user","value":"alice"},{"attribute":"disable\_direct\_media\_on\_nat","value":"false"},{"attribute":"set\_var","value":""},{"attribute":"use\_ptime","value":"false"},{"attribute":"outbound\_auth","value":""},{"attribute":"media\_address","value":""},{"attribute":"tos\_audio","value":"0"},{"attribute":"dtls\_ca\_path","value":""},{"attribute":"dtls\_setup","value":"active"},{"attribute":"force\_rport","value":"true"},{"attribute":"connected\_line\_method","value":"invite"},{"attribute":"callerid\_tag","value":""},{"attribute":"timers","value":"yes"},{"attribute":"sdp\_owner","value":"-"},{"attribute":"trust\_id\_outbound","value":"false"},{"attribute":"use\_avpf","value":"false"},{"attribute":"context","value":"default"},{"attribute":"moh\_suggest","value":"default"},{"attribute":"send\_pai","value":"false"},{"attribute":"t38\_udptl","value":"false"},{"attribute":"dtls\_ca\_file","value":""},{"attribute":"callerid\_privacy","value":"allowed\_not\_screened"},{"attribute":"cos\_audio","value":"0"}]We can now verify that Alice's endpoint exists:

Asterisk CLItext\*CLI> pjsip show endpoints
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
 Aor: alice 1Order Matters! While ARI itself won't care about the order you create objects in, PJSIP will. A PJSIP endpoint is used to look-up the endpoint's authentication and AoRs. Asterisk and ARI will let you create the endpoint first, referencing an authentication and AoR object that don't yet exist. If an inbound request arrives for that endpoint, the request will be rejected because the endpoint won't be able to find the authentication or store the Contact on a REGISTER request! By creating things in the order that we did, we can guarantee that everything will be in place when the endpoint is instantiated.

We can also verify that Alice exists in the AstDB:

Asterisk CLItext\*CLI> database show
/ps\_aors/aor/alice : {"qualify\_frequency":"0","maximum\_expiration":"7200","minimum\_expiration":"60","qualify\_timeout":"3.000000","support\_path":"true","default\_expiration":"3600","mailboxes":"","authenticate\_qualify":"false","outbound\_proxy":"","max\_contacts":"1","remove\_existing":"true"}
/ps\_auths/auth/alice : {"realm":"","md5\_cred":"","nonce\_lifetime":"32","auth\_type":"userpass","password":"secret","username":"alice"}
/ps\_endpoints/endpoint/alice : {"send\_diversion":"true","device\_state\_busy\_at":"0","direct\_media\_method":"invite","sdp\_owner":"-","pickup\_group":"","timers\_sess\_expires":"1800","message\_context":"","accountcode":"","dtls\_fingerprint":"SHA-256","rpid\_immediate":"false","force\_avp":"false","aors":"alice","trust\_id\_inbound":"false","ice\_support":"true","fax\_detect":"false","outbound\_proxy":"","t38\_udptl\_maxdatagram":"0","direct\_media\_glare\_mitigation":"none","dtls\_rekey":"0","context":"default","media\_encryption\_optimistic":"false","named\_pickup\_group":"","from\_domain":"","mailboxes":"","sdp\_session":"Asterisk","cos\_video":"0","identify\_by":"username","t38\_udptl":"false","send\_rpid":"false","rtp\_engine":"asterisk","t38\_udptl\_ec":"none","dtls\_verify":"No","aggregate\_mwi":"true","moh\_suggest":"default","media\_encryption":"no","callerid":"<unknown>","named\_call\_group":"","record\_on\_feature":"automixmon","dtls\_setup":"active","inband\_progress":"false","timers\_min\_se":"90","tos\_video":"0","rtp\_symmetric":"true","rtp\_ipv6":"false","transport":"","t38\_udptl\_nat":"false","connected\_line\_method":"invite","allow\_transfer":"true","allow\_subscribe":"true","srtp\_tag\_32":"false","g726\_non\_standard":"false","100rel":"yes","use\_avpf":"false","call\_group":"","moh\_passthrough":"false","user\_eq\_phone":"false","allow":"(g722|ulaw|alaw)","sub\_min\_expiry":"0","force\_rport":"true","direct\_media":"true","dtmf\_mode":"rfc4733","media\_use\_received\_transport":"false","record\_off\_feature":"automixmon","language":"","mwi\_from\_user":"","one\_touch\_recording":"false","rewrite\_contact":"true","cos\_audio":"0","t38\_udptl\_ipv6":"false","trust\_id\_outbound":"false","tone\_zone":"","auth":"alice","from\_user":"alice","disable\_direct\_media\_on\_nat":"false","tos\_audio":"0","use\_ptime":"false","media\_address":"","timers":"yes","send\_pai":"false","callerid\_privacy":"allowed\_not\_screened"}
3 results found.
\*CLI> Deleting Configuration
----------------------

If we no longer want Alice to have an endpoint, we can remove it and its related objects using the `DELETE` operation:

$ curl -X DELETE -u asterisk:secret https://localhost:8088/ari/asterisk/config/dynamic/res\_pjsip/endpoint/alice
$ curl -X DELETE -u asterisk:secret https://localhost:8088/ari/asterisk/config/dynamic/res\_pjsip/aor/alice
$ curl -X DELETE -u asterisk:secret https://localhost:8088/ari/asterisk/config/dynamic/res\_pjsip/auth/aliceAnd we can confirm that Alice no longer exists:

Asterisk CLItext\*CLI> pjsip show endpoints
No objects found.
\*CLI> database show
0 results found.
\*CLI>  Order Matters! Note that we remove Alice in reverse order of how her endpoint was created - we first remove the endpoint, then its related objects. Once the endpoint is removed, further requests will no longer be serviced, which allows us to safely remove the auth and aor objects.

 

 

