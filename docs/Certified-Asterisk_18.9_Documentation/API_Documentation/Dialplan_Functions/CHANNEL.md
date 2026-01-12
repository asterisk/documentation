---
search:
  boost: 0.5
title: CHANNEL
---

# CHANNEL()

### Synopsis

Gets/sets various pieces of information about the channel.

### Description

Gets/sets various pieces of information about the channel, additional _item_ may be available from the channel driver; see its documentation for details. Any _item_ requested that is not available on the current channel will return an empty string.<br>

``` title="Example: Standard CHANNEL item examples"

; Push a hangup handler subroutine existing at dialplan
; location default,s,1 onto the current channel
same => n,Set(CHANNEL(hangup_handler_push)=default,s,1)

; Set the current tonezone to Germany (de)
same => n,Set(CHANNEL(tonezone)=de)

; Set the allowed maximum number of forwarding attempts
same => n,Set(CHANNEL(max_forwards)=10)

; If this channel is ejected from its next bridge, and if
; the channel is not hung up, begin executing dialplan at
; location default,after-bridge,1
same => n,Set(CHANNEL(after_bridge_goto)=default,after-bridge,1)

; Log the current state of the channel
same => n,Log(NOTICE, This channel is: ${CHANNEL(state)})



```

* __Technology: PJSIP__
``` title="Example: PJSIP specific CHANNEL examples"

; Log the current Call-ID
same => n,Log(NOTICE, ${CHANNEL(pjsip,call-id)})

; Log the destination address of the audio stream
same => n,Log(NOTICE, ${CHANNEL(rtp,dest)})

; Store the round-trip time associated with a
; video stream in the CDR field video-rtt
same => n,Set(CDR(video-rtt)=${CHANNEL(rtcp,rtt,video)})

	
```

### Syntax


```

CHANNEL(item)
```
##### Arguments


