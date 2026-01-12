---
search:
  boost: 0.5
title: res_pjsip_notify
---

# res_pjsip_notify: Module that supports sending NOTIFY requests to endpoints from external sources

This configuration documentation is for functionality provided by res_pjsip_notify.

## Configuration File: pjsip_notify.conf

### [general]: Unused, but reserved.



### [notify]: Configuration of a NOTIFY request.

Each key-value pair in a 'notify' configuration section defines either a SIP header to send in the request or a line of content in the request message body. A key of 'Content' is treated as part of the message body and is appended in sequential order; any other header is treated as part of the SIP request.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| | Custom| | false| A key/value pair to add to a NOTIFY request.| |


#### Configuration Option Descriptions

##### 

If the key is 'Content', it will be treated as part of the message body. Otherwise, it will be added as a header in the NOTIFY request.<br>

The following headers are reserved and cannot be specified:<br>


* `Call-ID`

* `Contact`

* `CSeq`

* `To`

* `From`

* `Record-Route`

* `Route`

* `Via`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 