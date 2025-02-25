---
search:
  boost: 0.5
title: res_pjsip_outbound_publish
---

# res_pjsip_outbound_publish: SIP resource for outbound publish

This configuration documentation is for functionality provided by res_pjsip_outbound_publish.

## Overview

*Outbound Publish*<br>

This module allows 'res\_pjsip' to publish to other SIP servers.<br>


## Configuration File: pjsip.conf

### [outbound-publish]: The configuration for outbound publish

Publish is *COMPLETELY* separate from the rest of 'pjsip.conf'. A minimal configuration consists of setting a 'server\_uri' and 'event'.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| event| String| | false| Event type of the PUBLISH.| |
| expiration| Unsigned Integer| 3600| false| Expiration time for publications in seconds| |
| [from_uri](#from_uri)| String| | false| SIP URI to use in the From header| |
| max_auth_attempts| Unsigned Integer| 5| false| Maximum number of authentication attempts before stopping the publication.| |
| [multi_user](#multi_user)| Boolean| no| false| Enable multi-user support| |
| [outbound_auth](#outbound_auth)| Custom| | false| Authentication object(s) to be used for outbound publishes.| |
| outbound_proxy| String| | false| Full SIP URI of the outbound proxy used to send publishes| |
| [server_uri](#server_uri)| String| | false| SIP URI of the server and entity to publish to| |
| [to_uri](#to_uri)| String| | false| SIP URI to use in the To header| |
| [transport](#transport)| String| | false| Transport used for outbound publish| |
| type| None| | false| Must be of type 'outbound-publish'.| |


#### Configuration Option Descriptions

##### from_uri

This is the URI that will be placed into the From header of outgoing PUBLISH messages. If no URI is specified then the URI provided in 'server\_uri' will be used.<br>


##### multi_user

When enabled the user portion of the server uri is replaced by a dynamically created user<br>


##### outbound_auth

This is a comma-delimited list of _auth_ sections defined in *pjsip.conf* used to respond to outbound authentication challenges.<br>


/// note
Using the same auth section for inbound and outbound authentication is not recommended. There is a difference in meaning for an empty realm setting between inbound and outbound authentication uses. See the auth realm description for details.
///


##### server_uri

This is the URI at which to find the entity and server to send the outbound PUBLISH to. This URI is used as the request URI of the outbound PUBLISH request from Asterisk.<br>


##### to_uri

This is the URI that will be placed into the To header of outgoing PUBLISH messages. If no URI is specified then the URI provided in 'server\_uri' will be used.<br>


##### transport


/// note
A _transport_ configured in 'pjsip.conf'. As with other 'res\_pjsip' modules, this will use the first available transport of the appropriate type if unconfigured.
///



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 