* `item` - Standard items (provided by all channel technologies) are:<br>

    * `amaflags` - R/W the Automatic Message Accounting (AMA) flags on the channel. When read from a channel, the integer value will always be returned. When written to a channel, both the string format or integer value is accepted.<br>

        * `1` - OMIT<br>

        * `2` - BILLING<br>

        * `3` - DOCUMENTATION<br>

    * `accountcode` - R/W the channel's account code.<br>

    * `audioreadformat` - R/O format currently being read.<br>

    * `audionativeformat` - R/O format used natively for audio.<br>

    * `audiowriteformat` - R/O format currently being written.<br>

    * `dtmf_features` - R/W The channel's DTMF bridge features. May include one or more of 'T' 'K' 'H' 'W' and 'X' in a similar manner to options in the 'Dial' application. When setting it, the features string must be all upper case.<br>

    * `callgroup` - R/W numeric call pickup groups that this channel is a member.<br>

    * `pickupgroup` - R/W numeric call pickup groups this channel can pickup.<br>

    * `namedcallgroup` - R/W named call pickup groups that this channel is a member.<br>

    * `namedpickupgroup` - R/W named call pickup groups this channel can pickup.<br>

    * `channeltype` - R/O technology used for channel.<br>

    * `checkhangup` - R/O Whether the channel is hanging up (1/0)<br>

    * `after_bridge_goto` - R/W the parseable goto string indicating where the channel is expected to return to in the PBX after exiting the next bridge it joins on the condition that it doesn't hang up. The parseable goto string uses the same syntax as the 'Goto' application.<br>

    * `hangup_handler_pop` - W/O Replace the most recently added hangup handler with a new hangup handler on the channel if supplied. The assigned string is passed to the Gosub application when the channel is hung up. Any optionally omitted context and exten are supplied by the channel pushing the handler before it is pushed.<br>

    * `hangup_handler_push` - W/O Push a hangup handler onto the channel hangup handler stack. The assigned string is passed to the Gosub application when the channel is hung up. Any optionally omitted context and exten are supplied by the channel pushing the handler before it is pushed.<br>

    * `hangup_handler_wipe` - W/O Wipe the entire hangup handler stack and replace with a new hangup handler on the channel if supplied. The assigned string is passed to the Gosub application when the channel is hung up. Any optionally omitted context and exten are supplied by the channel pushing the handler before it is pushed.<br>

    * `onhold` - R/O Whether or not the channel is onhold. (1/0)<br>

    * `language` - R/W language for sounds played.<br>

    * `musicclass` - R/W class (from musiconhold.conf) for hold music.<br>

    * `name` - The name of the channel<br>

    * `parkinglot` - R/W parkinglot for parking.<br>

    * `rxgain` - R/W set rxgain level on channel drivers that support it.<br>

    * `secure_bridge_signaling` - Whether or not channels bridged to this channel require secure signaling (1/0)<br>

    * `secure_bridge_media` - Whether or not channels bridged to this channel require secure media (1/0)<br>

    * `state` - R/O state of the channel<br>

    * `tonezone` - R/W zone for indications played<br>

    * `transfercapability` - R/W ISDN Transfer Capability, one of:<br>

        * `SPEECH`

        * `DIGITAL`

        * `RESTRICTED_DIGITAL`

        * `3K1AUDIO`

        * `DIGITAL_W_TONES`

        * `VIDEO`

    * `txgain` - R/W set txgain level on channel drivers that support it.<br>

    * `videonativeformat` - R/O format used natively for video<br>

    * `hangupsource` - R/W returns the channel responsible for hangup.<br>

    * `appname` - R/O returns the internal application name.<br>

    * `appdata` - R/O returns the application data if available.<br>

    * `exten` - R/O returns the extension for an outbound channel.<br>

    * `context` - R/O returns the context for an outbound channel.<br>

    * `channame` - R/O returns the channel name for an outbound channel.<br>

    * `uniqueid` - R/O returns the channel uniqueid.<br>

    * `linkedid` - R/O returns the linkedid if available, otherwise returns the uniqueid.<br>

    * `tenantid` - R/W The channel tenantid.<br>

    * `max_forwards` - R/W The maximum number of forwards allowed.<br>

    * `callid` - R/O Call identifier log tag associated with the channel e.g., '\[C-00000000\]'.<br>

    * __Technology: DAHDI__

        * `dahdi_channel` - R/O DAHDI channel related to this channel.<br>

        * `dahdi_span` - R/O DAHDI span related to this channel.<br>

        * `dahdi_group` - R/O DAHDI logical group related to this channel.<br>

        * `dahdi_type` - R/O DAHDI channel type, one of:<br>

            * `analog`

            * `mfc/r2`

            * `pri`

            * `pseudo`

            * `ss7`

        * `keypad_digits` - R/O PRI Keypad digits that came in with the SETUP message.<br>

        * `reversecharge` - R/O PRI Reverse Charging Indication, one of:<br>

            * `-1` - None<br>

            * ` 1` - Reverse Charging Requested<br>

        * `no_media_path` - R/O PRI Nonzero if the channel has no B channel. The channel is either on hold or a call waiting call.<br>

        * `buffers` - W/O Change the channel's buffer policy (for the current call only)<br>
This option takes two arguments:<br>
Number of buffers,<br>
Buffer policy being one of:<br>
'full'<br>
'immediate'<br>
'half'<br>

        * `echocan_mode` - W/O Change the configuration of the active echo canceller on the channel (if any), for the current call only.<br>
Possible values are:<br>
'on'Normal mode (the echo canceller is actually reinitialized)<br>
'off'Disabled<br>
'fax'FAX/data mode (NLP disabled if possible, otherwise completely disabled)<br>
'voice'Voice mode (returns from FAX mode, reverting the changes that were made)<br>

    * __Technology: IAX__

        * `osptoken` - R/O Get the peer's osptoken.<br>

        * `peerip` - R/O Get the peer's ip address.<br>

        * `peername` - R/O Get the peer's username.<br>

        * `secure_signaling` - R/O Get the if the IAX channel is secured.<br>

        * `secure_media` - R/O Get the if the IAX channel is secured.<br>

    * __Technology: OOH323__

        * `faxdetect` - R/W Fax Detect<br>
Returns 0 or 1<br>
Write yes or no<br>

        * `t38support` - R/W t38support<br>
