---
search:
  boost: 0.5
title: res_pjsip_acl
---

# res_pjsip_acl: SIP ACL module

This configuration documentation is for functionality provided by res_pjsip_acl.

## Overview

*ACL*<br>

The ACL module used by 'res\_pjsip'. This module is independent of 'endpoints' and operates on all inbound SIP communication using res\_pjsip.<br>

There are two main ways of defining your ACL with the options provided. You can use the 'permit' and 'deny' options which act on *IP* addresses, or the 'contactpermit' and 'contactdeny' options which act on *Contact header* addresses in incoming REGISTER requests. You can combine the various options to create a mixed ACL.<br>

Additionally, instead of defining an ACL with options, you can reference IP or Contact header ACLs from the file *acl.conf* by using the 'acl' or 'contactacl' options.<br>


## Configuration File: pjsip.conf

### [acl]: Access Control List

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [acl](#acl)| Custom| | false| List of IP ACL section names in acl.conf| |
| [contact_acl](#contact_acl)| Custom| | false| List of Contact ACL section names in acl.conf| |
| [contact_deny](#contact_deny)| Custom| | false| List of Contact header addresses to deny| |
| [contact_permit](#contact_permit)| Custom| | false| List of Contact header addresses to permit| |
| [deny](#deny)| Custom| | false| List of IP addresses to deny access from| |
| [permit](#permit)| Custom| | false| List of IP addresses to permit access from| |
| type| None| | false| Must be of type 'acl'.| |


#### Configuration Option Descriptions

##### acl

This matches sections configured in 'acl.conf'. The value is defined as a list of comma-delimited section names.<br>


##### contact_acl

This matches sections configured in 'acl.conf'. The value is defined as a list of comma-delimited section names.<br>


##### contact_deny

The value is a comma-delimited list of IP addresses. IP addresses may have a subnet mask appended. The subnet mask may be written in either CIDR or dotted-decimal notation. Separate the IP address and subnet mask with a slash ('/')<br>


##### contact_permit

The value is a comma-delimited list of IP addresses. IP addresses may have a subnet mask appended. The subnet mask may be written in either CIDR or dotted-decimal notation. Separate the IP address and subnet mask with a slash ('/')<br>


##### deny

The value is a comma-delimited list of IP addresses. IP addresses may have a subnet mask appended. The subnet mask may be written in either CIDR or dotted-decimal notation. Separate the IP address and subnet mask with a slash ('/')<br>


##### permit

The value is a comma-delimited list of IP addresses. IP addresses may have a subnet mask appended. The subnet mask may be written in either CIDR or dotted-decimal notation. Separate the IP address and subnet mask with a slash ('/')<br>



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 