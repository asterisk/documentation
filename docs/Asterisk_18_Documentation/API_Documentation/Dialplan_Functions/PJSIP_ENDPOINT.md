---
search:
  boost: 0.5
title: PJSIP_ENDPOINT
---

# PJSIP_ENDPOINT()

### Synopsis

Get information about a PJSIP endpoint

### Description

### Syntax


```

PJSIP_ENDPOINT(name,field)
```
##### Arguments


* `name` - The name of the endpoint to query.<br>

* `field` - The configuration option for the endpoint to query for. Supported options are those fields on the _endpoint_ object in *pjsip.conf*.<br>

    * `100rel` - Allow support for RFC3262 provisional ACK tags<br>

    * `aggregate_mwi` - Condense MWI notifications into a single NOTIFY.<br>

    * `allow` - Media Codec(s) to allow<br>

    * `codec_prefs_incoming_offer` - Codec negotiation prefs for incoming offers.<br>

    * `codec_prefs_outgoing_offer` - Codec negotiation prefs for outgoing offers.<br>

    * `codec_prefs_incoming_answer` - Codec negotiation prefs for incoming answers.<br>

    * `codec_prefs_outgoing_answer` - Codec negotiation prefs for outgoing answers.<br>

    * `allow_overlap` - Enable RFC3578 overlap dialing support.<br>

    * `overlap_context` - Dialplan context to use for RFC3578 overlap dialing.<br>

    * `aors` - AoR(s) to be used with the endpoint<br>

    * `auth` - Authentication Object(s) associated with the endpoint<br>

    * `callerid` - CallerID information for the endpoint<br>

    * `callerid_privacy` - Default privacy level<br>

    * `callerid_tag` - Internal id\_tag for the endpoint<br>

    * `context` - Dialplan context for inbound sessions<br>

    * `direct_media_glare_mitigation` - Mitigation of direct media (re)INVITE glare<br>

    * `direct_media_method` - Direct Media method type<br>

    * `trust_connected_line` - Accept Connected Line updates from this endpoint<br>

    * `send_connected_line` - Send Connected Line updates to this endpoint<br>

    * `connected_line_method` - Connected line method type<br>

    * `direct_media` - Determines whether media may flow directly between endpoints.<br>

    * `disable_direct_media_on_nat` - Disable direct media session refreshes when NAT obstructs the media session<br>

    * `disallow` - Media Codec(s) to disallow<br>

    * `dtmf_mode` - DTMF mode<br>

    * `media_address` - IP address used in SDP for media handling<br>

    * `bind_rtp_to_media_address` - Bind the RTP instance to the media\_address<br>

    * `force_rport` - Force use of return port<br>

    * `ice_support` - Enable the ICE mechanism to help traverse NAT<br>

    * `identify_by` - Way(s) for the endpoint to be identified<br>

    * `redirect_method` - How redirects received from an endpoint are handled<br>

    * `mailboxes` - NOTIFY the endpoint when state changes for any of the specified mailboxes<br>

    * `mwi_subscribe_replaces_unsolicited` - An MWI subscribe will replace sending unsolicited NOTIFYs<br>

    * `voicemail_extension` - The voicemail extension to send in the NOTIFY Message-Account header<br>

    * `moh_suggest` - Default Music On Hold class<br>

    * `outbound_auth` - Authentication object(s) used for outbound requests<br>

    * `outbound_proxy` - Full SIP URI of the outbound proxy used to send requests<br>

    * `rewrite_contact` - Allow Contact header to be rewritten with the source IP address-port<br>

    * `rtp_ipv6` - Allow use of IPv6 for RTP traffic<br>

    * `rtp_symmetric` - Enforce that RTP must be symmetric<br>

    * `send_diversion` - Send the Diversion header, conveying the diversion information to the called user agent<br>

    * `send_history_info` - Send the History-Info header, conveying the diversion information to the called and calling user agents<br>

    * `send_pai` - Send the P-Asserted-Identity header<br>

    * `send_rpid` - Send the Remote-Party-ID header<br>

    * `rpid_immediate` - Immediately send connected line updates on unanswered incoming calls.<br>

    * `tenantid` - The tenant ID for this endpoint.<br>

    * `timers_min_se` - Minimum session timers expiration period<br>

    * `timers` - Session timers for SIP packets<br>

    * `timers_sess_expires` - Maximum session timer expiration period<br>

    * `transport` - Explicit transport configuration to use<br>

    * `trust_id_inbound` - Accept identification information received from this endpoint<br>

    * `trust_id_outbound` - Send private identification details to the endpoint.<br>

    * `type` - Must be of type 'endpoint'.<br>

    * `use_ptime` - Use Endpoint's requested packetization interval<br>

    * `use_avpf` - Determines whether res\_pjsip will use and enforce usage of AVPF for this endpoint.<br>

    * `force_avp` - Determines whether res\_pjsip will use and enforce usage of AVP, regardless of the RTP profile in use for this endpoint.<br>

    * `media_use_received_transport` - Determines whether res\_pjsip will use the media transport received in the offer SDP in the corresponding answer SDP.<br>

    * `media_encryption` - Determines whether res\_pjsip will use and enforce usage of media encryption for this endpoint.<br>

    * `media_encryption_optimistic` - Determines whether encryption should be used if possible but does not terminate the session if not achieved.<br>

    * `g726_non_standard` - Force g.726 to use AAL2 packing order when negotiating g.726 audio<br>

    * `inband_progress` - Determines whether chan\_pjsip will indicate ringing using inband progress.<br>

    * `call_group` - The numeric pickup groups for a channel.<br>

    * `pickup_group` - The numeric pickup groups that a channel can pickup.<br>

    * `named_call_group` - The named pickup groups for a channel.<br>

    * `named_pickup_group` - The named pickup groups that a channel can pickup.<br>

    * `device_state_busy_at` - The number of in-use channels which will cause busy to be returned as device state<br>

    * `t38_udptl` - Whether T.38 UDPTL support is enabled or not<br>

    * `t38_udptl_ec` - T.38 UDPTL error correction method<br>

    * `t38_udptl_maxdatagram` - T.38 UDPTL maximum datagram size<br>

    * `fax_detect` - Whether CNG tone detection is enabled<br>

    * `fax_detect_timeout` - How long into a call before fax\_detect is disabled for the call<br>

    * `t38_udptl_nat` - Whether NAT support is enabled on UDPTL sessions<br>

    * `t38_udptl_ipv6` - Whether IPv6 is used for UDPTL Sessions<br>

    * `t38_bind_udptl_to_media_address` - Bind the UDPTL instance to the media\_adress<br>

    * `tone_zone` - Set which country's indications to use for channels created for this endpoint.<br>

    * `language` - Set the default language to use for channels created for this endpoint.<br>

    * `one_touch_recording` - Determines whether one-touch recording is allowed for this endpoint.<br>

    * `record_on_feature` - The feature to enact when one-touch recording is turned on.<br>

    * `record_off_feature` - The feature to enact when one-touch recording is turned off.<br>

    * `rtp_engine` - Name of the RTP engine to use for channels created for this endpoint<br>

    * `allow_transfer` - Determines whether SIP REFER transfers are allowed for this endpoint<br>

    * `user_eq_phone` - Determines whether a user=phone parameter is placed into the request URI if the user is determined to be a phone number<br>

    * `moh_passthrough` - Determines whether hold and unhold will be passed through using re-INVITEs with recvonly and sendrecv to the remote side<br>

    * `sdp_owner` - String placed as the username portion of an SDP origin (o=) line.<br>

    * `sdp_session` - String used for the SDP session (s=) line.<br>

    * `tos_audio` - DSCP TOS bits for audio streams<br>

    * `tos_video` - DSCP TOS bits for video streams<br>

    * `cos_audio` - Priority for audio streams<br>

    * `cos_video` - Priority for video streams<br>

    * `allow_subscribe` - Determines if endpoint is allowed to initiate subscriptions with Asterisk.<br>

    * `sub_min_expiry` - The minimum allowed expiry time for subscriptions initiated by the endpoint.<br>

    * `from_user` - Username to use in From header for requests to this endpoint.<br>

    * `mwi_from_user` - Username to use in From header for unsolicited MWI NOTIFYs to this endpoint.<br>

    * `from_domain` - Domain to use in From header for requests to this endpoint.<br>

    * `dtls_verify` - Verify that the provided peer certificate is valid<br>

    * `dtls_rekey` - Interval at which to renegotiate the TLS session and rekey the SRTP session<br>

    * `dtls_auto_generate_cert` - Whether or not to automatically generate an ephemeral X.509 certificate<br>

    * `dtls_cert_file` - Path to certificate file to present to peer<br>

    * `dtls_private_key` - Path to private key for certificate file<br>

    * `dtls_cipher` - Cipher to use for DTLS negotiation<br>

    * `dtls_ca_file` - Path to certificate authority certificate<br>

    * `dtls_ca_path` - Path to a directory containing certificate authority certificates<br>

    * `dtls_setup` - Whether we are willing to accept connections, connect to the other party, or both.<br>

    * `dtls_fingerprint` - Type of hash to use for the DTLS fingerprint in the SDP.<br>

    * `srtp_tag_32` - Determines whether 32 byte tags should be used instead of 80 byte tags.<br>

    * `set_var` - Variable set on a channel involving the endpoint.<br>

    * `message_context` - Context to route incoming MESSAGE requests to.<br>

    * `accountcode` - An accountcode to set automatically on any channels created for this endpoint.<br>

    * `preferred_codec_only` - Respond to a SIP invite with the single most preferred codec (DEPRECATED)<br>

    * `incoming_call_offer_pref` - Preferences for selecting codecs for an incoming call.<br>

    * `outgoing_call_offer_pref` - Preferences for selecting codecs for an outgoing call.<br>

    * `rtp_keepalive` - Number of seconds between RTP comfort noise keepalive packets.<br>

    * `rtp_timeout` - Maximum number of seconds without receiving RTP (while off hold) before terminating call.<br>

    * `rtp_timeout_hold` - Maximum number of seconds without receiving RTP (while on hold) before terminating call.<br>

    * `acl` - List of IP ACL section names in acl.conf<br>

    * `deny` - List of IP addresses to deny access from<br>

    * `permit` - List of IP addresses to permit access from<br>

    * `contact_acl` - List of Contact ACL section names in acl.conf<br>

    * `contact_deny` - List of Contact header addresses to deny<br>

    * `contact_permit` - List of Contact header addresses to permit<br>

    * `subscribe_context` - Context for incoming MESSAGE requests.<br>

    * `contact_user` - Force the user on the outgoing Contact header to this value.<br>

    * `asymmetric_rtp_codec` - Allow the sending and receiving RTP codec to differ<br>

    * `rtcp_mux` - Enable RFC 5761 RTCP multiplexing on the RTP port<br>

    * `refer_blind_progress` - Whether to notifies all the progress details on blind transfer<br>

    * `notify_early_inuse_ringing` - Whether to notifies dialog-info 'early' on InUse&Ringing state<br>

    * `max_audio_streams` - The maximum number of allowed audio streams for the endpoint<br>

    * `max_video_streams` - The maximum number of allowed video streams for the endpoint<br>

    * `bundle` - Enable RTP bundling<br>

    * `webrtc` - Defaults and enables some options that are relevant to WebRTC<br>

    * `incoming_mwi_mailbox` - Mailbox name to use when incoming MWI NOTIFYs are received<br>

    * `follow_early_media_fork` - Follow SDP forked media when To tag is different<br>

    * `accept_multiple_sdp_answers` - Accept multiple SDP answers on non-100rel responses<br>

    * `suppress_q850_reason_headers` - Suppress Q.850 Reason headers for this endpoint<br>

    * `ignore_183_without_sdp` - Do not forward 183 when it doesn't contain SDP<br>

    * `stir_shaken` - Enable STIR/SHAKEN support on this endpoint<br>

    * `stir_shaken_profile` - STIR/SHAKEN profile containing additional configuration options<br>

    * `allow_unauthenticated_options` - Skip authentication when receiving OPTIONS requests<br>

    * `security_negotiation` - The kind of security agreement negotiation to use. Currently, only mediasec is supported.<br>

    * `security_mechanisms` - List of security mechanisms supported.<br>

    * `geoloc_incoming_call_profile` - Geolocation profile to apply to incoming calls<br>

    * `geoloc_outgoing_call_profile` - Geolocation profile to apply to outgoing calls<br>

    * `send_aoc` - Send Advice-of-Charge messages<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 