Returns 0 or 1<br>
Write yes or no<br>

        * `h323id_url` - R/0 Returns caller URL<br>

        * `caller_h323id` - R/0 Returns caller h323id<br>

        * `caller_dialeddigits` - R/0 Returns caller dialed digits<br>

        * `caller_email` - R/0 Returns caller email<br>

        * `callee_email` - R/0 Returns callee email<br>

        * `callee_dialeddigits` - R/0 Returns callee dialed digits<br>

        * `caller_url` - R/0 Returns caller URL<br>

        * `max_forwards` - R/W Get or set the maximum number of call forwards for this channel. This number describes the number of times a call may be forwarded by this channel before the call fails. "Forwards" in this case refers to redirects by phones as well as calls to local channels. Note that this has no relation to the SIP Max-Forwards header.<br>

    * __Technology: PJSIP__

        * `rtp` - R/O Retrieve media related information.<br>

            * `type` - When _rtp_ is specified, the 'type' parameter must be provided. It specifies which RTP parameter to read.<br>

                * `src` - Retrieve the local address for RTP.<br>

                * `dest` - Retrieve the remote address for RTP.<br>

                * `direct` - If direct media is enabled, this address is the remote address used for RTP.<br>

                * `secure` - Whether or not the media stream is encrypted.<br>

                    * `0` - The media stream is not encrypted.<br>

                    * `1` - The media stream is encrypted.<br>

                * `hold` - Whether or not the media stream is currently restricted due to a call hold.<br>

                    * `0` - The media stream is not held.<br>

                    * `1` - The media stream is held.<br>

            * `media_type` - When _rtp_ is specified, the 'media\_type' parameter may be provided. It specifies which media stream the chosen RTP parameter should be retrieved from.<br>

                * `audio` - Retrieve information from the audio media stream.<br>

                    /// note
If not specified, 'audio' is used by default.
///


                * `video` - Retrieve information from the video media stream.<br>

        * `rtcp` - R/O Retrieve RTCP statistics.<br>

            * `statistic` - When _rtcp_ is specified, the 'statistic' parameter must be provided. It specifies which RTCP statistic parameter to read.<br>

                * `all` - Retrieve a summary of all RTCP statistics.<br>
The following data items are returned in a semi-colon delineated list:<br>

                    * `ssrc` - Our Synchronization Source identifier<br>

                    * `themssrc` - Their Synchronization Source identifier<br>

                    * `lp` - Our lost packet count<br>

                    * `rxjitter` - Received packet jitter<br>

                    * `rxcount` - Received packet count<br>

                    * `txjitter` - Transmitted packet jitter<br>

                    * `txcount` - Transmitted packet count<br>

                    * `rlp` - Remote lost packet count<br>

                    * `rtt` - Round trip time<br>

                    * `txmes` - Transmitted Media Experience Score<br>

                    * `rxmes` - Received Media Experience Score<br>

                * `all_jitter` - Retrieve a summary of all RTCP Jitter statistics.<br>
The following data items are returned in a semi-colon delineated list:<br>

                    * `minrxjitter` - Our minimum jitter<br>

                    * `maxrxjitter` - Our max jitter<br>

                    * `avgrxjitter` - Our average jitter<br>

                    * `stdevrxjitter` - Our jitter standard deviation<br>

                    * `reported_minjitter` - Their minimum jitter<br>

                    * `reported_maxjitter` - Their max jitter<br>

                    * `reported_avgjitter` - Their average jitter<br>

                    * `reported_stdevjitter` - Their jitter standard deviation<br>

                * `all_loss` - Retrieve a summary of all RTCP packet loss statistics.<br>
The following data items are returned in a semi-colon delineated list:<br>

                    * `minrxlost` - Our minimum lost packets<br>

                    * `maxrxlost` - Our max lost packets<br>

                    * `avgrxlost` - Our average lost packets<br>

                    * `stdevrxlost` - Our lost packets standard deviation<br>

                    * `reported_minlost` - Their minimum lost packets<br>

                    * `reported_maxlost` - Their max lost packets<br>

                    * `reported_avglost` - Their average lost packets<br>

                    * `reported_stdevlost` - Their lost packets standard deviation<br>

                * `all_rtt` - Retrieve a summary of all RTCP round trip time information.<br>
The following data items are returned in a semi-colon delineated list:<br>

                    * `minrtt` - Minimum round trip time<br>

                    * `maxrtt` - Maximum round trip time<br>

                    * `avgrtt` - Average round trip time<br>

                    * `stdevrtt` - Standard deviation round trip time<br>

                * `all_mes` - Retrieve a summary of all RTCP Media Experience Score information.<br>
