---
search:
  boost: 0.5
title: res_pjsip_publish_asterisk
---

# res_pjsip_publish_asterisk: SIP resource for inbound and outbound Asterisk event publications

This configuration documentation is for functionality provided by res_pjsip_publish_asterisk.

## Overview

*Inbound and outbound Asterisk event publication*<br>

This module allows 'res\_pjsip' to send and receive Asterisk event publications.<br>


## Configuration File: pjsip.conf

### [asterisk-publication]: The configuration for inbound Asterisk event publication

Publish is *COMPLETELY* separate from the rest of 'pjsip.conf'.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| device_state| Boolean| no| false| Whether we should permit incoming device state events.| |
| device_state_filter| Custom| | false| Optional regular expression used to filter what devices we accept events for.| |
| devicestate_publish| String| | false| Optional name of a publish item that can be used to publish a request for full device state information.| |
| mailbox_state| Boolean| no| false| Whether we should permit incoming mailbox state events.| |
| mailbox_state_filter| Custom| | false| Optional regular expression used to filter what mailboxes we accept events for.| |
| mailboxstate_publish| String| | false| Optional name of a publish item that can be used to publish a request for full mailbox state information.| |
| type| None| | false| Must be of type 'asterisk-publication'.| |



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 