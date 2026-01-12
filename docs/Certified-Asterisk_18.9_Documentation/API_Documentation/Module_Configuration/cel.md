---
search:
  boost: 0.5
title: cel
---

# cel

This configuration documentation is for functionality provided by cel.

## Configuration File: cel.conf

### [general]: Options that apply globally to Channel Event Logging (CEL)

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [apps](#apps)| Custom| | false| List of apps for CEL to track| |
| dateformat| String| | false| The format to be used for dates when logging| |
| enable| Boolean| no| false| Determines whether CEL is enabled| |
| [events](#events)| Custom| | false| List of events for CEL to track| |


#### Configuration Option Descriptions

##### apps

A case-insensitive, comma-separated list of applications to track when one or both of APP\_START and APP\_END events are flagged for tracking<br>


##### events

A case-sensitive, comma-separated list of event names to track. These event names do not include the leading 'AST\_CEL'.<br>


* `ALL` - Special value which tracks all events.<br>

* `CHAN_START`

* `CHAN_END`

* `ANSWER`

* `HANGUP`

* `APP_START`

* `APP_END`

* `PARK_START`

* `PARK_END`

* `USER_DEFINED`

* `BRIDGE_ENTER`

* `BRIDGE_EXIT`

* `BLINDTRANSFER`

* `ATTENDEDTRANSFER`

* `PICKUP`

* `FORWARD`

* `LINKEDID_END`

* `LOCAL_OPTIMIZE`

* `LOCAL_OPTIMIZE_BEGIN`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 