The following data items are returned in a semi-colon delineated list:<br>

                    * `minmes` - Minimum MES based on us analysing received packets.<br>

                    * `maxmes` - Maximum MES based on us analysing received packets.<br>

                    * `avgmes` - Average MES based on us analysing received packets.<br>

                    * `stdevmes` - Standard deviation MES based on us analysing received packets.<br>

                    * `reported_minmes` - Minimum MES based on data we get in Sender and Receiver Reports sent by the remote end<br>

                    * `reported_maxmes` - Maximum MES based on data we get in Sender and Receiver Reports sent by the remote end<br>

                    * `reported_avgmes` - Average MES based on data we get in Sender and Receiver Reports sent by the remote end<br>

                    * `reported_stdevmes` - Standard deviation MES based on data we get in Sender and Receiver Reports sent by the remote end<br>

                * `txcount` - Transmitted packet count<br>

                * `rxcount` - Received packet count<br>

                * `txjitter` - Transmitted packet jitter<br>

                * `rxjitter` - Received packet jitter<br>

                * `remote_maxjitter` - Their max jitter<br>

                * `remote_minjitter` - Their minimum jitter<br>

                * `remote_normdevjitter` - Their average jitter<br>

                * `remote_stdevjitter` - Their jitter standard deviation<br>

                * `local_maxjitter` - Our max jitter<br>

                * `local_minjitter` - Our minimum jitter<br>

                * `local_normdevjitter` - Our average jitter<br>

                * `local_stdevjitter` - Our jitter standard deviation<br>

                * `txploss` - Transmitted packet loss<br>

                * `rxploss` - Received packet loss<br>

                * `remote_maxrxploss` - Their max lost packets<br>

                * `remote_minrxploss` - Their minimum lost packets<br>

                * `remote_normdevrxploss` - Their average lost packets<br>

                * `remote_stdevrxploss` - Their lost packets standard deviation<br>

                * `local_maxrxploss` - Our max lost packets<br>

                * `local_minrxploss` - Our minimum lost packets<br>

                * `local_normdevrxploss` - Our average lost packets<br>

                * `local_stdevrxploss` - Our lost packets standard deviation<br>

                * `rtt` - Round trip time<br>

                * `maxrtt` - Maximum round trip time<br>

                * `minrtt` - Minimum round trip time<br>

                * `normdevrtt` - Average round trip time<br>

                * `stdevrtt` - Standard deviation round trip time<br>

                * `local_ssrc` - Our Synchronization Source identifier<br>

                * `remote_ssrc` - Their Synchronization Source identifier<br>

                * `txmes` - Current MES based on us analyzing rtt, jitter and loss in the actual received RTP stream received from the remote end. I.E. This is the MES for the incoming audio stream.<br>

                * `rxmes` - Current MES based on rtt and the jitter and loss values in RTCP sender and receiver reports we receive from the remote end. I.E. This is the MES for the outgoing audio stream.<br>

                * `remote_maxmes` - Max MES based on data we get in Sender and Receiver Reports sent by the remote end<br>

                * `remote_minmes` - Min MES based on data we get in Sender and Receiver Reports sent by the remote end<br>

                * `remote_normdevmes` - Average MES based on data we get in Sender and Receiver Reports sent by the remote end<br>

                * `remote_stdevmes` - Standard deviation MES based on data we get in Sender and Receiver Reports sent by the remote end<br>

                * `local_maxmes` - Max MES based on us analyzing the received RTP stream<br>

                * `local_minmes` - Min MES based on us analyzing the received RTP stream<br>

                * `local_normdevmes` - Average MES based on us analyzing the received RTP stream<br>

                * `local_stdevmes` - Standard deviation MES based on us analyzing the received RTP stream<br>

            * `media_type` - When _rtcp_ is specified, the 'media\_type' parameter may be provided. It specifies which media stream the chosen RTCP parameter should be retrieved from.<br>

                * `audio` - Retrieve information from the audio media stream.<br>

                    /// note
