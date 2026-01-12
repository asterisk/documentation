---
search:
  boost: 0.5
title: res_aeap
---

# res_aeap: Asterisk External Application Protocol (AEAP) module for Asterisk

This configuration documentation is for functionality provided by res_aeap.

## Configuration File: aeap.conf

### [client]: AEAP client options

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [codecs](#codecs)| Codec| | false| Optional media codec(s)| |
| protocol| String| | false| The application protocol.| |
| type| None| | false| Must be of type 'client'.| |
| url| String| | false| The URL of the server to connect to.| |


#### Configuration Option Descriptions

##### codecs

If this is specified, Asterisk will use this for codec related negotiations with the external application. Otherwise, Asterisk will default to using the codecs configured on the endpoint.<br>



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 