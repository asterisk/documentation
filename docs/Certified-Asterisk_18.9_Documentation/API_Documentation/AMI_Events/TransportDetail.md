---
search:
  boost: 0.5
title: TransportDetail
---

# TransportDetail

### Synopsis

Provide details about an authentication section.

### Syntax


```


Event: TransportDetail
ObjectType: <value>
ObjectName: <value>
Protocol: <value>
Bind: <value>
AsycOperations: <value>
CaListFile: <value>
CaListPath: <value>
CertFile: <value>
PrivKeyFile: <value>
Password: <value>
ExternalSignalingAddress: <value>
ExternalSignalingPort: <value>
ExternalMediaAddress: <value>
Domain: <value>
VerifyServer: <value>
VerifyClient: <value>
RequireClientCert: <value>
Method: <value>
Cipher: <value>
LocalNet: <value>
Tos: <value>
Cos: <value>
WebsocketWriteTimeout: <value>
EndpointName: <value>

```
##### Arguments


* `ObjectType` - The object's type. This will always be 'transport'.<br>

* `ObjectName` - The name of this object.<br>

* `Protocol` - Protocol to use for SIP traffic<br>

* `Bind` - IP Address and optional port to bind to for this transport<br>

* `AsycOperations` - Number of simultaneous Asynchronous Operations<br>

* `CaListFile` - File containing a list of certificates to read (TLS ONLY, not WSS)<br>

* `CaListPath` - Path to directory containing a list of certificates to read (TLS ONLY, not WSS)<br>

* `CertFile` - Certificate file for endpoint (TLS ONLY, not WSS)<br>

* `PrivKeyFile` - Private key file (TLS ONLY, not WSS)<br>

* `Password` - Password required for transport<br>

* `ExternalSignalingAddress` - External address for SIP signalling<br>

* `ExternalSignalingPort` - External port for SIP signalling<br>

* `ExternalMediaAddress` - External IP address to use in RTP handling<br>

* `Domain` - Domain the transport comes from<br>

* `VerifyServer` - Require verification of server certificate (TLS ONLY, not WSS)<br>

* `VerifyClient` - Require verification of client certificate (TLS ONLY, not WSS)<br>

* `RequireClientCert` - Require client certificate (TLS ONLY, not WSS)<br>

* `Method` - Method of SSL transport (TLS ONLY, not WSS)<br>

* `Cipher` - Preferred cryptography cipher names (TLS ONLY, not WSS)<br>

* `LocalNet` - Network to consider local (used for NAT purposes).<br>

* `Tos` - Enable TOS for the signalling sent over this transport<br>

* `Cos` - Enable COS for the signalling sent over this transport<br>

* `WebsocketWriteTimeout` - The timeout (in milliseconds) to set on WebSocket connections.<br>

* `EndpointName` - The name of the endpoint associated with this information.<br>

### Class

COMMAND

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 