If not specified, 'audio' is used by default.
///


                * `video` - Retrieve information from the video media stream.<br>

        * `endpoint` - R/O The name of the endpoint associated with this channel. Use the _PJSIP\_ENDPOINT_ function to obtain further endpoint related information.<br>

        * `contact` - R/O The name of the contact associated with this channel. Use the _PJSIP\_CONTACT_ function to obtain further contact related information. Note this may not be present and if so is only available on outgoing legs.<br>

        * `aor` - R/O The name of the AOR associated with this channel. Use the _PJSIP\_AOR_ function to obtain further AOR related information. Note this may not be present and if so is only available on outgoing legs.<br>

        * `pjsip` - R/O Obtain information about the current PJSIP channel and its session.<br>

            * `type` - When _pjsip_ is specified, the 'type' parameter must be provided. It specifies which signalling parameter to read.<br>

                * `call-id` - The SIP call-id.<br>

                * `secure` - Whether or not the signalling uses a secure transport.<br>

                    * `0` - The signalling uses a non-secure transport.<br>

                    * `1` - The signalling uses a secure transport.<br>

                * `target_uri` - The contact URI where requests are sent.<br>

                * `local_uri` - The local URI.<br>

                * `local_tag` - Tag in From header<br>

                * `remote_uri` - The remote URI.<br>

                * `remote_tag` - Tag in To header<br>

                * `request_uri` - The request URI of the incoming 'INVITE' associated with the creation of this channel.<br>

                * `t38state` - The current state of any T.38 fax on this channel.<br>

                    * `DISABLED` - T.38 faxing is disabled on this channel.<br>

                    * `LOCAL_REINVITE` - Asterisk has sent a 're-INVITE' to the remote end to initiate a T.38 fax.<br>

                    * `REMOTE_REINVITE` - The remote end has sent a 're-INVITE' to Asterisk to initiate a T.38 fax.<br>

                    * `ENABLED` - A T.38 fax session has been enabled.<br>

                    * `REJECTED` - A T.38 fax session was attempted but was rejected.<br>

                * `local_addr` - On inbound calls, the full IP address and port number that the 'INVITE' request was received on. On outbound calls, the full IP address and port number that the 'INVITE' request was transmitted from.<br>

                * `remote_addr` - On inbound calls, the full IP address and port number that the 'INVITE' request was received from. On outbound calls, the full IP address and port number that the 'INVITE' request was transmitted to.<br>

    * __Technology: SIP__

        * `peerip` - R/O Get the IP address of the peer.<br>

        * `recvip` - R/O Get the source IP address of the peer.<br>

        * `recvport` - R/O Get the source port of the peer.<br>

        * `from` - R/O Get the URI from the From: header.<br>

        * `uri` - R/O Get the URI from the Contact: header.<br>

        * `ruri` - R/O Get the Request-URI from the INVITE header.<br>

        * `useragent` - R/O Get the useragent.<br>

        * `peername` - R/O Get the name of the peer.<br>

        * `t38passthrough` - R/O '1' if T38 is offered or enabled in this channel, otherwise '0'<br>

        * `rtpqos` - R/O Get QOS information about the RTP stream<br>
This option takes two additional arguments:<br>
Argument 1:<br>
'audio' Get data about the audio stream<br>
'video' Get data about the video stream<br>
'text' Get data about the text stream<br>
Argument 2:<br>
'local\_ssrc' Local SSRC (stream ID)<br>
'local\_lostpackets' Local lost packets<br>
'local\_jitter' Local calculated jitter<br>
'local\_maxjitter' Local calculated jitter (maximum)<br>
'local\_minjitter' Local calculated jitter (minimum)<br>
'local\_normdevjitter'Local calculated jitter (normal deviation)<br>
'local\_stdevjitter' Local calculated jitter (standard deviation)<br>
'local\_count' Number of received packets<br>
'remote\_ssrc' Remote SSRC (stream ID)<br>
'remote\_lostpackets'Remote lost packets<br>
'remote\_jitter' Remote reported jitter<br>
'remote\_maxjitter' Remote calculated jitter (maximum)<br>
'remote\_minjitter' Remote calculated jitter (minimum)<br>
'remote\_normdevjitter'Remote calculated jitter (normal deviation)<br>
'remote\_stdevjitter'Remote calculated jitter (standard deviation)<br>
'remote\_count' Number of transmitted packets<br>
'rtt' Round trip time<br>
'maxrtt' Round trip time (maximum)<br>
'minrtt' Round trip time (minimum)<br>
'normdevrtt' Round trip time (normal deviation)<br>
'stdevrtt' Round trip time (standard deviation)<br>
'all' All statistics (in a form suited to logging, but not for parsing)<br>

        * `rtpdest` - R/O Get remote RTP destination information.<br>
This option takes one additional argument:<br>
Argument 1:<br>
'audio' Get audio destination<br>
'video' Get video destination<br>
'text' Get text destination<br>
Defaults to 'audio' if unspecified.<br>

        * `rtpsource` - R/O Get source RTP destination information.<br>
This option takes one additional argument:<br>
Argument 1:<br>
'audio' Get audio destination<br>
'video' Get video destination<br>
'text' Get text destination<br>
Defaults to 'audio' if unspecified.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 