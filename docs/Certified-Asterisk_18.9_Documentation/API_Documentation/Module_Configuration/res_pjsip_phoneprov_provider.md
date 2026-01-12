---
search:
  boost: 0.5
title: res_pjsip_phoneprov_provider
---

# res_pjsip_phoneprov_provider: Module that integrates res_pjsip with res_phoneprov.

This configuration documentation is for functionality provided by res_pjsip_phoneprov_provider.

## Overview

*PJSIP Phoneprov Provider*<br>

This module creates the integration between 'res\_pjsip' and 'res\_phoneprov'.<br>

Each user to be integrated requires a 'phoneprov' section defined in *pjsip.conf*. Each section identifies the endpoint associated with the user and any other name/value pairs to be passed on to res\_phoneprov's template substitution. Only 'MAC' and 'PROFILE' variables are required. Any other variables supplied will be passed through.<br>

<br>

Example:<br>

\[1000\]<br>

type = phoneprovr<br>

endpoint = ep1000<br>

MAC = deadbeef4dad<br>

PROFILE = grandstream2<br>

LINEKEYS = 2<br>

LINE = 1<br>

OTHERVAR = othervalue<br>

<br>

The following variables are automatically defined if an endpoint is defined for the user:<br>


* `USERNAME` - Source: The user\_name defined in the first auth reference in the endpoint.<br>

* `SECRET` - Source: The user\_pass defined in the first auth reference in the endpoint.<br>

* `CALLERID` - Source: The number part of the callerid defined in the endpoint.<br>

* `DISPLAY_NAME` - Source: The name part of the callerid defined in the endpoint.<br>

* `LABEL` - Source: The id of the phoneprov section.<br>
<br>

In addition to the standard variables, the following are also automatically defined:<br>


* `ENDPOINT_ID` - Source: The id of the endpoint.<br>

* `TRANSPORT_ID` - Source: The id of the transport used by the endpoint.<br>

* `AUTH_ID` - Source: The id of the auth used by the endpoint.<br>
<br>

All other template substitution variables must be explicitly defined in the phoneprov\_default or phoneprov sections.<br>


## Configuration File: pjsip.conf

### [phoneprov]: Provides variables for each user.

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| *| | | | Other name/value pairs to be passed through for use in templates.| |
| MAC| | | | The mac address for this user. (required)| |
| PROFILE| | | | The phoneprov profile to use for this user. (required)| |
| endpoint| | | | The endpoint from which variables will be retrieved.| |
| type| | | | Must be of type 'phoneprov'.| |



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 