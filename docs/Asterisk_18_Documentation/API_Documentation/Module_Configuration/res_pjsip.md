---
search:
  boost: 0.5
title: res_pjsip
---

# res_pjsip: SIP Resource using PJProject

This configuration documentation is for functionality provided by res_pjsip.

## Configuration File: pjsip.conf

### [endpoint]: Endpoint

The *Endpoint* is the primary configuration object. It contains the core SIP related options only, endpoints are *NOT* dialable entries of their own. Communication with another SIP device is accomplished via Addresses of Record (AoRs) which have one or more contacts associated with them. Endpoints *NOT* configured to use a 'transport' will default to first transport found in *pjsip.conf* that matches its type.<br>

Example: An Endpoint has been configured with no transport. When it comes time to call an AoR, PJSIP will find the first transport that matches the type. A SIP URI of 'sip:5000@\[11::33\]' will use the first IPv6 transport and try to send the request.<br>

If the anonymous endpoint identifier is in use an endpoint with the name "anonymous@domain" will be searched for as a last resort. If this is not found it will fall back to searching for "anonymous". If neither endpoints are found the anonymous endpoint identifier will not return an endpoint and anonymous calling will not be possible.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [100rel](#100rel)| Custom| yes| false| Allow support for RFC3262 provisional ACK tags| |
| [accept_multiple_sdp_answers](#accept_multiple_sdp_answers)| Boolean| no| false| Accept multiple SDP answers on non-100rel responses| |
| [accountcode](#accountcode)| String| | false| An accountcode to set automatically on any channels created for this endpoint.| |
| [acl](#acl)| Custom| | false| List of IP ACL section names in acl.conf| |
| [aggregate_mwi](#aggregate_mwi)| Boolean| yes| false| Condense MWI notifications into a single NOTIFY.| |
| allow| Codec| | false| Media Codec(s) to allow| |
| allow_overlap| Boolean| yes| false| Enable RFC3578 overlap dialing support.| |
| allow_subscribe| Boolean| yes| false| Determines if endpoint is allowed to initiate subscriptions with Asterisk.| |
| allow_transfer| Boolean| yes| false| Determines whether SIP REFER transfers are allowed for this endpoint| |
| [allow_unauthenticated_options](#allow_unauthenticated_options)| Boolean| no| false| Skip authentication when receiving OPTIONS requests| |
| [aors](#aors)| String| | false| AoR(s) to be used with the endpoint| |
| [asymmetric_rtp_codec](#asymmetric_rtp_codec)| Boolean| no| false| Allow the sending and receiving RTP codec to differ| |
| [auth](#auth)| Custom| | false| Authentication Object(s) associated with the endpoint| |
| [bind_rtp_to_media_address](#bind_rtp_to_media_address)| Boolean| no| false| Bind the RTP instance to the media_address| |
| [bundle](#bundle)| Boolean| no| false| Enable RTP bundling| |
| [call_group](#call_group)| Custom| | false| The numeric pickup groups for a channel.| |
| [callerid](#callerid)| Custom| | false| CallerID information for the endpoint| |
| [callerid_privacy](#callerid_privacy)| Custom| allowed_not_screened| false| Default privacy level| |
| callerid_tag| Custom| | false| Internal id_tag for the endpoint| |
| [codec_prefs_incoming_answer](#codec_prefs_incoming_answer)| Custom| prefer: pending, operation: intersect, keep: all| false| Codec negotiation prefs for incoming answers.| |
| [codec_prefs_incoming_offer](#codec_prefs_incoming_offer)| Custom| prefer: pending, operation: intersect, keep: all, transcode: allow| false| Codec negotiation prefs for incoming offers.| |
| [codec_prefs_outgoing_answer](#codec_prefs_outgoing_answer)| Custom| prefer: pending, operation: intersect, keep: all| false| Codec negotiation prefs for outgoing answers.| |
| [codec_prefs_outgoing_offer](#codec_prefs_outgoing_offer)| Custom| prefer: pending, operation: union, keep: all, transcode: allow| false| Codec negotiation prefs for outgoing offers.| |
| [connected_line_method](#connected_line_method)| Custom| invite| false| Connected line method type| |
| [contact_acl](#contact_acl)| Custom| | false| List of Contact ACL section names in acl.conf| |
| [contact_deny](#contact_deny)| Custom| | false| List of Contact header addresses to deny| |
| [contact_permit](#contact_permit)| Custom| | false| List of Contact header addresses to permit| |
| [contact_user](#contact_user)| Custom| | false| Force the user on the outgoing Contact header to this value.| |
| context| String| default| false| Dialplan context for inbound sessions| |
| [cos_audio](#cos_audio)| Unsigned Integer| 0| false| Priority for audio streams| |
| [cos_video](#cos_video)| Unsigned Integer| 0| false| Priority for video streams| |
| [deny](#deny)| Custom| | false| List of IP addresses to deny access from| |
| [device_state_busy_at](#device_state_busy_at)| Unsigned Integer| 0| false| The number of in-use channels which will cause busy to be returned as device state| |
| direct_media| Boolean| yes| false| Determines whether media may flow directly between endpoints.| |
| [direct_media_glare_mitigation](#direct_media_glare_mitigation)| Custom| none| false| Mitigation of direct media (re)INVITE glare| |
| [direct_media_method](#direct_media_method)| Custom| invite| false| Direct Media method type| |
| disable_direct_media_on_nat| Boolean| no| false| Disable direct media session refreshes when NAT obstructs the media session| |
| disallow| | | | Media Codec(s) to disallow| |
| [dtls_auto_generate_cert](#dtls_auto_generate_cert)| Custom| no| false| Whether or not to automatically generate an ephemeral X.509 certificate| |
| [dtls_ca_file](#dtls_ca_file)| Custom| | false| Path to certificate authority certificate| |
| [dtls_ca_path](#dtls_ca_path)| Custom| | false| Path to a directory containing certificate authority certificates| |
| [dtls_cert_file](#dtls_cert_file)| Custom| | false| Path to certificate file to present to peer| |
| [dtls_cipher](#dtls_cipher)| Custom| | false| Cipher to use for DTLS negotiation| |
| [dtls_fingerprint](#dtls_fingerprint)| Custom| | false| Type of hash to use for the DTLS fingerprint in the SDP.| |
| [dtls_private_key](#dtls_private_key)| Custom| | false| Path to private key for certificate file| |
| [dtls_rekey](#dtls_rekey)| Custom| 0| false| Interval at which to renegotiate the TLS session and rekey the SRTP session| |
| [dtls_setup](#dtls_setup)| Custom| | false| Whether we are willing to accept connections, connect to the other party, or both.| |
| [dtls_verify](#dtls_verify)| Custom| no| false| Verify that the provided peer certificate is valid| |
| [dtmf_mode](#dtmf_mode)| Custom| rfc4733| false| DTMF mode| |
| [fax_detect](#fax_detect)| Boolean| no| false| Whether CNG tone detection is enabled| |
| [fax_detect_timeout](#fax_detect_timeout)| Unsigned Integer| 0| false| How long into a call before fax_detect is disabled for the call| |
| [follow_early_media_fork](#follow_early_media_fork)| Boolean| yes| false| Follow SDP forked media when To tag is different| |
| [force_avp](#force_avp)| Boolean| no| false| Determines whether res_pjsip will use and enforce usage of AVP, regardless of the RTP profile in use for this endpoint.| |
| force_rport| Boolean| yes| false| Force use of return port| |
| from_domain| String| | false| Domain to use in From header for requests to this endpoint.| |
| from_user| Custom| | false| Username to use in From header for requests to this endpoint.| |
| [g726_non_standard](#g726_non_standard)| Boolean| no| false| Force g.726 to use AAL2 packing order when negotiating g.726 audio| |
| [geoloc_incoming_call_profile](#geoloc_incoming_call_profile)| String| | false| Geolocation profile to apply to incoming calls| |
| [geoloc_outgoing_call_profile](#geoloc_outgoing_call_profile)| String| | false| Geolocation profile to apply to outgoing calls| |
| ice_support| Boolean| no| false| Enable the ICE mechanism to help traverse NAT| |
| [identify_by](#identify_by)| Custom| username,ip| false| Way(s) for the endpoint to be identified| |
| [ignore_183_without_sdp](#ignore_183_without_sdp)| Boolean| no| false| Do not forward 183 when it doesn't contain SDP| |
| [inband_progress](#inband_progress)| Boolean| no| false| Determines whether chan_pjsip will indicate ringing using inband progress.| |
| [incoming_call_offer_pref](#incoming_call_offer_pref)| Custom| local| false| Preferences for selecting codecs for an incoming call.| |
| [incoming_mwi_mailbox](#incoming_mwi_mailbox)| String| | false| Mailbox name to use when incoming MWI NOTIFYs are received| |
| language| String| | false| Set the default language to use for channels created for this endpoint.| |
| [mailboxes](#mailboxes)| String| | false| NOTIFY the endpoint when state changes for any of the specified mailboxes| |
| [max_audio_streams](#max_audio_streams)| Unsigned Integer| 1| false| The maximum number of allowed audio streams for the endpoint| |
| [max_video_streams](#max_video_streams)| Unsigned Integer| 1| false| The maximum number of allowed video streams for the endpoint| |
| [media_address](#media_address)| Custom| | false| IP address used in SDP for media handling| |
| [media_encryption](#media_encryption)| Custom| no| false| Determines whether res_pjsip will use and enforce usage of media encryption for this endpoint.| |
| [media_encryption_optimistic](#media_encryption_optimistic)| Boolean| no| false| Determines whether encryption should be used if possible but does not terminate the session if not achieved.| |
| [media_use_received_transport](#media_use_received_transport)| Boolean| no| false| Determines whether res_pjsip will use the media transport received in the offer SDP in the corresponding answer SDP.| |
| [message_context](#message_context)| String| | false| Context to route incoming MESSAGE requests to.| |
| moh_passthrough| Boolean| no| false| Determines whether hold and unhold will be passed through using re-INVITEs with recvonly and sendrecv to the remote side| |
| moh_suggest| String| default| false| Default Music On Hold class| |
| mwi_from_user| String| | false| Username to use in From header for unsolicited MWI NOTIFYs to this endpoint.| |
| mwi_subscribe_replaces_unsolicited| Boolean| no| false| An MWI subscribe will replace sending unsolicited NOTIFYs| |
| [named_call_group](#named_call_group)| Custom| | false| The named pickup groups for a channel.| |
| [named_pickup_group](#named_pickup_group)| Custom| | false| The named pickup groups that a channel can pickup.| |
| [notify_early_inuse_ringing](#notify_early_inuse_ringing)| Boolean| no| false| Whether to notifies dialog-info 'early' on InUse&Ringing state| |
| one_touch_recording| Boolean| no| false| Determines whether one-touch recording is allowed for this endpoint.| |
| [outbound_auth](#outbound_auth)| Custom| | false| Authentication object(s) used for outbound requests| |
| outbound_proxy| String| | false| Full SIP URI of the outbound proxy used to send requests| |
| [outgoing_call_offer_pref](#outgoing_call_offer_pref)| Custom| remote_merge| false| Preferences for selecting codecs for an outgoing call.| |
| [overlap_context](#overlap_context)| String| | false| Dialplan context to use for RFC3578 overlap dialing.| |
| [permit](#permit)| Custom| | false| List of IP addresses to permit access from| |
| [pickup_group](#pickup_group)| Custom| | false| The numeric pickup groups that a channel can pickup.| |
| [preferred_codec_only](#preferred_codec_only)| Boolean| no| false| Respond to a SIP invite with the single most preferred codec (DEPRECATED)| |
| [record_off_feature](#record_off_feature)| String| automixmon| false| The feature to enact when one-touch recording is turned off.| |
| [record_on_feature](#record_on_feature)| String| automixmon| false| The feature to enact when one-touch recording is turned on.| |
| [redirect_method](#redirect_method)| Custom| user| false| How redirects received from an endpoint are handled| |
| [refer_blind_progress](#refer_blind_progress)| Boolean| yes| false| Whether to notifies all the progress details on blind transfer| |
| [rewrite_contact](#rewrite_contact)| Boolean| no| false| Allow Contact header to be rewritten with the source IP address-port| |
| [rpid_immediate](#rpid_immediate)| Boolean| no| false| Immediately send connected line updates on unanswered incoming calls.| |
| [rtcp_mux](#rtcp_mux)| Boolean| no| false| Enable RFC 5761 RTCP multiplexing on the RTP port| |
| rtp_engine| String| asterisk| false| Name of the RTP engine to use for channels created for this endpoint| |
| rtp_ipv6| Boolean| no| false| Allow use of IPv6 for RTP traffic| |
| [rtp_keepalive](#rtp_keepalive)| Unsigned Integer| 0| false| Number of seconds between RTP comfort noise keepalive packets.| |
| rtp_symmetric| Boolean| no| false| Enforce that RTP must be symmetric| |
| [rtp_timeout](#rtp_timeout)| Unsigned Integer| 0| false| Maximum number of seconds without receiving RTP (while off hold) before terminating call.| |
| [rtp_timeout_hold](#rtp_timeout_hold)| Unsigned Integer| 0| false| Maximum number of seconds without receiving RTP (while on hold) before terminating call.| |
| sdp_owner| String| -| false| String placed as the username portion of an SDP origin (o=) line.| |
| sdp_session| String| Asterisk| false| String used for the SDP session (s=) line.| |
| [security_mechanisms](#security_mechanisms)| Custom| | false| List of security mechanisms supported.| |
| [security_negotiation](#security_negotiation)| Custom| no| false| The kind of security agreement negotiation to use. Currently, only mediasec is supported.| |
| send_aoc| Boolean| no| false| Send Advice-of-Charge messages| |
| send_connected_line| Boolean| yes| false| Send Connected Line updates to this endpoint| |
| send_diversion| Boolean| yes| false| Send the Diversion header, conveying the diversion information to the called user agent| |
| send_history_info| Boolean| no| false| Send the History-Info header, conveying the diversion information to the called and calling user agents| |
| send_pai| Boolean| no| false| Send the P-Asserted-Identity header| |
| send_rpid| Boolean| no| false| Send the Remote-Party-ID header| |
| [set_var](#set_var)| Custom| | false| Variable set on a channel involving the endpoint.| |
| [srtp_tag_32](#srtp_tag_32)| Boolean| no| false| Determines whether 32 byte tags should be used instead of 80 byte tags.| |
| [stir_shaken](#stir_shaken)| Custom| no| false| Enable STIR/SHAKEN support on this endpoint| |
| [stir_shaken_profile](#stir_shaken_profile)| String| | false| STIR/SHAKEN profile containing additional configuration options| |
| sub_min_expiry| Unsigned Integer| 0| false| The minimum allowed expiry time for subscriptions initiated by the endpoint.| |
| [subscribe_context](#subscribe_context)| String| | false| Context for incoming MESSAGE requests.| |
| [suppress_q850_reason_headers](#suppress_q850_reason_headers)| Boolean| no| false| Suppress Q.850 Reason headers for this endpoint| |
| [t38_bind_udptl_to_media_address](#t38_bind_udptl_to_media_address)| Boolean| no| false| Bind the UDPTL instance to the media_adress| |
| [t38_udptl](#t38_udptl)| Boolean| no| false| Whether T.38 UDPTL support is enabled or not| |
| [t38_udptl_ec](#t38_udptl_ec)| Custom| none| false| T.38 UDPTL error correction method| |
| [t38_udptl_ipv6](#t38_udptl_ipv6)| Boolean| no| false| Whether IPv6 is used for UDPTL Sessions| |
| [t38_udptl_maxdatagram](#t38_udptl_maxdatagram)| Unsigned Integer| 0| false| T.38 UDPTL maximum datagram size| |
| [t38_udptl_nat](#t38_udptl_nat)| Boolean| no| false| Whether NAT support is enabled on UDPTL sessions| |
| [tenantid](#tenantid)| String| | false| The tenant ID for this endpoint.| |
| [timers](#timers)| Custom| yes| false| Session timers for SIP packets| |
| [timers_min_se](#timers_min_se)| Unsigned Integer| 90| false| Minimum session timers expiration period| |
| [timers_sess_expires](#timers_sess_expires)| Unsigned Integer| 1800| false| Maximum session timer expiration period| |
| tone_zone| String| | false| Set which country's indications to use for channels created for this endpoint.| |
| [tos_audio](#tos_audio)| Custom| 0| false| DSCP TOS bits for audio streams| |
| [tos_video](#tos_video)| Custom| 0| false| DSCP TOS bits for video streams| |
| [transport](#transport)| String| | false| Explicit transport configuration to use| |
| trust_connected_line| Boolean| yes| false| Accept Connected Line updates from this endpoint| |
| [trust_id_inbound](#trust_id_inbound)| Boolean| no| false| Accept identification information received from this endpoint| |
| [trust_id_outbound](#trust_id_outbound)| Boolean| no| false| Send private identification details to the endpoint.| |
| type| None| | false| Must be of type 'endpoint'.| |
| [use_avpf](#use_avpf)| Boolean| no| false| Determines whether res_pjsip will use and enforce usage of AVPF for this endpoint.| |
| use_ptime| Boolean| no| false| Use Endpoint's requested packetization interval| |
| user_eq_phone| Boolean| no| false| Determines whether a user=phone parameter is placed into the request URI if the user is determined to be a phone number| |
| voicemail_extension| Custom| | false| The voicemail extension to send in the NOTIFY Message-Account header| |
| [webrtc](#webrtc)| Boolean| no| false| Defaults and enables some options that are relevant to WebRTC| |


#### Configuration Option Descriptions

##### 100rel


* `no` - If set to 'no', do not support transmission of reliable provisional responses. As UAS, if an incoming request contains 100rel in the Required header, it is rejected with 420 Bad Extension.<br>

* `required` - If set to 'required', require provisional responses to be sent and received reliably. As UAS, incoming requests without 100rel in the Supported header are rejected with 421 Extension Required. As UAC, outgoing requests will have 100rel in the Required header.<br>

* `peer_supported` - If set to 'peer\_supported', send provisional responses reliably if the request by the peer contained 100rel in the Supported or Require header. As UAS, if an incoming request contains 100rel in the Supported header, send 1xx responses reliably. If the request by the peer does not contain 100rel in the Supported and Require header, send responses normally. As UAC, outgoing requests will contain 100rel in the Supported header.<br>

* `yes` - If set to 'yes', indicate the support of reliable provisional responses and PRACK them if required by the peer. As UAS, if the incoming request contains 100rel in the Supported header but not in the Required header, send 1xx responses normally. If the incoming request contains 100rel in the Required header, send 1xx responses reliably. As UAC add 100rel to the Supported header and PRACK 1xx responses if required.<br>

##### accept_multiple_sdp_answers

On outgoing calls, if the UAS responds with different SDP attributes on non-100rel 18X or 2XX responses (such as a port update) AND the To tag on the subsequent response is the same as that on the previous one, process the updated SDP. This can happen when the UAS needs to change ports for some reason such as using a separate port for custom ringback.<br>


/// note
This option must also be enabled in the 'system' section for it to take effect here.
///


##### accountcode

If specified, any channel created for this endpoint will automatically have this accountcode set on it.<br>


##### acl

This matches sections configured in 'acl.conf'. The value is defined as a list of comma-delimited section names.<br>


##### aggregate_mwi

When enabled, _aggregate\_mwi_ condenses message waiting notifications from multiple mailboxes into a single NOTIFY. If it is disabled, individual NOTIFYs are sent for each mailbox.<br>


##### allow_unauthenticated_options

RFC 3261 says that the response to an OPTIONS request MUST be the same had the request been an INVITE. Some UAs use OPTIONS requests like a 'ping' and the expectation is that they will return a 200 OK.<br>

Enabling 'allow\_unauthenticated\_options' will skip authentication of OPTIONS requests for the given endpoint.<br>

There are security implications to enabling this setting as it can allow information disclosure to occur - specifically, if enabled, an external party could enumerate and find the endpoint name by sending OPTIONS requests and examining the responses.<br>


##### aors

List of comma separated AoRs that the endpoint should be associated with.<br>


##### asymmetric_rtp_codec

When set to "yes" the codec in use for sending will be allowed to differ from that of the received one. PJSIP will not automatically switch the sending one to the receiving one.<br>


##### auth

This is a comma-delimited list of _auth_ sections defined in *pjsip.conf* to be used to verify inbound connection attempts.<br>

Endpoints without an authentication object configured will allow connections without verification.<br>


/// note
Using the same auth section for inbound and outbound authentication is not recommended. There is a difference in meaning for an empty realm setting between inbound and outbound authentication uses. See the auth realm description for details.
///


##### bind_rtp_to_media_address

If media\_address is specified, this option causes the RTP instance to be bound to the specified ip address which causes the packets to be sent from that address.<br>


##### bundle

With this option enabled, Asterisk will attempt to negotiate the use of bundle. If negotiated this will result in multiple RTP streams being carried over the same underlying transport. Note that enabling bundle will also enable the rtcp\_mux option.<br>


##### call_group

Can be set to a comma separated list of numbers or ranges between the values of 0-63 (maximum of 64 groups).<br>


##### callerid

Must be in the format 'Name <Number>', or only '<Number>'.<br>


##### callerid_privacy


* `allowed_not_screened`

* `allowed_passed_screen`

* `allowed_failed_screen`

* `allowed`

* `prohib_not_screened`

* `prohib_passed_screen`

* `prohib_failed_screen`

* `prohib`

* `unavailable`

##### codec_prefs_incoming_answer

This is a string that describes how the codecs specified in an incoming SDP answer (pending) are reconciled with the codecs specified on an endpoint (configured) when receiving an SDP answer. The string actually specifies 4 'name:value' pair parameters separated by commas. Whitespace is ignored and they may be specified in any order. Note that this option is reserved for future functionality.<br>

Parameters:<br>


* `prefer: < pending | configured >` - <br>

    * `pending` - The codec list in the received SDP answer. (default)<br>

    * `configured` - The codec list from the endpoint.<br>

* `operation : < union | intersect | only_preferred | only_nonpreferred >` - <br>

    * `union` - Merge the lists with the preferred codecs first.<br>

    * `intersect` - Only common codecs with the preferred codecs first. (default)<br>

    * `only_preferred` - Use only the preferred codecs.<br>

    * `only_nonpreferred` - Use only the non-preferred codecs.<br>

* `keep : < all | first >` - <br>

    * `all` - After the operation, keep all codecs. (default)<br>

    * `first` - After the operation, keep only the first codec.<br>

* `transcode : < allow | prevent >` - The transcode parameter is ignored when processing answers.<br>
<br>

``` title="Example: "

codec_prefs_incoming_answer = keep: first

						
```
Use the defaults but keep oinly the first codec.<br>


##### codec_prefs_incoming_offer

This is a string that describes how the codecs specified on an incoming SDP offer (pending) are reconciled with the codecs specified on an endpoint (configured) before being sent to the Asterisk core. The string actually specifies 4 'name:value' pair parameters separated by commas. Whitespace is ignored and they may be specified in any order. Note that this option is reserved for future functionality.<br>

Parameters:<br>


* `prefer: < pending | configured >` - <br>

    * `pending` - The codec list from the caller. (default)<br>

    * `configured` - The codec list from the endpoint.<br>

* `operation : < intersect | only_preferred | only_nonpreferred >` - <br>

    * `intersect` - Only common codecs with the preferred codecs first. (default)<br>

    * `only_preferred` - Use only the preferred codecs.<br>

    * `only_nonpreferred` - Use only the non-preferred codecs.<br>

* `keep : < all | first >` - <br>

    * `all` - After the operation, keep all codecs. (default)<br>

    * `first` - After the operation, keep only the first codec.<br>

* `transcode : < allow | prevent >` - <br>

    * `allow` - Allow transcoding. (default)<br>

    * `prevent` - Prevent transcoding.<br>
<br>

``` title="Example: "

codec_prefs_incoming_offer = prefer: pending, operation: intersect, keep: all, transcode: allow

						
```
Prefer the codecs coming from the caller. Use only the ones that are common. keeping the order of the preferred list. Keep all codecs in the result. Allow transcoding.<br>


##### codec_prefs_outgoing_answer

This is a string that describes how the codecs that come from the core (pending) are reconciled with the codecs specified on an endpoint (configured) when sending an SDP answer. The string actually specifies 4 'name:value' pair parameters separated by commas. Whitespace is ignored and they may be specified in any order. Note that this option is reserved for future functionality.<br>

Parameters:<br>


* `prefer: < pending | configured >` - <br>

    * `pending` - The codec list that came from the core. (default)<br>

    * `configured` - The codec list from the endpoint.<br>

* `operation : < union | intersect | only_preferred | only_nonpreferred >` - <br>

    * `union` - Merge the lists with the preferred codecs first.<br>

    * `intersect` - Only common codecs with the preferred codecs first. (default)<br>

    * `only_preferred` - Use only the preferred codecs.<br>

    * `only_nonpreferred` - Use only the non-preferred codecs.<br>

* `keep : < all | first >` - <br>

    * `all` - After the operation, keep all codecs. (default)<br>

    * `first` - After the operation, keep only the first codec.<br>

* `transcode : < allow | prevent >` - The transcode parameter is ignored when processing answers.<br>
<br>

``` title="Example: "

codec_prefs_incoming_answer = keep: first

						
```
Use the defaults but keep oinly the first codec.<br>


##### codec_prefs_outgoing_offer

This is a string that describes how the codecs specified in the topology that comes from the Asterisk core (pending) are reconciled with the codecs specified on an endpoint (configured) when sending an SDP offer. The string actually specifies 4 'name:value' pair parameters separated by commas. Whitespace is ignored and they may be specified in any order. Note that this option is reserved for future functionality.<br>

Parameters:<br>


* `prefer: < pending | configured >` - <br>

    * `pending` - The codec list from the core. (default)<br>

    * `configured` - The codec list from the endpoint.<br>

* `operation : < union | intersect | only_preferred | only_nonpreferred >` - <br>

    * `union` - Merge the lists with the preferred codecs first. (default)<br>

    * `intersect` - Only common codecs with the preferred codecs first. (default)<br>

    * `only_preferred` - Use only the preferred codecs.<br>

    * `only_nonpreferred` - Use only the non-preferred codecs.<br>

* `keep : < all | first >` - <br>

    * `all` - After the operation, keep all codecs. (default)<br>

    * `first` - After the operation, keep only the first codec.<br>

* `transcode : < allow | prevent >` - <br>

    * `allow` - Allow transcoding. (default)<br>

    * `prevent` - Prevent transcoding.<br>
<br>

``` title="Example: "

codec_prefs_outgoing_offer = prefer: configured, operation: union, keep: first, transcode: prevent

						
```
Prefer the codecs coming from the endpoint. Merge them with the codecs from the core keeping the order of the preferred list. Keep only the first one. No transcoding allowed.<br>


##### connected_line_method

Method used when updating connected line information.<br>


* `invite` - When set to 'invite', check the remote's Allow header and if UPDATE is allowed, send UPDATE instead of INVITE to avoid SDP renegotiation. If UPDATE is not Allowed, send INVITE.<br>

* `reinvite` - Alias for the 'invite' value.<br>

* `update` - If set to 'update', send UPDATE regardless of what the remote Allows.<br>

##### contact_acl

This matches sections configured in 'acl.conf'. The value is defined as a list of comma-delimited section names.<br>


##### contact_deny

The value is a comma-delimited list of IP addresses. IP addresses may have a subnet mask appended. The subnet mask may be written in either CIDR or dotted-decimal notation. Separate the IP address and subnet mask with a slash ('/')<br>


##### contact_permit

The value is a comma-delimited list of IP addresses. IP addresses may have a subnet mask appended. The subnet mask may be written in either CIDR or dotted-decimal notation. Separate the IP address and subnet mask with a slash ('/')<br>


##### contact_user

On outbound requests, force the user portion of the Contact header to this value.<br>


##### cos_audio

See https://docs.asterisk.org/Configuration/Channel-Drivers/IP-Quality-of-Service for more information about QoS settings<br>


##### cos_video

See https://docs.asterisk.org/Configuration/Channel-Drivers/IP-Quality-of-Service for more information about QoS settings<br>


##### deny

The value is a comma-delimited list of IP addresses. IP addresses may have a subnet mask appended. The subnet mask may be written in either CIDR or dotted-decimal notation. Separate the IP address and subnet mask with a slash ('/')<br>


##### device_state_busy_at

When the number of in-use channels for the endpoint matches the devicestate\_busy\_at setting the PJSIP channel driver will return busy as the device state instead of in use.<br>


##### direct_media_glare_mitigation

This setting attempts to avoid creating INVITE glare scenarios by disabling direct media reINVITEs in one direction thereby allowing designated servers (according to this option) to initiate direct media reINVITEs without contention and significantly reducing call setup time.<br>

A more detailed description of how this option functions can be found in the Asterisk documentation https://docs.asterisk.org/Configuration/Channel-Drivers/SIP/Concepts/SIP-Direct-Media-Reinvite-Glare-Avoidance/<br>


* `none`

* `outgoing`

* `incoming`

##### direct_media_method

Method for setting up Direct Media between endpoints.<br>


* `invite`

* `reinvite` - Alias for the 'invite' value.<br>

* `update`

##### dtls_auto_generate_cert

If enabled, Asterisk will generate an X.509 certificate for each DTLS session. This option only applies if _media\_encryption_ is set to 'dtls'. This option will be automatically enabled if 'webrtc' is enabled and 'dtls\_cert\_file' is not specified.<br>


##### dtls_ca_file

This option only applies if _media\_encryption_ is set to 'dtls'.<br>


##### dtls_ca_path

This option only applies if _media\_encryption_ is set to 'dtls'.<br>


##### dtls_cert_file

This option only applies if _media\_encryption_ is set to 'dtls'.<br>


##### dtls_cipher

This option only applies if _media\_encryption_ is set to 'dtls'.<br>

Many options for acceptable ciphers. See link for more:<br>

http://www.openssl.org/docs/apps/ciphers.html#CIPHER\_STRINGS<br>


##### dtls_fingerprint

This option only applies if _media\_encryption_ is set to 'dtls'.<br>


* `SHA-256`

* `SHA-1`

##### dtls_private_key

This option only applies if _media\_encryption_ is set to 'dtls'.<br>


##### dtls_rekey

This option only applies if _media\_encryption_ is set to 'dtls'.<br>

If this is not set or the value provided is 0 rekeying will be disabled.<br>


##### dtls_setup

This option only applies if _media\_encryption_ is set to 'dtls'.<br>


* `active` - res\_pjsip will make a connection to the peer.<br>

* `passive` - res\_pjsip will accept connections from the peer.<br>

* `actpass` - res\_pjsip will offer and accept connections from the peer.<br>

##### dtls_verify

This option only applies if _media\_encryption_ is set to 'dtls'.<br>

It can be one of the following values:<br>


* `no` - meaning no verification is done.<br>

* `fingerprint` - meaning to verify the remote fingerprint.<br>

* `certificate` - meaning to verify the remote certificate.<br>

* `yes` - meaning to verify both the remote fingerprint and certificate.<br>

##### dtmf_mode

This setting allows to choose the DTMF mode for endpoint communication.<br>


* `rfc4733` - DTMF is sent out of band of the main audio stream. This supercedes the older *RFC-2833* used within the older 'chan\_sip'.<br>

* `inband` - DTMF is sent as part of audio stream.<br>

* `info` - DTMF is sent as SIP INFO packets.<br>

* `auto` - DTMF is sent as RFC 4733 if the other side supports it or as INBAND if not.<br>

* `auto_info` - DTMF is sent as RFC 4733 if the other side supports it or as SIP INFO if not.<br>

##### fax_detect

This option can be set to send the session to the fax extension when a CNG tone is detected.<br>


##### fax_detect_timeout

The option determines how many seconds into a call before the fax\_detect option is disabled for the call. Setting the value to zero disables the timeout.<br>


##### follow_early_media_fork

On outgoing calls, if the UAS responds with different SDP attributes on subsequent 18X or 2XX responses (such as a port update) AND the To tag on the subsequent response is different than that on the previous one, follow it. This usually happens when the INVITE is forked to multiple UASs and more than one sends an SDP answer.<br>


/// note
This option must also be enabled in the 'system' section for it to take effect here.
///


##### force_avp

If set to 'yes', res\_pjsip will use the AVP, AVPF, SAVP, or SAVPF RTP profile for all media offers on outbound calls and media updates including those for DTLS-SRTP streams.<br>

If set to 'no', res\_pjsip will use the respective RTP profile depending on configuration.<br>


##### g726_non_standard

When set to "yes" and an endpoint negotiates g.726 audio then use g.726 for AAL2 packing order instead of what is recommended by RFC3551. Since this essentially replaces the underlying 'g726' codec with 'g726aal2' then 'g726aal2' needs to be specified in the endpoint's allowed codec list.<br>


##### geoloc_incoming_call_profile

This geolocation profile will be applied to all calls received by the channel driver from the remote endpoint before they're forwarded to the dialplan.<br>


##### geoloc_outgoing_call_profile

This geolocation profile will be applied to all calls received by the channel driver from the dialplan before they're forwarded the remote endpoint.<br>


##### identify_by

Endpoints and AORs can be identified in multiple ways. This option is a comma separated list of methods the endpoint can be identified.<br>


/// note
This option controls both how an endpoint is matched for incoming traffic and also how an AOR is determined if a registration occurs. You must list at least one method that also matches for AORs or the registration will fail.
///


* `username` - Matches the endpoint or AOR ID based on the username and domain in the From header (or To header for AORs). If an exact match on both username and domain/realm fails, the match is retried with just the username.<br>

* `auth_username` - Matches the endpoint or AOR ID based on the username and realm in the Authentication header. If an exact match on both username and domain/realm fails, the match is retried with just the username.<br>

    /// note
This method of identification has some security considerations because an Authentication header is not present on the first message of a dialog when digest authentication is used. The client can't generate it until the server sends the challenge in a 401 response. Since Asterisk normally sends a security event when an incoming request can't be matched to an endpoint, using this method requires that the security event be deferred until a request is received with the Authentication header and only generated if the username doesn't result in a match. This may result in a delay before an attack is recognized. You can control how many unmatched requests are received from a single ip address before a security event is generated using the 'unidentified\_request' parameters in the "global" configuration object.
///


* `ip` - Matches the endpoint based on the source IP address.<br>
This method of identification is not configured here but simply allowed by this configuration option. See the documentation for the 'identify' configuration section for more details on this method of endpoint identification.<br>

* `header` - Matches the endpoint based on a configured SIP header value.<br>
This method of identification is not configured here but simply allowed by this configuration option. See the documentation for the 'identify' configuration section for more details on this method of endpoint identification.<br>

* `request_uri` - Matches the endpoint based on the configured SIP request uri.<br>
This method of identification is not configured here but simply allowed by this configuration option.<br>

##### ignore_183_without_sdp

Certain SS7 internetworking scenarios can result in a 183 to be generated for reasons other than early media. Forwarding this 183 can cause loss of ringback tone. This flag emulates the behavior of chan\_sip and prevents these 183 responses from being forwarded.<br>


##### inband_progress

If set to 'yes', chan\_pjsip will send a 183 Session Progress when told to indicate ringing and will immediately start sending ringing as audio.<br>

If set to 'no', chan\_pjsip will send a 180 Ringing when told to indicate ringing and will NOT send it as audio.<br>


##### incoming_call_offer_pref

Based on this setting, a joint list of preferred codecs between those received in an incoming SDP offer (remote), and those specified in the endpoint's "allow" parameter (local) es created and is passed to the Asterisk core.<br>


/// note
This list will consist of only those codecs found in both lists.
///


* `local` - Include all codecs in the local list that are also in the remote list preserving the local order. (default).<br>

* `local_first` - Include only the first codec in the local list that is also in the remote list.<br>

* `remote` - Include all codecs in the remote list that are also in the local list preserving the remote order.<br>

* `remote_first` - Include only the first codec in the remote list that is also in the local list.<br>

##### incoming_mwi_mailbox

If an MWI NOTIFY is received *from* this endpoint, this mailbox will be used when notifying other modules of MWI status changes. If not set, incoming MWI NOTIFYs are ignored.<br>


##### mailboxes

Asterisk will send unsolicited MWI NOTIFY messages to the endpoint when state changes happen for any of the specified mailboxes. More than one mailbox can be specified with a comma-delimited string. app\_voicemail mailboxes must be specified as mailbox@context; for example: mailboxes=6001@default. For mailboxes provided by external sources, such as through the res\_mwi\_external module, you must specify strings supported by the external system.<br>

For endpoints that SUBSCRIBE for MWI, use the 'mailboxes' option in your AOR configuration.<br>


##### max_audio_streams

This option enforces a limit on the maximum simultaneous negotiated audio streams allowed for the endpoint.<br>


##### max_video_streams

This option enforces a limit on the maximum simultaneous negotiated video streams allowed for the endpoint.<br>


##### media_address

At the time of SDP creation, the IP address defined here will be used as the media address for individual streams in the SDP.<br>


/// note
Be aware that the 'external\_media\_address' option, set in Transport configuration, can also affect the final media address used in the SDP.
///


##### media_encryption


* `no` - res\_pjsip will offer no encryption and allow no encryption to be setup.<br>

* `sdes` - res\_pjsip will offer standard SRTP setup via in-SDP keys. Encrypted SIP transport should be used in conjunction with this option to prevent exposure of media encryption keys.<br>

* `dtls` - res\_pjsip will offer DTLS-SRTP setup.<br>

##### media_encryption_optimistic

This option only applies if _media\_encryption_ is set to 'sdes' or 'dtls'.<br>


##### media_use_received_transport

If set to 'yes', res\_pjsip will use the received media transport.<br>

If set to 'no', res\_pjsip will use the respective RTP profile depending on configuration.<br>


##### message_context

If specified, incoming MESSAGE requests will be routed to the indicated dialplan context. If no _message\_context_ is specified, then the _context_ setting is used.<br>


##### named_call_group

Can be set to a comma separated list of case sensitive strings limited by supported line length.<br>


##### named_pickup_group

Can be set to a comma separated list of case sensitive strings limited by supported line length.<br>


##### notify_early_inuse_ringing

Control whether dialog-info subscriptions get 'early' state on Ringing when already INUSE.<br>


##### outbound_auth

This is a comma-delimited list of _auth_ sections defined in *pjsip.conf* used to respond to outbound connection authentication challenges.<br>


/// note
Using the same auth section for inbound and outbound authentication is not recommended. There is a difference in meaning for an empty realm setting between inbound and outbound authentication uses. See the auth realm description for details.
///


##### outgoing_call_offer_pref

Based on this setting, a joint list of preferred codecs between those received from the Asterisk core (remote), and those specified in the endpoint's "allow" parameter (local) is created and is used to create the outgoing SDP offer.<br>


* `local` - Include all codecs in the local list that are also in the remote list preserving the local order.<br>

* `local_merge` - Include all codecs in the local list preserving the local order.<br>

* `local_first` - Include only the first codec in the local list.<br>

* `remote` - Include all codecs in the remote list that are also in the local list preserving the remote order.<br>

* `remote_merge` - Include all codecs in the local list preserving the remote order. (default)<br>

* `remote_first` - Include only the first codec in the remote list that is also in the local list.<br>

##### overlap_context

Dialplan context to use for overlap dialing extension matching. If not specified, the context configured for the endpoint will be used. If specified, the extensions/patterns in the specified context will be used for determining if a full number has been received from the endpoint.<br>


##### permit

The value is a comma-delimited list of IP addresses. IP addresses may have a subnet mask appended. The subnet mask may be written in either CIDR or dotted-decimal notation. Separate the IP address and subnet mask with a slash ('/')<br>


##### pickup_group

Can be set to a comma separated list of numbers or ranges between the values of 0-63 (maximum of 64 groups).<br>


##### preferred_codec_only

Respond to a SIP invite with the single most preferred codec rather than advertising all joint codec capabilities. This limits the other side's codec choice to exactly what we prefer.<br>


/// warning
This option has been deprecated in favor of 'incoming\_call\_offer\_pref'. Setting both options is unsupported.
///


##### record_off_feature

When an INFO request for one-touch recording arrives with a Record header set to "off", this feature will be enabled for the channel. The feature designated here can be any built-in or dynamic feature defined in features.conf.<br>


/// note
This setting has no effect if the endpoint's one\_touch\_recording option is disabled
///


##### record_on_feature

When an INFO request for one-touch recording arrives with a Record header set to "on", this feature will be enabled for the channel. The feature designated here can be any built-in or dynamic feature defined in features.conf.<br>


/// note
This setting has no effect if the endpoint's one\_touch\_recording option is disabled
///


##### redirect_method

When a redirect is received from an endpoint there are multiple ways it can be handled. If this option is set to 'user' the user portion of the redirect target is treated as an extension within the dialplan and dialed using a Local channel. If this option is set to 'uri\_core' the target URI is returned to the dialing application which dials it using the PJSIP channel driver and endpoint originally used. If this option is set to 'uri\_pjsip' the redirect occurs within chan\_pjsip itself and is not exposed to the core at all. The 'uri\_pjsip' option has the benefit of being more efficient and also supporting multiple potential redirect targets. The con is that since redirection occurs within chan\_pjsip redirecting information is not forwarded and redirection can not be prevented.<br>


* `user`

* `uri_core`

* `uri_pjsip`

##### refer_blind_progress

Some SIP phones (Mitel/Aastra, Snom) expect a sip/frag "200 OK" after REFER has been accepted. If set to 'no' then asterisk will not send the progress details, but immediately will send "200 OK".<br>


##### rewrite_contact

On inbound SIP messages from this endpoint, the Contact header or an appropriate Record-Route header will be changed to have the source IP address and port. This option does not affect outbound messages sent to this endpoint. This option helps servers communicate with endpoints that are behind NATs. This option also helps reuse reliable transport connections such as TCP and TLS.<br>


##### rpid_immediate

When enabled, immediately send *180 Ringing* or *183 Progress* response messages to the caller if the connected line information is updated before the call is answered. This can send a *180 Ringing* response before the call has even reached the far end. The caller can start hearing ringback before the far end even gets the call. Many phones tend to grab the first connected line information and refuse to update the display if it changes. The first information is not likely to be correct if the call goes to an endpoint not under the control of this Asterisk box.<br>

When disabled, a connected line update must wait for another reason to send a message with the connected line information to the caller before the call is answered. You can trigger the sending of the information by using an appropriate dialplan application such as *Ringing*.<br>


##### rtcp_mux

With this option enabled, Asterisk will attempt to negotiate the use of the "rtcp-mux" attribute on all media streams. This will result in RTP and RTCP being sent and received on the same port. This shifts the demultiplexing logic to the application rather than the transport layer. This option is useful when interoperating with WebRTC endpoints since they mandate this option's use.<br>


##### rtp_keepalive

At the specified interval, Asterisk will send an RTP comfort noise frame. This may be useful for situations where Asterisk is behind a NAT or firewall and must keep a hole open in order to allow for media to arrive at Asterisk.<br>


##### rtp_timeout

This option configures the number of seconds without RTP (while off hold) before considering a channel as dead. When the number of seconds is reached the underlying channel is hung up. By default this option is set to 0, which means do not check.<br>


##### rtp_timeout_hold

This option configures the number of seconds without RTP (while on hold) before considering a channel as dead. When the number of seconds is reached the underlying channel is hung up. By default this option is set to 0, which means do not check.<br>


##### security_mechanisms

This is a comma-delimited list of security mechanisms to use. Each security mechanism must be in the form defined by RFC 3329 section 2.2.<br>


##### security_negotiation


* `no`

* `mediasec`

##### set_var

When a new channel is created using the endpoint set the specified variable(s) on that channel. For multiple channel variables specify multiple 'set\_var'(s).<br>


##### srtp_tag_32

This option only applies if _media\_encryption_ is set to 'sdes' or 'dtls'.<br>


##### stir_shaken

Enable STIR/SHAKEN support on this endpoint. On incoming INVITEs, the Identity header will be checked for validity. On outgoing INVITEs, an Identity header will be added.<br>


##### stir_shaken_profile

A STIR/SHAKEN profile that is defined in stir\_shaken.conf. Contains several options and rules used for STIR/SHAKEN.<br>


##### subscribe_context

If specified, incoming SUBSCRIBE requests will be searched for the matching extension in the indicated context. If no _subscribe\_context_ is specified, then the _context_ setting is used.<br>


##### suppress_q850_reason_headers

Some devices can't accept multiple Reason headers and get confused when both 'SIP' and 'Q.850' Reason headers are received. This option allows the 'Q.850' Reason header to be suppressed.<br>


##### t38_bind_udptl_to_media_address

If media\_address is specified, this option causes the UDPTL instance to be bound to the specified ip address which causes the packets to be sent from that address.<br>


##### t38_udptl

If set to yes T.38 UDPTL support will be enabled, and T.38 negotiation requests will be accepted and relayed.<br>


##### t38_udptl_ec


* `none` - No error correction should be used.<br>

* `fec` - Forward error correction should be used.<br>

* `redundancy` - Redundancy error correction should be used.<br>

##### t38_udptl_ipv6

When enabled the UDPTL stack will use IPv6.<br>


##### t38_udptl_maxdatagram

This option can be set to override the maximum datagram of a remote endpoint for broken endpoints.<br>


##### t38_udptl_nat

When enabled the UDPTL stack will send UDPTL packets to the source address of received packets.<br>


##### tenantid

Sets the tenant ID for this endpoint. When a channel is created, tenantid will be set to this value. It can be changed via dialplan later if needed.<br>


##### timers


* `no`

* `yes`

* `required`

* `always`

* `forced` - Alias of always<br>

##### timers_min_se

Minimum session timer expiration period. Time in seconds.<br>


##### timers_sess_expires

Maximum session timer expiration period. Time in seconds.<br>


##### tos_audio

See https://docs.asterisk.org/Configuration/Channel-Drivers/IP-Quality-of-Service for more information about QoS settings<br>


##### tos_video

See https://docs.asterisk.org/Configuration/Channel-Drivers/IP-Quality-of-Service for more information about QoS settings<br>


##### transport

This will *force* the endpoint to use the specified transport configuration to send SIP messages. You need to already know what kind of transport (UDP/TCP/IPv4/etc) the endpoint device will use.<br>


/// note
Not specifying a transport will select the first configured transport in *pjsip.conf* which is compatible with the URI we are trying to contact.
///


/// warning
Transport configuration is not affected by reloads. In order to change transports, a full Asterisk restart is required
///


##### trust_id_inbound

This option determines whether Asterisk will accept identification from the endpoint from headers such as P-Asserted-Identity or Remote-Party-ID header. This option applies both to calls originating from the endpoint and calls originating from Asterisk. If 'no', the configured Caller-ID from pjsip.conf will always be used as the identity for the endpoint.<br>


##### trust_id_outbound

This option determines whether res\_pjsip will send private identification information to the endpoint. If 'no', private Caller-ID information will not be forwarded to the endpoint. "Private" in this case refers to any method of restricting identification. Example: setting _callerid\_privacy_ to any 'prohib' variation. Example: If _trust\_id\_inbound_ is set to 'yes', the presence of a 'Privacy: id' header in a SIP request or response would indicate the identification provided in the request is private.<br>


##### use_avpf

If set to 'yes', res\_pjsip will use the AVPF or SAVPF RTP profile for all media offers on outbound calls and media updates and will decline media offers not using the AVPF or SAVPF profile.<br>

If set to 'no', res\_pjsip will use the AVP or SAVP RTP profile for all media offers on outbound calls and media updates, and will decline media offers not using the AVP or SAVP profile.<br>


##### webrtc

When set to "yes" this also enables the following values that are needed in order for basic WebRTC support to work: rtcp\_mux, use\_avpf, ice\_support, and use\_received\_transport. The following configuration settings also get defaulted as follows:<br>

media\_encryption=dtls<br>

dtls\_auto\_generate\_cert=yes (if dtls\_cert\_file is not set)<br>

dtls\_verify=fingerprint<br>

dtls\_setup=actpass<br>


### [auth]: Authentication type

Authentication objects hold the authentication information for use by other objects such as 'endpoints' or 'registrations'. This also allows for multiple objects to use a single auth object. See the 'auth\_type' config option for password style choices.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [auth_type](#auth_type)| Custom| userpass| false| Authentication type| |
| [md5_cred](#md5_cred)| String| | false| MD5 Hash used for authentication.| |
| nonce_lifetime| Unsigned Integer| 32| false| Lifetime of a nonce associated with this authentication config.| |
| oauth_clientid| String| | false| OAuth 2.0 application's client id| |
| oauth_secret| String| | false| OAuth 2.0 application's secret| |
| [password](#password)| String| | false| Plain text password used for authentication.| |
| [realm](#realm)| String| | false| SIP realm for endpoint| |
| refresh_token| String| | false| OAuth 2.0 refresh token| |
| type| None| | false| Must be 'auth'| |
| username| String| | false| Username to use for account| |


#### Configuration Option Descriptions

##### auth_type

This option specifies which of the password style config options should be read when trying to authenticate an endpoint inbound request. If set to 'userpass' then we'll read from the 'password' option. For 'md5' we'll read from 'md5\_cred'. If set to 'google\_oauth' then we'll read from the refresh\_token/oauth\_clientid/oauth\_secret fields. The following values are valid:<br>


* `md5`

* `userpass`

* `google_oauth`
<br>


/// note
This setting only describes whether the password is in plain text or has been pre-hashed with MD5. It doesn't describe the acceptable digest algorithms we'll accept in a received challenge.
///


##### md5_cred

Only used when auth\_type is 'md5'. As an alternative to specifying a plain text password, you can hash the username, realm and password together one time and place the hash value here. The input to the hash function must be in the following format:<br>

<br>

<username>:<realm>:<password><br>

<br>

For incoming authentication (asterisk is the server), the realm must match either the realm set in this object or the **default\_realm** set in in the _global_ object.<br>

<br>

For outgoing authentication (asterisk is the UAC), the realm must match what the server will be sending in their WWW-Authenticate header. It can't be blank unless you expect the server to be sending a blank realm in the header. You can't use pre-hashed passwords with a wildcard auth object. You can generate the hash with the following shell command:<br>

<br>

$ echo -n "myname:myrealm:mypassword" | md5sum<br>

<br>

Note the '-n'. You don't want a newline to be part of the hash.<br>


##### password

Only used when auth\_type is 'userpass'.<br>


##### realm

For incoming authentication (asterisk is the UAS), this is the realm to be sent on WWW-Authenticate headers. If not specified, the _global_ object's **default\_realm** will be used.<br>

<br>

For outgoing authentication (asterisk is the UAC), this must either be the realm the server is expected to send, or left blank or contain a single '*' to automatically use the realm sent by the server. If you have multiple auth objects for an endpoint, the realm is also used to match the auth object to the realm the server sent.<br>

<br>


/// note
Using the same auth section for inbound and outbound authentication is not recommended. There is a difference in meaning for an empty realm setting between inbound and outbound authentication uses.
///

<br>


/// note
If more than one auth object with the same realm or more than one wildcard auth object associated to an endpoint, we can only use the first one of each defined on the endpoint.
///


### [domain_alias]: Domain Alias

Signifies that a domain is an alias. If the domain on a session is not found to match an AoR then this object is used to see if we have an alias for the AoR to which the endpoint is binding. This objects name as defined in configuration should be the domain alias and a config option is provided to specify the domain to be aliased.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| domain| String| | false| Domain to be aliased| |
| type| None| | false| Must be of type 'domain_alias'.| |


### [transport]: SIP Transport

*Transports*<br>

There are different transports and protocol derivatives supported by 'res\_pjsip'. They are in order of preference: UDP, TCP, and WebSocket (WS).<br>


/// note
Changes to transport configuration in pjsip.conf will only be effected on a complete restart of Asterisk. A module reload will not suffice.
///


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [allow_reload](#allow_reload)| Boolean| no| false| Allow this transport to be reloaded.| |
| [allow_wildcard_certs](#allow_wildcard_certs)| Custom| | false| Allow use of wildcards in certificates (TLS ONLY)| |
| async_operations| Unsigned Integer| 1| false| Number of simultaneous Asynchronous Operations, can no longer be set, always set to 1| |
| bind| Custom| | false| IP Address and optional port to bind to for this transport| |
| ca_list_file| Custom| | false| File containing a list of certificates to read (TLS ONLY, not WSS)| |
| ca_list_path| Custom| | false| Path to directory containing a list of certificates to read (TLS ONLY, not WSS)| |
| [cert_file](#cert_file)| Custom| | false| Certificate file for endpoint (TLS ONLY, not WSS)| |
| [cipher](#cipher)| Custom| | false| Preferred cryptography cipher names (TLS ONLY, not WSS)| |
| [cos](#cos)| Unsigned Integer| 0| false| Enable COS for the signalling sent over this transport| |
| domain| String| | false| Domain the transport comes from| |
| [external_media_address](#external_media_address)| String| | false| External IP address to use in RTP handling| |
| external_signaling_address| String| | false| External address for SIP signalling| |
| external_signaling_port| Unsigned Integer| 0| false| External port for SIP signalling| |
| [local_net](#local_net)| Custom| | false| Network to consider local (used for NAT purposes).| |
| [method](#method)| Custom| | false| Method of SSL transport (TLS ONLY, not WSS)| |
| password| String| | false| Password required for transport| |
| [priv_key_file](#priv_key_file)| Custom| | false| Private key file (TLS ONLY, not WSS)| |
| [protocol](#protocol)| Custom| udp| false| Protocol to use for SIP traffic| |
| require_client_cert| Custom| | false| Require client certificate (TLS ONLY, not WSS)| |
| [symmetric_transport](#symmetric_transport)| Boolean| no| false| Use the same transport for outgoing requests as incoming ones.| |
| [tcp_keepalive_enable](#tcp_keepalive_enable)| Boolean| no| false| Enable TCP keepalive| |
| [tcp_keepalive_idle_time](#tcp_keepalive_idle_time)| Integer| 30| false| Idle time before the first TCP keepalive probe is sent| |
| [tcp_keepalive_interval_time](#tcp_keepalive_interval_time)| Integer| 1| false| Interval between TCP keepalive probes| |
| [tcp_keepalive_probe_count](#tcp_keepalive_probe_count)| Integer| 5| false| Maximum number of TCP keepalive probes| |
| [tos](#tos)| Custom| 0| false| Enable TOS for the signalling sent over this transport| |
| type| Custom| | false| Must be of type 'transport'.| |
| verify_client| Custom| | false| Require verification of client certificate (TLS ONLY, not WSS)| |
| verify_server| Custom| | false| Require verification of server certificate (TLS ONLY, not WSS)| |
| [websocket_write_timeout](#websocket_write_timeout)| Integer| 100| false| The timeout (in milliseconds) to set on WebSocket connections.| |


#### Configuration Option Descriptions

##### allow_reload

Allow this transport to be reloaded when res\_pjsip is reloaded. This option defaults to "no" because reloading a transport may disrupt in-progress calls.<br>


##### allow_wildcard_certs

In combination with verify\_server, when enabled allow use of wildcards, i.e. '*.' in certs for common,and subject alt names of type DNS for TLS transport types. Names must start with the wildcard. Partial wildcards, e.g. 'f*.example.com' and 'foo.*.com' are not allowed. As well, names only match against a single level meaning '*.example.com' matches 'foo.example.com', but not 'foo.bar.example.com'.<br>


##### cert_file

A path to a .crt or .pem file can be provided. However, only the certificate is read from the file, not the private key. The 'priv\_key\_file' option must supply a matching key file. The certificate file can be reloaded if the filename in configuration remains unchanged.<br>


##### cipher

Comma separated list of cipher names or numeric equivalents. Numeric equivalents can be either decimal or hexadecimal (0xX).<br>

There are many cipher names. Use the CLI command 'pjsip list ciphers' to see a list of cipher names available for your installation. See link for more:<br>

http://www.openssl.org/docs/apps/ciphers.html#CIPHER\_SUITE\_NAMES<br>


##### cos

See 'https://docs.asterisk.org/Configuration/Channel-Drivers/IP-Quality-of-Service' for more information on this parameter.<br>


/// note
This option does not apply to the _ws_ or the _wss_ protocols.
///


##### external_media_address

When a request or response is sent out, if the destination of the message is outside the IP network defined in the option 'localnet', and the media address in the SDP is within the localnet network, then the media address in the SDP will be rewritten to the value defined for 'external\_media\_address'.<br>


##### local_net

This must be in CIDR or dotted decimal format with the IP and mask separated with a slash ('/').<br>


##### method

The availability of each of these options is dependent on the version and configuration of the underlying PJSIP library.<br>


* `default` - The default as defined by PJSIP. This is currently TLSv1, but may change with future releases.<br>

* `unspecified` - This option is equivalent to setting 'default'<br>

* `tlsv1`

* `tlsv1_1`

* `tlsv1_2`

* `tlsv1_3`

* `sslv2`

* `sslv3`

* `sslv23`

##### priv_key_file

A path to a key file can be provided. The private key file can be reloaded if the filename in configuration remains unchanged.<br>


##### protocol


* `udp`

* `tcp`

* `tls`

* `ws`

* `wss`

* `flow`

##### symmetric_transport

When a request from a dynamic contact comes in on a transport with this option set to 'yes', the transport name will be saved and used for subsequent outgoing requests like OPTIONS, NOTIFY and INVITE. It's saved as a contact uri parameter named 'x-ast-txp' and will display with the contact uri in CLI, AMI, and ARI output. On the outgoing request, if a transport wasn't explicitly set on the endpoint AND the request URI is not a hostname, the saved transport will be used and the 'x-ast-txp' parameter stripped from the outgoing packet.<br>


##### tcp_keepalive_enable

When set to 'yes', TCP keepalive messages are sent to verify that the endpoint is still reachable. This can help detect dead TCP connections in environments where connections may be silently dropped (e.g., NAT timeouts).<br>


##### tcp_keepalive_idle_time

Specifies the amount of time in seconds that the connection must be idle before the first TCP keepalive probe is sent. An idle connection is defined as a connection in which no data has been sent or received by the application.<br>


##### tcp_keepalive_interval_time

Specifies the interval in seconds between individual TCP keepalive probes, once the first probe is sent. This interval is used for subsequent probes if the peer does not respond to the previous probe.<br>


##### tcp_keepalive_probe_count

Specifies the maximum number of TCP keepalive probes to send before considering the connection dead and notifying the application. If the peer does not respond after this many probes, the connection is considered broken.<br>


##### tos

See 'https://docs.asterisk.org/Configuration/Channel-Drivers/IP-Quality-of-Service' for more information on this parameter.<br>


/// note
This option does not apply to the _ws_ or the _wss_ protocols.
///


##### websocket_write_timeout

If a websocket connection accepts input slowly, the timeout for writes to it can be increased to keep it from being disconnected. Value is in milliseconds.<br>


### [contact]: A way of creating an aliased name to a SIP URI

Contacts are a way to hide SIP URIs from the dialplan directly. They are also used to make a group of contactable parties when in use with 'AoR' lists.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [authenticate_qualify](#authenticate_qualify)| Boolean| no| false| Authenticates a qualify challenge response if needed| |
| [call_id](#call_id)| String| | false| Call-ID header from registration.| |
| [endpoint](#endpoint)| String| | false| Endpoint name| |
| [expiration_time](#expiration_time)| Custom| | false| Time to keep alive a contact| |
| [outbound_proxy](#outbound_proxy)| String| | false| Outbound proxy used when sending OPTIONS request| |
| path| String| | false| Stored Path vector for use in Route headers on outgoing requests.| |
| [prune_on_boot](#prune_on_boot)| Boolean| no| false| A contact that cannot survive a restart/boot.| |
| [qualify_frequency](#qualify_frequency)| Unsigned Integer| 0| false| Interval at which to qualify a contact| |
| [qualify_timeout](#qualify_timeout)| Double| 3.0| false| Timeout for qualify| |
| [reg_server](#reg_server)| String| | false| Asterisk Server name| |
| type| None| | false| Must be of type 'contact'.| |
| uri| String| | false| SIP URI to contact peer| |
| [user_agent](#user_agent)| String| | false| User-Agent header from registration.| |
| [via_addr](#via_addr)| String| | false| IP-address of the last Via header from registration.| |
| [via_port](#via_port)| Unsigned Integer| 0| false| IP-port of the last Via header from registration.| |


#### Configuration Option Descriptions

##### authenticate_qualify

If true and a qualify request receives a challenge response then authentication is attempted before declaring the contact available.<br>


/// note
This option does nothing as we will always complete the challenge response authentication if the qualify request is challenged.
///


##### call_id

The Call-ID header is automatically stored based on data present in incoming SIP REGISTER requests and is not intended to be configured manually.<br>


##### endpoint

The name of the endpoint this contact belongs to<br>


##### expiration_time

Time to keep alive a contact. String style specification.<br>


##### outbound_proxy

If set the provided URI will be used as the outbound proxy when an OPTIONS request is sent to a contact for qualify purposes.<br>


##### prune_on_boot

The option is set if the incoming SIP REGISTER contact is rewritten on a reliable transport and is not intended to be configured manually.<br>


##### qualify_frequency

Interval between attempts to qualify the contact for reachability. If '0' never qualify. Time in seconds.<br>


##### qualify_timeout

If the contact doesn't respond to the OPTIONS request before the timeout, the contact is marked unavailable. This includes time spent performing any required DNS lookup(s) prior to sending the OPTIONS. If '0' no timeout. Time in fractional seconds.<br>


##### reg_server

Asterisk Server name on which SIP endpoint registered.<br>


##### user_agent

The User-Agent is automatically stored based on data present in incoming SIP REGISTER requests and is not intended to be configured manually.<br>


##### via_addr

The last Via header should contain the address of UA which sent the request. The IP-address of the last Via header is automatically stored based on data present in incoming SIP REGISTER requests and is not intended to be configured manually.<br>


##### via_port

The IP-port of the last Via header is automatically stored based on data present in incoming SIP REGISTER requests and is not intended to be configured manually.<br>


### [aor]: The configuration for a location of an endpoint

An AoR is what allows Asterisk to contact an endpoint via res\_pjsip. If no AoRs are specified, an endpoint will not be reachable by Asterisk. Beyond that, an AoR has other uses within Asterisk, such as inbound registration.<br>

An 'AoR' is a way to allow dialing a group of 'Contacts' that all use the same 'endpoint' for calls.<br>

This can be used as another way of grouping a list of contacts to dial rather than specifying them each directly when dialing via the dialplan. This must be used in conjunction with the 'PJSIP\_DIAL\_CONTACTS'.<br>

Registrations: For Asterisk to match an inbound registration to an endpoint, the AoR object name must match the user portion of the SIP URI in the "To:" header of the inbound SIP registration. That will usually be equivalent to the "user name" set in your hard or soft phones configuration.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [authenticate_qualify](#authenticate_qualify)| Boolean| no| false| Authenticates a qualify challenge response if needed| |
| [contact](#contact)| Custom| | false| Permanent contacts assigned to AoR| |
| default_expiration| Unsigned Integer| 3600| false| Default expiration time in seconds for contacts that are dynamically bound to an AoR.| |
| [mailboxes](#mailboxes)| String| | false| Allow subscriptions for the specified mailbox(es)| |
| [max_contacts](#max_contacts)| Unsigned Integer| 0| false| Maximum number of contacts that can bind to an AoR| |
| [maximum_expiration](#maximum_expiration)| Unsigned Integer| 7200| false| Maximum time to keep an AoR| |
| [minimum_expiration](#minimum_expiration)| Unsigned Integer| 60| false| Minimum keep alive time for an AoR| |
| [outbound_proxy](#outbound_proxy)| String| | false| Outbound proxy used when sending OPTIONS request| |
| [qualify_frequency](#qualify_frequency)| Unsigned Integer| 0| false| Interval at which to qualify an AoR| |
| [qualify_timeout](#qualify_timeout)| Double| 3.0| false| Timeout for qualify| |
| [remove_existing](#remove_existing)| Boolean| no| false| Determines whether new contacts replace existing ones.| |
| [remove_unavailable](#remove_unavailable)| Boolean| no| false| Determines whether new contacts should replace unavailable ones.| |
| [support_path](#support_path)| Boolean| no| false| Enables Path support for REGISTER requests and Route support for other requests.| |
| type| None| | false| Must be of type 'aor'.| |
| voicemail_extension| Custom| | false| The voicemail extension to send in the NOTIFY Message-Account header| |


#### Configuration Option Descriptions

##### authenticate_qualify

If true and a qualify request receives a challenge response then authentication is attempted before declaring the contact available.<br>


/// note
This option does nothing as we will always complete the challenge response authentication if the qualify request is challenged.
///


##### contact

Contacts specified will be called whenever referenced by 'chan\_pjsip'.<br>

Use a separate "contact=" entry for each contact required. Contacts are specified using a SIP URI.<br>


##### mailboxes

This option applies when an external entity subscribes to an AoR for Message Waiting Indications. The mailboxes specified will be subscribed to. More than one mailbox can be specified with a comma-delimited string. app\_voicemail mailboxes must be specified as mailbox@context; for example: mailboxes=6001@default. For mailboxes provided by external sources, such as through the res\_mwi\_external module, you must specify strings supported by the external system.<br>

For endpoints that cannot SUBSCRIBE for MWI, you can set the 'mailboxes' option in your endpoint configuration section to enable unsolicited MWI NOTIFYs to the endpoint.<br>


##### max_contacts

Maximum number of contacts that can associate with this AoR. This value does not affect the number of contacts that can be added with the "contact" option. It only limits contacts added through external interaction, such as registration.<br>


/// note
The _rewrite\_contact_ option registers the source address as the contact address to help with NAT and reusing connection oriented transports such as TCP and TLS. Unfortunately, refreshing a registration may register a different contact address and exceed _max\_contacts_. The _remove\_existing_ and _remove\_unavailable_ options can help by removing either the soonest to expire or unavailable contact(s) over _max\_contacts_ which is likely the old _rewrite\_contact_ contact source address being refreshed.
///


/// note
This should be set to '1' and _remove\_existing_ set to 'yes' if you wish to stick with the older 'chan\_sip' behaviour.
///


##### maximum_expiration

Maximum time to keep a peer with explicit expiration. Time in seconds.<br>


##### minimum_expiration

Minimum time to keep a peer with an explicit expiration. Time in seconds.<br>


##### outbound_proxy

If set the provided URI will be used as the outbound proxy when an OPTIONS request is sent to a contact for qualify purposes.<br>


##### qualify_frequency

Interval between attempts to qualify the AoR for reachability. If '0' never qualify. Time in seconds.<br>


##### qualify_timeout

If the contact doesn't respond to the OPTIONS request before the timeout, the contact is marked unavailable. This includes time spent performing any required DNS lookup(s) prior to sending the OPTIONS. If '0' no timeout. Time in fractional seconds.<br>


##### remove_existing

On receiving a new registration to the AoR should it remove enough existing contacts not added or updated by the registration to satisfy _max\_contacts_? Any removed contacts will expire the soonest.<br>


/// note
The _rewrite\_contact_ option registers the source address as the contact address to help with NAT and reusing connection oriented transports such as TCP and TLS. Unfortunately, refreshing a registration may register a different contact address and exceed _max\_contacts_. The _remove\_existing_ option can help by removing the soonest to expire contact(s) over _max\_contacts_ which is likely the old _rewrite\_contact_ contact source address being refreshed.
///


/// note
This should be set to 'yes' and _max\_contacts_ set to '1' if you wish to stick with the older 'chan\_sip' behaviour.
///


##### remove_unavailable

The effect of this setting depends on the setting of _remove\_existing_.<br>

If _remove\_existing_ is set to 'no' (default), setting remove\_unavailable to 'yes' will remove only unavailable contacts that exceed _max\_contacts_to allow an incoming REGISTER to complete sucessfully.<br>

If _remove\_existing_ is set to 'yes', setting remove\_unavailable to 'yes' will prioritize unavailable contacts for removal instead of just removing the contact that expires the soonest.<br>


/// note
See _remove\_existing_ and _max\_contacts_ for further information about how these 3 settings interact.
///


##### support_path

When this option is enabled, the Path headers in register requests will be saved and its contents will be used in Route headers for outbound out-of-dialog requests and in Path headers for outbound 200 responses. Path support will also be indicated in the Supported header.<br>


### [system]: Options that apply to the SIP stack as well as other system-wide settings

The settings in this section are global. In addition to being global, the values will not be re-evaluated when a reload is performed. This is because the values must be set before the SIP stack is initialized. The only way to reset these values is to either restart Asterisk, or unload res\_pjsip.so and then load it again.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [accept_multiple_sdp_answers](#accept_multiple_sdp_answers)| Boolean| no| false| Follow SDP forked media when To tag is the same| |
| compact_headers| Boolean| no| false| Use the short forms of common SIP header names.| |
| [disable_rport](#disable_rport)| Boolean| no| false| Disable the use of rport in outgoing requests.| |
| [disable_tcp_switch](#disable_tcp_switch)| Boolean| yes| false| Disable automatic switching from UDP to TCP transports.| |
| [follow_early_media_fork](#follow_early_media_fork)| Boolean| yes| false| Follow SDP forked media when To tag is different| |
| threadpool_auto_increment| Unsigned Integer| 5| false| The amount by which the number of threads is incremented when necessary.| |
| threadpool_idle_timeout| Unsigned Integer| 60| false| Number of seconds before an idle thread should be disposed of.| |
| threadpool_initial_size| Unsigned Integer| 0| false| Initial number of threads in the res_pjsip threadpool.| |
| threadpool_max_size| Unsigned Integer| 50| false| Maximum number of threads in the res_pjsip threadpool. A value of 0 indicates no maximum.| |
| [timer_b](#timer_b)| Unsigned Integer| 32000| false| Set transaction timer B value (milliseconds).| |
| [timer_t1](#timer_t1)| Unsigned Integer| 500| false| Set transaction timer T1 value (milliseconds).| |
| type| None| | false| Must be of type 'system' UNLESS the object name is 'system'.| |


#### Configuration Option Descriptions

##### accept_multiple_sdp_answers

On outgoing calls, if the UAS responds with different SDP attributes on non-100rel 18X or 2XX responses (such as a port update) AND the To tag on the subsequent response is the same as that on the previous one, process the updated SDP.<br>


/// note
This option must also be enabled on endpoints that require this functionality.
///


##### disable_rport

Remove "rport" parameter from the outgoing requests.<br>


##### disable_tcp_switch

Disable automatic switching from UDP to TCP transports if outgoing request is too large. See RFC 3261 section 18.1.1.<br>


##### follow_early_media_fork

On outgoing calls, if the UAS responds with different SDP attributes on subsequent 18X or 2XX responses (such as a port update) AND the To tag on the subsequent response is different than that on the previous one, follow it.<br>


/// note
This option must also be enabled on endpoints that require this functionality.
///


##### timer_b

Timer B determines the maximum amount of time to wait after sending an INVITE request before terminating the transaction. It is recommended that this be set to 64 * Timer T1, but it may be set higher if desired. For more information on this timer, see RFC 3261, Section 17.1.1.1.<br>


##### timer_t1

Timer T1 is the base for determining how long to wait before retransmitting requests that receive no response when using an unreliable transport (e.g. UDP). For more information on this timer, see RFC 3261, Section 17.1.1.1.<br>


### [global]: Options that apply globally to all SIP communications

The settings in this section are global. Unlike options in the 'system' section, these options can be refreshed by performing a reload.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [all_codecs_on_empty_reinvite](#all_codecs_on_empty_reinvite)| Boolean| no| false| If we should return all codecs on re-INVITE without SDP| |
| [allow_sending_180_after_183](#allow_sending_180_after_183)| Boolean| no| false| Allow 180 after 183| |
| contact_expiration_check_interval| Unsigned Integer| 30| false| The interval (in seconds) to check for expired contacts.| |
| debug| String| no| false| Enable/Disable SIP debug logging. Valid options include yes, no, or a host address| |
| default_from_user| String| asterisk| false| When Asterisk generates an outgoing SIP request, the From header username will be set to this value if there is no better option (such as CallerID) to be used.| |
| default_outbound_endpoint| String| default_outbound_endpoint| false| Endpoint to use when sending an outbound request to a URI without a specified endpoint.| |
| default_realm| String| asterisk| false| When Asterisk generates a challenge, the digest realm will be set to this value if there is no better option (such as auth/realm) to be used.| |
| default_voicemail_extension| String| | false| The voicemail extension to send in the NOTIFY Message-Account header if not specified on endpoint or aor| |
| [disable_multi_domain](#disable_multi_domain)| Boolean| no| false| Disable Multi Domain support| |
| [endpoint_identifier_order](#endpoint_identifier_order)| String| ip,username,anonymous| false| The order by which endpoint identifiers are processed and checked. Identifier names are usually derived from and can be found in the endpoint identifier module itself (res_pjsip_endpoint_identifier_*). You can use the CLI command "pjsip show identifiers" to see the identifiers currently available.| |
| [ignore_uri_user_options](#ignore_uri_user_options)| Boolean| no| false| Enable/Disable ignoring SIP URI user field options.| |
| keep_alive_interval| Unsigned Integer| 90| false| The interval (in seconds) to send keepalives to active connection-oriented transports.| |
| max_forwards| Unsigned Integer| 70| false| Value used in Max-Forwards header for SIP requests.| |
| max_initial_qualify_time| Unsigned Integer| 0| false| The maximum amount of time from startup that qualifies should be attempted on all contacts. If greater than the qualify_frequency for an aor, qualify_frequency will be used instead.| |
| [mwi_disable_initial_unsolicited](#mwi_disable_initial_unsolicited)| Boolean| no| false| Enable/Disable sending unsolicited MWI to all endpoints on startup.| |
| [mwi_tps_queue_high](#mwi_tps_queue_high)| Unsigned Integer| 500| false| MWI taskprocessor high water alert trigger level.| |
| [mwi_tps_queue_low](#mwi_tps_queue_low)| Integer| -1| false| MWI taskprocessor low water clear alert level.| |
| norefersub| Boolean| yes| false| Advertise support for RFC4488 REFER subscription suppression| |
| regcontext| String| | false| When set, Asterisk will dynamically create and destroy a NoOp priority 1 extension for a given peer who registers or unregisters with us.| |
| send_contact_status_on_update_registration| Boolean| no| false| Enable sending AMI ContactStatus event when a device refreshes its registration.| |
| [taskprocessor_overload_trigger](#taskprocessor_overload_trigger)| Custom| global| false| Trigger scope for taskprocessor overloads| |
| type| None| | false| Must be of type 'global' UNLESS the object name is 'global'.| |
| [unidentified_request_count](#unidentified_request_count)| Unsigned Integer| 5| false| The number of unidentified requests from a single IP to allow.| |
| [unidentified_request_period](#unidentified_request_period)| Unsigned Integer| 5| false| The number of seconds over which to accumulate unidentified requests.| |
| unidentified_request_prune_interval| Unsigned Integer| 30| false| The interval at which unidentified requests are older than twice the unidentified_request_period are pruned.| |
| [use_callerid_contact](#use_callerid_contact)| Boolean| no| false| Place caller-id information into Contact header| |
| user_agent| String| Asterisk PBX GIT-18-7cc2a30c08| false| Value used in User-Agent header for SIP requests and Server header for SIP responses.| |


#### Configuration Option Descriptions

##### all_codecs_on_empty_reinvite

On reception of a re-INVITE without SDP Asterisk will send an SDP offer in the 200 OK response containing all configured codecs on the endpoint, instead of simply those that have already been negotiated. RFC 3261 specifies this as a SHOULD requirement.<br>


##### allow_sending_180_after_183

Allow Asterisk to send 180 Ringing to an endpoint after 183 Session Progress has been send. If disabled Asterisk will instead send only a 183 Session Progress to the endpoint. (default: "no")<br>


##### disable_multi_domain

If disabled it can improve realtime performance by reducing the number of database requests.<br>


##### endpoint_identifier_order


/// note
One of the identifiers is "auth\_username" which matches on the username in an Authentication header. This method has some security considerations because an Authentication header is not present on the first message of a dialog when digest authentication is used. The client can't generate it until the server sends the challenge in a 401 response. Since Asterisk normally sends a security event when an incoming request can't be matched to an endpoint, using auth\_username requires that the security event be deferred until a request is received with the Authentication header and only generated if the username doesn't result in a match. This may result in a delay before an attack is recognized. You can control how many unmatched requests are received from a single ip address before a security event is generated using the unidentified\_request parameters.
///


##### ignore_uri_user_options

If you have this option enabled and there are semicolons in the user field of a SIP URI then the field is truncated at the first semicolon. This effectively makes the semicolon a non-usable character for PJSIP endpoint names, extensions, and AORs. This can be useful for improving compatibility with an ITSP that likes to use user options for whatever reason.<br>

``` title="Example: Sample SIP URI"

sip:1235557890;phone-context=national@x.x.x.x;user=phone

						
```
``` title="Example: Sample SIP URI user field"

1235557890;phone-context=national

						
```
``` title="Example: Sample SIP URI user field truncated"

1235557890

						
```

/// note
The caller-id and redirecting number strings obtained from incoming SIP URI user fields are always truncated at the first semicolon.
///


##### mwi_disable_initial_unsolicited

When the initial unsolicited MWI notification are enabled on startup then the initial notifications get sent at startup. If you have a lot of endpoints (thousands) that use unsolicited MWI then you may want to consider disabling the initial startup notifications.<br>

When the initial unsolicited MWI notifications are disabled on startup then the notifications will start on the endpoint's next contact update.<br>


##### mwi_tps_queue_high

On a heavily loaded system you may need to adjust the taskprocessor queue limits. If any taskprocessor queue size reaches its high water level then pjsip will stop processing new requests until the alert is cleared. The alert clears when all alerting taskprocessor queues have dropped to their low water clear level.<br>


##### mwi_tps_queue_low

On a heavily loaded system you may need to adjust the taskprocessor queue limits. If any taskprocessor queue size reaches its high water level then pjsip will stop processing new requests until the alert is cleared. The alert clears when all alerting taskprocessor queues have dropped to their low water clear level.<br>


/// note
Set to -1 for the low water level to be 90% of the high water level.
///


##### taskprocessor_overload_trigger

This option specifies the trigger the distributor will use for detecting taskprocessor overloads. When it detects an overload condition, the distrubutor will stop accepting new requests until the overload is cleared.<br>


* `global` - (default) Any taskprocessor overload will trigger.<br>

* `pjsip_only` - Only pjsip taskprocessor overloads will trigger.<br>

* `none` - No overload detection will be performed.<br>

/// warning
The "none" and "pjsip\_only" options should be used with extreme caution and only to mitigate specific issues. Under certain conditions they could make things worse.
///


##### unidentified_request_count

If 'unidentified\_request\_count' unidentified requests are received during 'unidentified\_request\_period', a security event will be generated.<br>


##### unidentified_request_period

If 'unidentified\_request\_count' unidentified requests are received during 'unidentified\_request\_period', a security event will be generated.<br>


##### use_callerid_contact

This option will cause Asterisk to place caller-id information into generated Contact headers.<br>



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 