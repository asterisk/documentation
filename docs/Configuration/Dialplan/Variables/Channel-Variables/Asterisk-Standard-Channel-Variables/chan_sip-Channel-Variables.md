---
title: chan_sip Channel Variables
pageid: 4620428
---

* ${SIPCALLID} \* - SIP Call-ID: header verbatim (for logging or CDR matching)
* ${SIPDOMAIN} \* - SIP destination domain of an inbound call (if appropriate)
* ${SIPFROMDOMAIN} - Set SIP domain portion of From header on outbound calls
* ${SIPUSERAGENT} \* - SIP user agent (deprecated)
* ${SIPURI} \* - SIP uri
* ${SIP\_MAX\_FORWARDS} - Set the value of the Max-Forwards header for outbound call
* ${SIP\_CODEC} - Set the SIP codec for an inbound call
* ${SIP\_CODEC\_INBOUND} - Set the SIP codec for an inbound call
* ${SIP\_CODEC\_OUTBOUND} - Set the SIP codec for an outbound call
* ${SIP\_URI\_OPTIONS} \* - additional options to add to the URI for an outgoing call
* ${RTPAUDIOQOS} - RTCP QoS report for the audio of this call
* ${RTPVIDEOQOS} - RTCP QoS report for the video of this call
