---
search:
  boost: 0.5
title: res_hep
---

# res_hep: Resource for integration with Homer using HEPv3

This configuration documentation is for functionality provided by res_hep.

## Configuration File: hep.conf

### [general]: General settings.

The *general* settings section contains information to configure Asterisk as a Homer capture agent.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| capture_address| | | | The address and port of the Homer server to send packets to.| |
| capture_id| | 0| | The ID for this capture agent.| |
| capture_password| | | | If set, the authentication password to send to Homer.| |
| [enabled](#enabled)| | yes| | Enable or disable packet capturing.| |
| [uuid_type](#uuid_type)| | call-id| | The preferred type of UUID to pass to Homer.| |


#### Configuration Option Descriptions

##### enabled


* `no`

* `yes`

##### uuid_type


* `call-id` - Use the PJSIP Call-Id<br>

* `channel` - Use the Asterisk channel name<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 