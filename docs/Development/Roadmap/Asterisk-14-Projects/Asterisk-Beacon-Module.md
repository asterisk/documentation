---
title: Asterisk Beacon Module
pageid: 32375459
---

Background
==========

The Asterisk project has been downloaded millions of times, in hundreds of different versions and distributions. A subset of this large number of downloads represents the number of deployed and operational Asterisk instances. Certain specifics of these operational systems are invaluable bits of information for developers maintaining the Asterisk project. With knowledge of these specifics, the Asterisk development team can better prioritize its efforts towards new feature development, bug-fixes and software releases.

Assumptions
===========

1. The module in question will be called `res_beacon`.
2. The module will be targeted at Asterisk versions 11, 13, and master. Some implementation differences will have to occur in the various versions.
3. All communication will occur using encrypted transports.
4. The communication protocol will be backwards compatible between all versions of Asterisk. Things may be added to the protocol between Asterisk versions, but not removed.
On This PageProtocol
========

Asterisk will communicate with the server using `HTTPS` to a REST API. Due to the sensitive nature of the data being transmitted, HTTP will not be supported. The specifics of the REST API will be published using Swagger such that other implementations may be developed for personal use.

User Authentication
-------------------

Since the purpose of Beacon is to collect anonymous usage statistics, no authentication will be provided. Asterisk systems will initially request a server ID from the API. The server ID maps to a resource that will be used for all subsequent requests.

### Spoofing

In order to limit spoofing, the server will return a token for all accepted requests to a server. Any subsequent requests to that resource must present the token in the request. If a subsequent request fails to provide the token, the request is rejected. Tokens expire after 48 hours, at which point, a request does not have to provide a token. If a request does provide a token that is expired - and no token is required at that point - the request should be accepted and a new token granted. Once a request is made without a token (and no token is expected), a new token is issued for subsequent requests.

So long as Asterisk's transmission of data occurs faster than once every 48 hours, a malicious entity will not be able to spoof a resource. If a system is down then a remote system can 'take over' a system, and the legitimate system's attempts will be rejected. If that occurs... oh well. It is anonymous data.

### Spamming

In order to prevent spamming with false data, the server should rate limit inbound requests.

Swagger Definition
------------------

