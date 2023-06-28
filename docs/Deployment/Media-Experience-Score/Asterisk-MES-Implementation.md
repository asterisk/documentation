---
title: Asterisk MES Implementation
pageid: 50924943
---

The res_rtp_asterisk module has been updated to provide additional quality statistics in the form of an Asterisk Media Experience Score. The score is available using the same mechanisms you'd use to retrieve jitter, loss, and rtt statistics.

Local vs Remote:
----------------

### Local:

These are the scores Asterisk has calculated based on the RTT, Jitter and Loss Asterisk is calculating from the received RTP stream. I.E. Incoming audio.

### Remote:

These are the scores Asterisk has calculated based on the RTT, Jitter and Loss the remote end is calculating from its received RTP stream and sent to Asterisk in RTCP sender and receiver reports. I.E Outgoing audio. Although the calculation of Jitter is defined in [RFC3550](https://www.rfc-editor.org/rfc/rfc3550), not all implementations calculate it the same way which means that what they report in their RTCP sender and receiver reports might not match Asterisk's calculation which DOES follow the RFC.  Since we can only calculate the remote MES based on what's in the RTCP reports, it might not be accurate.

Retrieving the stats:
---------------------

The MES can be retrieved from the Dialplan using the same mechanisms available to retrieve the other RTP/RTCP stats.

 

### Using the CHANNEL dialplan application:

`${CHANNEL(rtcp,<stat>)`} (chan_pjsip only) using the stats:

* all_mes
* txmes
* rxmes
* remote_maxmes
* remote_minmes
* remote_normdevmes
* remote_stdevmes
* local_maxmes
* local_minmes
* local_normdevmes
* local_stdevmes

### Via Channel Variables:

* RTPAUDIOQOSMES
* RTPAUDIOQOSMESBRIDGED

### Via AMI Events:

* RTCPSent
* RTCPReceived
* VarSet (RTPAUDIOQOSMES)
* VarSet(RTPAUDIOQOSMESBRIDGED)

 

