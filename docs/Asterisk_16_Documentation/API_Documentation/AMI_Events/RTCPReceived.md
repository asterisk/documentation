---
search:
  boost: 0.5
title: RTCPReceived
---

# RTCPReceived

### Synopsis

Raised when an RTCP packet is received.

### Syntax


```


    Event: RTCPReceived
    Channel: <value>
    ChannelState: <value>
    ChannelStateDesc: <value>
    CallerIDNum: <value>
    CallerIDName: <value>
    ConnectedLineNum: <value>
    ConnectedLineName: <value>
    Language: <value>
    AccountCode: <value>
    Context: <value>
    Exten: <value>
    Priority: <value>
    Uniqueid: <value>
    Linkedid: <value>
    SSRC: <value>
    PT: <value>
    From: <value>
    RTT: <value>
    ReportCount: <value>
    [SentNTP:] <value>
    [SentRTP:] <value>
    [SentPackets:] <value>
    [SentOctets:] <value>
    ReportXSourceSSRC: <value>
    ReportXFractionLost: <value>
    ReportXCumulativeLost: <value>
    ReportXHighestSequence: <value>
    ReportXSequenceNumberCycles: <value>
    ReportXIAJitter: <value>
    ReportXLSR: <value>
    ReportXDLSR: <value>

```
##### Arguments


* `Channel`

* `ChannelState` - A numeric code for the channel's current state, related to ChannelStateDesc<br>

* `ChannelStateDesc`

    * `Down`

    * `Rsrvd`

    * `OffHook`

    * `Dialing`

    * `Ring`

    * `Ringing`

    * `Up`

    * `Busy`

    * `Dialing Offhook`

    * `Pre-ring`

    * `Unknown`

* `CallerIDNum`

* `CallerIDName`

* `ConnectedLineNum`

* `ConnectedLineName`

* `Language`

* `AccountCode`

* `Context`

* `Exten`

* `Priority`

* `Uniqueid`

* `Linkedid` - Uniqueid of the oldest channel associated with this channel.<br>

* `SSRC` - The SSRC identifier for the remote system<br>

* `PT` - The type of packet for this RTCP report.<br>

    * `200(SR)`

    * `201(RR)`

* `From` - The address the report was received from.<br>

* `RTT` - Calculated Round-Trip Time in seconds<br>

* `ReportCount` - The number of reports that were received.<br>
The report count determines the number of ReportX headers in the message. The X for each set of report headers will range from 0 to 'ReportCount - 1'.<br>

* `SentNTP` - The time the sender generated the report. Only valid when PT is '200(SR)'.<br>

* `SentRTP` - The sender's last RTP timestamp. Only valid when PT is '200(SR)'.<br>

* `SentPackets` - The number of packets the sender has sent. Only valid when PT is '200(SR)'.<br>

* `SentOctets` - The number of bytes the sender has sent. Only valid when PT is '200(SR)'.<br>

* `ReportXSourceSSRC` - The SSRC for the source of this report block.<br>

* `ReportXFractionLost` - The fraction of RTP data packets from 'ReportXSourceSSRC' lost since the previous SR or RR report was sent.<br>

* `ReportXCumulativeLost` - The total number of RTP data packets from 'ReportXSourceSSRC' lost since the beginning of reception.<br>

* `ReportXHighestSequence` - The highest sequence number received in an RTP data packet from 'ReportXSourceSSRC'.<br>

* `ReportXSequenceNumberCycles` - The number of sequence number cycles seen for the RTP data received from 'ReportXSourceSSRC'.<br>

* `ReportXIAJitter` - An estimate of the statistical variance of the RTP data packet interarrival time, measured in timestamp units.<br>

* `ReportXLSR` - The last SR timestamp received from 'ReportXSourceSSRC'. If no SR has been received from 'ReportXSourceSSRC', then 0.<br>

* `ReportXDLSR` - The delay, expressed in units of 1/65536 seconds, between receiving the last SR packet from 'ReportXSourceSSRC' and sending this report.<br>

### Class

REPORTING
### See Also

* [AMI Events RTCPSent](/Asterisk_16_Documentation/API_Documentation/AMI_Events/RTCPSent)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 