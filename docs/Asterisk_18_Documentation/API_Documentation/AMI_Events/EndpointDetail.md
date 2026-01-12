---
search:
  boost: 0.5
title: EndpointDetail
---

# EndpointDetail

### Synopsis

Provide details about an endpoint section.

### Syntax


```


Event: EndpointDetail
ObjectType: <value>
ObjectName: <value>
Context: <value>
Disallow: <value>
Allow: <value>
DtmfMode: <value>
RtpIpv6: <value>
RtpSymmetric: <value>
IceSupport: <value>
UsePtime: <value>
ForceRport: <value>
RewriteContact: <value>
Transport: <value>
OutboundProxy: <value>
MohSuggest: <value>
100rel: <value>
Timers: <value>
TimersMinSe: <value>
TimersSessExpires: <value>
Auth: <value>
OutboundAuth: <value>
Aors: <value>
MediaAddress: <value>
IdentifyBy: <value>
DirectMedia: <value>
DirectMediaMethod: <value>
TrustConnectedLine: <value>
SendConnectedLine: <value>
ConnectedLineMethod: <value>
DirectMediaGlareMitigation: <value>
DisableDirectMediaOnNat: <value>
Callerid: <value>
CalleridPrivacy: <value>
CalleridTag: <value>
TrustIdInbound: <value>
TrustIdOutbound: <value>
SendPai: <value>
SendRpid: <value>
SendDiversion: <value>
Mailboxes: <value>
AggregateMwi: <value>
MediaEncryption: <value>
MediaEncryptionOptimistic: <value>
UseAvpf: <value>
ForceAvp: <value>
MediaUseReceivedTransport: <value>
OneTouchRecording: <value>
InbandProgress: <value>
CallGroup: <value>
PickupGroup: <value>
NamedCallGroup: <value>
NamedPickupGroup: <value>
DeviceStateBusyAt: <value>
T38Udptl: <value>
T38UdptlEc: <value>
T38UdptlMaxdatagram: <value>
FaxDetect: <value>
T38UdptlNat: <value>
T38UdptlIpv6: <value>
T38BindUdptlToMediaAddress: <value>
ToneZone: <value>
Language: <value>
RecordOnFeature: <value>
RecordOffFeature: <value>
AllowTransfer: <value>
UserEqPhone: <value>
MohPassthrough: <value>
SdpOwner: <value>
SdpSession: <value>
TosAudio: <value>
TosVideo: <value>
CosAudio: <value>
CosVideo: <value>
AllowSubscribe: <value>
SubMinExpiry: <value>
FromUser: <value>
FromDomain: <value>
MwiFromUser: <value>
RtpEngine: <value>
DtlsVerify: <value>
DtlsRekey: <value>
DtlsCertFile: <value>
DtlsPrivateKey: <value>
DtlsCipher: <value>
DtlsCaFile: <value>
DtlsCaPath: <value>
DtlsSetup: <value>
SrtpTag32: <value>
RedirectMethod: <value>
SetVar: <value>
MessageContext: <value>
Accountcode: <value>
PreferredCodecOnly: <value>
DeviceState: <value>
ActiveChannels: <value>
SubscribeContext: <value>
Allowoverlap: <value>
OverlapContext: <value>

```
##### Arguments


* `ObjectType` - The object's type. This will always be 'endpoint'.<br>

* `ObjectName` - The name of this object.<br>

* `Context` - Dialplan context for inbound sessions<br>

* `Disallow` - Media Codec(s) to disallow<br>

* `Allow` - Media Codec(s) to allow<br>

* `DtmfMode` - DTMF mode<br>

* `RtpIpv6` - Allow use of IPv6 for RTP traffic<br>

* `RtpSymmetric` - Enforce that RTP must be symmetric<br>

* `IceSupport` - Enable the ICE mechanism to help traverse NAT<br>

* `UsePtime` - Use Endpoint's requested packetization interval<br>

* `ForceRport` - Force use of return port<br>

* `RewriteContact` - Allow Contact header to be rewritten with the source IP address-port<br>

* `Transport` - Explicit transport configuration to use<br>

* `OutboundProxy` - Full SIP URI of the outbound proxy used to send requests<br>

* `MohSuggest` - Default Music On Hold class<br>

* `100rel` - Allow support for RFC3262 provisional ACK tags<br>

* `Timers` - Session timers for SIP packets<br>

* `TimersMinSe` - Minimum session timers expiration period<br>

* `TimersSessExpires` - Maximum session timer expiration period<br>

* `Auth` - Authentication Object(s) associated with the endpoint<br>

* `OutboundAuth` - Authentication object(s) used for outbound requests<br>

* `Aors` - AoR(s) to be used with the endpoint<br>

* `MediaAddress` - IP address used in SDP for media handling<br>

* `IdentifyBy` - Way(s) for the endpoint to be identified<br>

* `DirectMedia` - Determines whether media may flow directly between endpoints.<br>

* `DirectMediaMethod` - Direct Media method type<br>

* `TrustConnectedLine` - Accept Connected Line updates from this endpoint<br>

* `SendConnectedLine` - Send Connected Line updates to this endpoint<br>

* `ConnectedLineMethod` - Connected line method type<br>

* `DirectMediaGlareMitigation` - Mitigation of direct media (re)INVITE glare<br>

* `DisableDirectMediaOnNat` - Disable direct media session refreshes when NAT obstructs the media session<br>

* `Callerid` - CallerID information for the endpoint<br>

* `CalleridPrivacy` - Default privacy level<br>

* `CalleridTag` - Internal id\_tag for the endpoint<br>