```json title="resources.json" linenums="1"
{
 "apiVersion": "1.0.0",
 "swaggerVersion": "1.2",
 "apis": [
 {
 "path": "/servers",
 "description": "Asterisk servers"
 }
 ]
}

```
```json title="beacon.json" linenums="1"
{
 "apiVersion": "1.0.0",
 "swaggerVersion": "1.2",
 "basePath": "https://beacon.asterisk.org:443"
 "resourcePath": "/servers"
 "apis": [
 {
 "path": "/servers"
 "operations": [
 {
 "method": "POST",
 "summary": "Request a new server ID",
 "notes": "This allocates a new server token and returns it to the user for subsequent requests."
 "nickname": "requestServer",
 "type": "ServerToken",
 "parameters": [
 ],
 "responseMessages": [
 {
 "code": 409,
 "message": "Server already exists"
 }
 ]
 }
 ],

 },
 {
 "path": "/servers/{server}"
 "operations": [
 {
 "method": "PUT",
 "summary": "Update a server",
 "notes": "Upon updating a server, a token is returned. If not provided on a subsequent update, the request is rejected. Tokens expire after 48 hours."
 "nickname": "updateServer",
 "type": "Token",
 "parameters": [
 {
 "name": "serverId",
 "description": "The unique ID of the server. Must be a v4 UUID."
 "paramType": "path",
 "required": true,
 "allowMultiple": false,
 "type": "string"
 },
 {
 "name": "tokenId",
 "description": "The current server token."
 "paramType": "query",
 "required": false,
 "allowMultiple": false,
 "type": "string"
 },
 {
 "name": "body",
 "description": "Properties of the server."
 "paramType": "body",
 "required": true,
 "allowMultiple": false,
 "type": "Server"
 },
 ],
 "responseMessages": [
 {
 "code": 400,
 "message": "Invalid parameters for updating a server"
 },
 {
 "code": 401,
 "message": "Invalid token provided"
 }
 ]
 }
 ]
 }
 ],
 "models": {
 "Token": {
 "id": "Token",
 "description": "A time-based token that authorizes a server for a particular resource",
 "required": [
 "id",
 "issued"
 ],
 "properties": {
 "id": {
 "type": "string",
 "description": "UUID uniquely identifying the token"
 },
 "issued": {
 "type": "string",
 "format": "date-time",
 "description": "Timestamp when the token was issued"
 },
 }
 },
 "RunTimeStats": {
 "id": "RunTimeStats",
 "description": "Running time statistics for an Asterisk instance",
 "required": [
 ],
 "properties": {
 "startup_time": {
 "type": "string",
 "format": "date-time",
 "description": "When this instance was started"
 },
 "last_reload_time": {
 "type": "string",
 "format": "date-time",
 "description": "When this instance was last reloaded"
 }
 }
 },
 "CallStats": {
 "id": "CallStats",
 "description": "Running time statistics for an Asterisk instance",
 "required": [
 ],
 "properties": {
 "active": {
 "type": "integer",
 "format": "int32",
 "description": "Number of active calls"
 },
 "processed": {
 "type": "integer",
 "format": "int32",
 "description": "Number of processed calls"
 }
 }
 },
 "AsteriskStats": {
 "id": "AsteriskStats",
 "description": "Statistics for a running instance of Asterisk",
 "required": [
 ],
 "properties": {
 "run_time": {
 "$ref": "RunTimeStats",
 "description": "Statistics on how long Asterisk has been running"
 },
 "calls": {
 "$ref": "CallStats",
 "description": "Statistics on the number of calls processed"
 }
 }
 }
 "AsteriskModule": {
 "id": "AsteriskModule",
 "description": "An Asterisk module",
 "required": [
 "name",
 "description",
 "status"
 ],
 "properties": {
 "name": {
 "type": "string",
 "description": "The name of the module"
 },
 "description": {
 "type": "string",
 "description": "A description of the module"
 },
 "status": {
 "type": "string",
 "description": "The current state of the module"
 },
 "support_level": {
 "type": "string",
 "description": "The support level of the module"
 }
 }
 },
 "AsteriskVersion": {
 "id": "AsteriskVersion",
 "description": "The version of an instance of Asterisk",
 "required": [
 "name",
 "number"
 ],
 "properties": {
 "name": {
 "type": "string",
 "description": "The textual description of the Asterisk version"
 },
 "number": {
 "type": "string",
 "description": "A derived numeric version of the Major.Minor.Patch value of the Asterisk version"
 },
 }
 },
 "Asterisk": {
 "id": "Asterisk",
 "description": "Information about a running instance of Asterisk",
 "required": [
 "version"
 ],
 "properties": {
 "version": {
 "$ref": "AsteriskVersion",
 "description": "The version of Asterisk"
 },
 "modules": {
 "type": "array",
 "items": {
 "$ref": "AsteriskModule"
 },
 "description": "The loaded modules"
 },
 "stats": {
 "$ref": "AsteriskStats",
 "description": "Statistics about the Asterisk instance"
 }
 }
 },
 "OperatingSystem": {
 "id": "OperatingSystem",
 "description": "Information about the machine OS. Note that this is likely only to have meaning on Linux distros",
 "required": [
 ],
 "properties": {
 "sys_name": {
 "type": "string",
 "description": "The system name, e.g., Linux"
 },
 "release": {
 "type": "string",
 "description": "The OS release, e.g., 3.13.0-24-generic"
 },
 "version": {
 "type": "string",
 "description": "The OS version, e.g., #47-Ubuntu SMP Fri May 2 23:30:00 UTC 2014"
 },
 "machine": {
 "type": "string",
 "description": "The machine hardware identifier, e.g., x86_64"
 }
 }
 },
 "Server": {
 "id": "Server",
 "description": "Information regarding a server",
 "required": [
 "id"
 ],
 "properties": {
 "id": {
 "type": "string",
 "description": "UUID uniquely identifying the server"
 },
 "asterisk": {
 "$ref": "Asterisk",
 "description": "Information about Asterisk"
 },
 "operating_system": {
 "$ref": "OperatingSystem",
 "description": "Information about the system OS"
 },
 "private_name": {
 "type": "string",
 "description": "A name for the server that is never displayed on the Asterisk Beacon server. It is provided via configuration for custom use."
 }
  }
 },
 "ServerToken": {
 "id": "ServerToken",
 "description": "A server and a token for the subsequent request that updates the server",
 "required": [
 "token",
 "server"
 ],
 "properties": {
 "token": {
 "$ref": "Token",
 "description": "The token that has just been issued"
 },
 "server": {
 "$ref": "Server",
 "description": "The server that the token is for"
 }
 }
 }
 }
}

```

Example Request/Responses
-------------------------

