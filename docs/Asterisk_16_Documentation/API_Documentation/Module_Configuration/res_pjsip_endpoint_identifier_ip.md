---
search:
  boost: 0.5
title: res_pjsip_endpoint_identifier_ip
---

# res_pjsip_endpoint_identifier_ip: Module that identifies endpoints

This configuration documentation is for functionality provided by res_pjsip_endpoint_identifier_ip.

## Configuration File: pjsip.conf

### [identify]: Identifies endpoints via some criteria.

This module provides alternatives to matching inbound requests to a configured endpoint. At least one of the matching mechanisms must be provided, or the object configuration is invalid.<br>

The matching mechanisms are provided by the following configuration options:<br>


* `match` - Match by source IP address.<br>

* `match_header` - Match by SIP header.<br>

/// note
If multiple matching criteria are provided then an inbound request will be matched to the endpoint if it matches *any* of the criteria.
///


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| endpoint| String| | false| Name of endpoint identified| |
| [match](#match)| Custom| | false| IP addresses or networks to match against.| |
| [match_header](#match_header)| String| | false| Header/value pair to match against.| |
| [srv_lookups](#srv_lookups)| Boolean| yes| false| Perform SRV lookups for provided hostnames.| |
| type| None| | false| Must be of type 'identify'.| |


#### Configuration Option Descriptions

##### match

The value is a comma-delimited list of IP addresses or hostnames.<br>

IP addresses may have a subnet mask appended. The subnet mask may be written in either CIDR or dotted-decimal notation. Separate the IP address and subnet mask with a slash ('/'). A source port can also be specified by adding a colon (':') after the address but before the subnet mask, e.g. 3.2.1.0:5061/24. To specify a source port for an IPv6 address, the address itself must be enclosed in square brackets ('\[2001:db8:0::1\]:5060')<br>

When a hostname is used, the behavior depends on whether _srv\_lookups_ is enabled and/or a source port is provided. If _srv\_lookups_ is enabled and a source port is not provided, Asterisk will perform an SRV lookup on the provided hostname, adding all of the A and AAAA records that are resolved.<br>

If the SRV lookup fails, _srv\_lookups_ is disabled, or a source port is specified when the hostname is configured, Asterisk will resolve the hostname and add all A and AAAA records that are resolved.<br>


##### match_header

A SIP header whose value is used to match against. SIP requests containing the header, along with the specified value, will be mapped to the specified endpoint. The header must be specified with a ':', as in 'match\_header = SIPHeader: value'.<br>

The specified SIP header value can be a regular expression if the value is of the form / _regex_/.<br>


/// note
Use of a regex is expensive so be sure you need to use a regex to match your endpoint.
///


##### srv_lookups

When enabled, _srv\_lookups_ will perform SRV lookups for \_sip.\_udp, \_sip.\_tcp, and \_sips.\_tcp of the given hostnames to determine additional addresses that traffic may originate from.<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 