* `TrustIdInbound` - Accept identification information received from this endpoint<br>

* `TrustIdOutbound` - Send private identification details to the endpoint.<br>

* `SendPai` - Send the P-Asserted-Identity header<br>

* `SendRpid` - Send the Remote-Party-ID header<br>

* `SendDiversion` - Send the Diversion header, conveying the diversion information to the called user agent<br>

* `Mailboxes` - NOTIFY the endpoint when state changes for any of the specified mailboxes<br>

* `AggregateMwi` - Condense MWI notifications into a single NOTIFY.<br>

* `MediaEncryption` - Determines whether res\_pjsip will use and enforce usage of media encryption for this endpoint.<br>

* `MediaEncryptionOptimistic` - Determines whether encryption should be used if possible but does not terminate the session if not achieved.<br>

* `UseAvpf` - Determines whether res\_pjsip will use and enforce usage of AVPF for this endpoint.<br>

* `ForceAvp` - Determines whether res\_pjsip will use and enforce usage of AVP, regardless of the RTP profile in use for this endpoint.<br>

* `MediaUseReceivedTransport` - Determines whether res\_pjsip will use the media transport received in the offer SDP in the corresponding answer SDP.<br>

* `OneTouchRecording` - Determines whether one-touch recording is allowed for this endpoint.<br>

* `InbandProgress` - Determines whether chan\_pjsip will indicate ringing using inband progress.<br>

* `CallGroup` - The numeric pickup groups for a channel.<br>

* `PickupGroup` - The numeric pickup groups that a channel can pickup.<br>

* `NamedCallGroup` - The named pickup groups for a channel.<br>

* `NamedPickupGroup` - The named pickup groups that a channel can pickup.<br>

* `DeviceStateBusyAt` - The number of in-use channels which will cause busy to be returned as device state<br>

* `T38Udptl` - Whether T.38 UDPTL support is enabled or not<br>

* `T38UdptlEc` - T.38 UDPTL error correction method<br>

* `T38UdptlMaxdatagram` - T.38 UDPTL maximum datagram size<br>

* `FaxDetect` - Whether CNG tone detection is enabled<br>

* `T38UdptlNat` - Whether NAT support is enabled on UDPTL sessions<br>

* `T38UdptlIpv6` - Whether IPv6 is used for UDPTL Sessions<br>

* `T38BindUdptlToMediaAddress` - Bind the UDPTL instance to the media\_adress<br>

* `ToneZone` - Set which country's indications to use for channels created for this endpoint.<br>

* `Language` - Set the default language to use for channels created for this endpoint.<br>

* `RecordOnFeature` - The feature to enact when one-touch recording is turned on.<br>

* `RecordOffFeature` - The feature to enact when one-touch recording is turned off.<br>

* `AllowTransfer` - Determines whether SIP REFER transfers are allowed for this endpoint<br>

* `UserEqPhone` - Determines whether a user=phone parameter is placed into the request URI if the user is determined to be a phone number<br>

* `MohPassthrough` - Determines whether hold and unhold will be passed through using re-INVITEs with recvonly and sendrecv to the remote side<br>

* `SdpOwner` - String placed as the username portion of an SDP origin (o=) line.<br>

* `SdpSession` - String used for the SDP session (s=) line.<br>

* `TosAudio` - DSCP TOS bits for audio streams<br>

* `TosVideo` - DSCP TOS bits for video streams<br>

* `CosAudio` - Priority for audio streams<br>

* `CosVideo` - Priority for video streams<br>

* `AllowSubscribe` - Determines if endpoint is allowed to initiate subscriptions with Asterisk.<br>

* `SubMinExpiry` - The minimum allowed expiry time for subscriptions initiated by the endpoint.<br>

* `FromUser` - Username to use in From header for requests to this endpoint.<br>

* `FromDomain` - Domain to use in From header for requests to this endpoint.<br>

* `MwiFromUser` - Username to use in From header for unsolicited MWI NOTIFYs to this endpoint.<br>

* `RtpEngine` - Name of the RTP engine to use for channels created for this endpoint<br>

* `DtlsVerify` - Verify that the provided peer certificate is valid<br>

* `DtlsRekey` - Interval at which to renegotiate the TLS session and rekey the SRTP session<br>

* `DtlsCertFile` - Path to certificate file to present to peer<br>

* `DtlsPrivateKey` - Path to private key for certificate file<br>

* `DtlsCipher` - Cipher to use for DTLS negotiation<br>

* `DtlsCaFile` - Path to certificate authority certificate<br>

* `DtlsCaPath` - Path to a directory containing certificate authority certificates<br>

* `DtlsSetup` - Whether we are willing to accept connections, connect to the other party, or both.<br>

* `SrtpTag32` - Determines whether 32 byte tags should be used instead of 80 byte tags.<br>

* `RedirectMethod` - How redirects received from an endpoint are handled<br>

* `SetVar` - Variable set on a channel involving the endpoint.<br>

* `MessageContext` - Context to route incoming MESSAGE requests to.<br>

* `Accountcode` - An accountcode to set automatically on any channels created for this endpoint.<br>

* `PreferredCodecOnly` - Respond to a SIP invite with the single most preferred codec (DEPRECATED)<br>

* `DeviceState` - The aggregate device state for this endpoint.<br>

* `ActiveChannels` - The number of active channels associated with this endpoint.<br>

* `SubscribeContext` - Context for incoming MESSAGE requests.<br>

* `Allowoverlap` - Enable RFC3578 overlap dialing support.<br>

* `OverlapContext` - Dialplan context to use for RFC3578 overlap dialing.<br>

### Class

COMMAND

### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 