### Client Server Request

In this example, a client requests a new server from the Asterisk Beacon. It is handed back a new token to use for subsequent requests, which is valid for 48 hours after issuance. It is also handed back the ID of the server to use.

Note that the Server object is used for this; however, as only the `id` field is mandatory, that is what is provided. A client **should** provide more information back - but a server implementation should be tolerant of missing optional fields.

```
POST https://beacon.asterisk.org:443/servers

Response: 200 OK
{
 "token": { "id": "ca74af9d-260c-4764-b452-e0628a9468a9", "issue": "Mon Dec 29 2014 15:37:18 UTC" },
 "server": { "id": "bc5829cc-4584-43e5-8395-a9b1206d7e02" }
}

```

### Client Server Update

In this example, the client uses the previously obtained token/server ID to issue a new request.

Note that the server hands back the same token as was provided. It is up to the server to generate a new token at the appropriate time.

```
PUT https://beacon.asterisk.org:80/servers/bc5829cc-4584-43e5-8395-a9b1206d7e02?tokenId=ca74af9d-260c-4764-b452-e0628a9468a9
{
 "id": "bc5829cc-4584-43e5-8395-a9b1206d7e02",
 "asterisk": {
 "version": {
 "name": "Asterisk 13-GIT-a18hf7lq",
 "number": "11300"
 },
 "modules": [
 {
 "name": "res_pjsip.so",
 "description": "Basic SIP resource",
 "status": "Running",
 "support_level": "core"
 },
 ...
 ],
 "stats": {
 "run_time":
 {
 startup_time: "23:00:00 UTC 2014",
 last_reload_time: "23:10:00 UTC 2014"
 },
 "calls":
 {
 "active": 2
 "processed": 1238
 }
 }
 },
 "operating_system": {
 "sys_name": "Linux",
 "release": "3.13.0-24-generic",
 "version": "#47-Ubuntu SMP Fri May 2 23:30:00 UTC 2014",
 "machine": "x86_64"
 }
}

```

Client: res_beacon
===================

Asterisk shall have a new resource module, `res_beacon`. As a user of `cURL`, `res_beacon` will depend on the `cURL` library and the `res_curl` module.

!!! info ""
    Yes. This means that if a system doesn't have `cURL` on it, we won't get its stats. That beats doing something silly like rolling our own transport.

