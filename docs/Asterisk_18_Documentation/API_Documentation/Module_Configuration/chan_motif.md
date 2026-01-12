---
search:
  boost: 0.5
title: chan_motif
---

# chan_motif: Jingle Channel Driver

This configuration documentation is for functionality provided by chan_motif.

## Overview

Transports<br>

There are three different transports and protocol derivatives supported by 'chan\_motif'. They are in order of preference: Jingle using ICE-UDP, Google Jingle, and Google-V1.<br>

Jingle as defined in XEP-0166 supports the widest range of features. It is referred to as 'ice-udp'. This is the specification that Jingle clients implement.<br>

Google Jingle follows the Jingle specification for signaling but uses a custom transport for media. It is supported by the Google Talk Plug-in in Gmail and by some other Jingle clients. It is referred to as 'google' in this file.<br>

Google-V1 is the original Google Talk signaling protocol which uses an initial preliminary version of Jingle. It also uses the same custom transport as Google Jingle for media. It is supported by Google Voice, some other Jingle clients, and the Windows Google Talk client. It is referred to as 'google-v1' in this file.<br>

Incoming sessions will automatically switch to the correct transport once it has been determined.<br>

Outgoing sessions are capable of determining if the target is capable of Jingle or a Google transport if the target is in the roster. Unfortunately it is not possible to differentiate between a Google Jingle or Google-V1 capable resource until a session initiate attempt occurs. If a resource is determined to use a Google transport it will initially use Google Jingle but will fall back to Google-V1 if required.<br>

If an outgoing session attempt fails due to failure to support the given transport 'chan\_motif' will fall back in preference order listed previously until all transports have been exhausted.<br>

Dialing and Resource Selection Strategy<br>

Placing a call through an endpoint can be accomplished using the following dial string:<br>

Motif/[endpoint name]/[target]<br>

When placing an outgoing call through an endpoint the requested target is searched for in the roster list. If present the first Jingle or Google Jingle capable resource is specifically targeted. Since the capabilities of the resource are known the outgoing session initiation will disregard the configured transport and use the determined one.<br>

If the target is not found in the roster the target will be used as-is and a session will be initiated using the transport specified in this configuration file. If no transport has been specified the endpoint defaults to 'ice-udp'.<br>

Video Support<br>

Support for video does not need to be explicitly enabled. Configuring any video codec on your endpoint will automatically enable it.<br>

DTMF<br>

The only supported method for DTMF is RFC2833. This is always enabled on audio streams and negotiated if possible.<br>

Incoming Calls<br>

Incoming calls will first look for the extension matching the name of the endpoint in the configured context. If no such extension exists the call will automatically fall back to the 's' extension.<br>

CallerID<br>

The incoming caller id number is populated with the username of the caller and the name is populated with the full identity of the caller. If you would like to perform authentication or filtering of incoming calls it is recommended that you use these fields to do so.<br>

Outgoing caller id can *not* be set.<br>


/// warning
Multiple endpoints using the same connection is *NOT* supported. Doing so may result in broken calls.
///


## Configuration File: motif.conf

### [endpoint]: The configuration for an endpoint.

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| accountcode| String| | false| Accout code for CDR purposes| |
| allow| Codec| ulaw,alaw| false| Codecs to allow| |
| callgroup| Custom| | false| A callgroup to assign to this endpoint.| |
| connection| Custom| | false| Connection to accept traffic on and on which to send traffic out| |
| context| String| default| false| Default dialplan context that incoming sessions will be routed to| |
| disallow| Codec| all| false| Codecs to disallow| |
| language| String| | false| The default language for this endpoint.| |
| maxicecandidates| Unsigned Integer| 10| false| Maximum number of ICE candidates to offer| |
| maxpayloads| Unsigned Integer| 30| false| Maximum number of payloads to offer| |
| musicclass| String| | false| Default music on hold class for this endpoint.| |
| parkinglot| String| | false| Default parking lot for this endpoint.| |
| pickupgroup| Custom| | false| A pickup group to assign to this endpoint.| |
| [transport](#transport)| Custom| | false| The transport to use for the endpoint.| |


#### Configuration Option Descriptions

##### transport

The default outbound transport for this endpoint. Inbound messages are inferred. Allowed transports are 'ice-udp', 'google', or 'google-v1'. Note that 'chan\_motif' will fall back to transport preference order if the transport value chosen here fails.<br>


* `ice-udp` - The Jingle protocol, as defined in XEP 0166.<br>

* `google` - The Google Jingle protocol, which follows the Jingle specification for signaling but uses a custom transport for media.<br>

* `google-v1` - Google-V1 is the original Google Talk signaling protocol which uses an initial preliminary version of Jingle. It also uses the same custom transport as 'google' for media.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 