[//]: # (end-info)

The module will be able to send data to both the Asterisk Beacon server (hard coded, can't change or remove without re-compiling) as well as any configurable number of other servers. Those other servers allow a user to set up their own instance of the publicly defined API and collect their own statistics themselves.

The minimum value for reporting interval to beacon.asterisk.org should be 60 minutes.  Any user input values smaller than that should be rounded to 60.

Dev-Mode
--------

Asterisk runs a lot under the Test Suite. When it does so, it is sandboxed, and hence can't reuse a 'test server ID' or test token. What's more, as an open source module, we should not just hardcode a 'test ID' into the module.

When compiled under `-dev-mode`, `res_beacon` should disable sending to the Asterisk Beacon URI. It should still support sending to an alternate server, which should be adequate for the vast majority of CI testing.

Persistence
-----------

`res_beacon` shall add a new family to the AstDB, "/beacon."  This family should contain:

* The Server ID
* The current token ID

If Asterisk attempts to use a cached server ID and token and it is rejected with a 401, a new server ID should be obtained.

Logging Notification
--------------------

When logging is enabled, the CLI will display - as the last thing that is displayed before the "Asterisk Ready" prompt - a message that Asterisk is logging. This should be displayed on the CLI in suitably garish and annoying colors:

```
[Dec 29 16:10:59] NOTICE[13489]: app_queue.c:8885 reload_queues: No call queueing config file (queues.conf), so no call queues
 Loading res_manager_devicestate.so.
 == Manager registered action DeviceStateList
 == res_manager_devicestate.so => (Manager Device State Topic Forwarder)
 Loading res_manager_presencestate.so.
 == Manager registered action PresenceStateList
 == res_manager_presencestate.so => (Manager Presence State Topic Forwarder)
 Asterisk Malloc Debugger Started (see /var/log/asterisk/mmlog))
[Dec 29 16:10:59] NOTICE[13489]: res_beacon.c:103 load_module: <<< <<< <<< ANONYMOUS USAGE STATISTICS ENABLED >>> >>> >>>
Asterisk Ready.
\*CLI>

```

Configuration
-------------

Configuration shall be provided by `res_beacon.conf`.

| Category | Option | Data type | Default | Description |
| --- | --- | --- | --- | --- |
| ^general$ | WHITELIST |  |  | Settings that apply to all servers |
|  | enabled | Boolean | True | Enable/disable sending to all servers |
|  | private_name | String |  | Name of the system to send in reports. This is not shown on the Beacon server. |
| ^beacon$ | WHITELIST |  |  | Settings that apply to the Asterisk beacon server |
|  | proxy | String |  | Set an optional user:pass@proxy to use |
|  | interval | Int32 | 360 | How often, in minutes, to send a report, minimum 60 |
|  | start_time | Time | 00:00 | When to start sending reports |
| ^general$|^beacon$ | BLACKLIST |  |  |  |
|  | type | String |  | Must be server |
|  | proxy | String |  | Set an optional user:pass@proxy to use |
|  | interval | Int32 | 360 | How often, in minutes, to send a report |
|  | start_time | Time | 00:00 | When to start sending reports |
|  | verify_cert | Boolean | True | Whether or not to verify the server certificates. |
|  | ca_path | String |  | Location of client certificates to use for the server. |

### Example

```
[general]
enabled = True
private_name = My awesome server

[beacon]
interval = 180
start_time = 12:00

[awesome_stats_server]
type = server
proxy = https://batman:rocks@awesome_stats_server.mydomain.com/beacon
verify_cert = false

```

CLI Commands
------------

### beacon show server

Display the gathered information about the server. This should show what we would send in a server update request.

```
 \*CLI> beacon show server

Server ID: bc5829cc-4584-43e5-8395-a9b1206d7e02
Token:
 ID: ca74af9d-260c-4764-b452-e0628a9468a9
 Issued: Mon Dec 29 2014 15:37:18 UTC
Last Posting: Mon Dec 2014 15:37:18 UTC
Next Posting: Mon Dec 2014 21:37:18 UTC
Asterisk Information:
 Version: Asterisk SVN-branch-13-r430034 (11300)
 Stats:
 Run-time:
 Started at: Mon Dec 29 2014 15:37:18 UTC
 Running for: 10 minutes
 Last reload time: Mon Dec 29 2014 15:37:18 UTC
 Calls:
 Active: 0
 Processed: 1238
 Module:
 ... (laundry list)
Operating System:
 Linux 3.13.0-24-generic #47-Ubuntu SMP Fri May 2 23:30:00 UTC 2014 x86_64

```

### beacon show configuration

Display our configuration data.

AMI Actions
-----------

### BeaconShowServer

Note that the date/time format may be different than what is displayed below. This is for informational purposes only.

Since multiple modules can be returned, the AMI response should increase the 'count' of the header.

```
Action: BeaconShowServer
ActionId: 12345

Event: BeaconShowServerResponse
ActionId: 12345
ServerId: bc5829cc-4584-43e5-8395-a9b1206d7e02
TokenId: ca74af9d-260c-4764-b452-e0628a9468a9
TokenIssuedDate: Mon Dec 29 2014 15:37:18 UTC
LastPosting: Mon Dec 29 2014 15:37:18 UTC
NextPosting: Mon Dec 29 2014 21:37:18 UTC
Module0Name: res_pjsip.so
Module0Description: Basic SIP resource
Module0Status: Running
Module0SupportLevel: core
...
StartupTime: 23:00:00 UTC 2014
LastReloadTime: 23:10:00 UTC 2014
ActiveCalls: 2
ProcessedCalls: 1238
OperatingSystemName: Linux
OperatingSystemRelease: 3.13.0-24-generic
OperatingSystemVersion: #47-Ubuntu SMP Fri May 2 23:30:00 UTC 2014
OperatingSystemMachine: x86_64

```

ARI Resources (13+)
-------------------

A large portion of the REST API can be re-used for Asterisk's ARI as well. Note that the data models are not modified for this purpose - only the operations have been changed as shown below.

---

Swagger Definition  

```javascript
{
 "apiVersion": "1.0.0",
 "swaggerVersion": "1.2",
 "basePath": "https://localhost:8088/ari"
 "resourcePath": "/beacon"
 "apis": [
 {
 "path": "/"
 "operations": [
 {
 "method": "GET",
 "summary": "Retrieve the information transmitted to the server",
 "$ref": "Server",
 "parameters": [
 ],
 "responseMessages": [
 {
 "code": 500,
 "message": "Beacon resource unavailable."
 }
 ]
 }
 ]
 }
 ]
}

```
