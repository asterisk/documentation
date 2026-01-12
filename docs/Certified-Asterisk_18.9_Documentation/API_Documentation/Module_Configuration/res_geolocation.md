---
search:
  boost: 0.5
title: res_geolocation
---

# res_geolocation: Core Geolocation Support

This configuration documentation is for functionality provided by res_geolocation.

## Configuration File: geolocation.conf

### [location]: Location

Parameters for defining a Location object<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [confidence](#confidence)| Custom| none| false| Level of confidence| |
| [format](#format)| Custom| none| false| Location specification type| |
| [location_info](#location_info)| Custom| none| false| Location information| |
| [location_source](#location_source)| String| | false| Fully qualified host name| |
| [method](#method)| String| | false| Location determination method| |
| type| None| | false| Must be of type 'location'.| |


#### Configuration Option Descriptions

##### confidence

This is a rarely used field in the specification that would indicate the confidence in the location specified. See RFC7459 for exact details.<br>

Sub-parameters:<br>


* `pdf` - One of:<br>

    * `unknown`

    * `normal`

    * `rectangular`

* `value` - A percentage indicating the confidence.<br>

##### format


* `civicAddress` - The 'location\_info' parameter must contain a comma separated list of IANA codes or synonyms describing the civicAddress of this location. The IANA codes and synonyms can be obtained by executing the CLI command 'geoloc show civicAddr\_mapping'.<br>

* `GML` - The 'location\_info' parameter must contain a comma separated list valid GML elements describing this location.<br>

* `URI` - The 'location\_info' parameter must contain a single URI parameter which contains an external URI describing this location.<br>

##### location_info

The contents of this parameter are specific to the location 'format'.<br>


* `civicAddress` - location\_info = country=US,A1="New York",city\_district=Manhattan, A3="New York", house\_number=1633, street=46th, street\_suffix = Street, postal\_code=10222,floor=20,room=20A2<br>

* `GML` - location\_info = Shape=Sphere, pos3d="39.12345 -105.98766 1920", radius=200<br>

* `URI` - location\_info = URI=https:/something.com?exten=$\{EXTEN\}<br>

##### location_source

This parameter isn't required but if provided, RFC8787 says it MUST be a fully qualified host name. IP addresses are specifically NOT allowed. The value will be placed in a 'loc-src' parameter appended to the URI in the ' Geolocation' header.<br>


##### method

This is a rarely used field in the specification that would indicate the method used to determine the location. Its usage and values should be pre-negotiated with any recipients.<br>


* `GPS`

* `A-GPS`

* `Manual`

* `DHCP`

* `Triangulation`

* `Cell`

* `802.11`

### [profile]: Profile

Parameters for defining a Profile object<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| allow_routing_use| Boolean| no| false| Sets the value of the Geolocation-Routing header.| |
| [confidence](#confidence)| Custom| none| false| Level of confidence| |
| [format](#format)| Custom| none| false| Location specification type| |
| [location_info](#location_info)| Custom| none| false| Location information| |
| location_info_refinement| Custom| none| false| Reference to a location object| |
| location_reference| String| | false| Reference to a location object| |
| [location_source](#location_source)| String| | false| Fully qualified host name| |
| location_variables| Custom| none| false| Reference to a location object| |
| [method](#method)| String| | false| Location determination method| |
| [notes](#notes)| String| | false| Notes to be added to the outgoing PIDF-LO document| |
| [pidf_element](#pidf_element)| Custom| device| false| PIDF-LO element to place this profile in| |
| [profile_precedence](#profile_precedence)| Custom| discard_incoming| false| Determine which profile on a channel should be used| |
| suppress_empty_ca_elements| Boolean| no| false| Sets if empty Civic Address elements should be suppressed from the PIDF-LO document.| |
| type| None| | false| Must be of type 'profile'.| |
| [usage_rules](#usage_rules)| Custom| empty <usage_rules> element| false| location specification type| |


#### Configuration Option Descriptions

##### confidence

This is a rarely used field in the specification that would indicate the confidence in the location specified. See RFC7459 for exact details.<br>

Sub-parameters:<br>


* `pdf` - One of:<br>

    * `unknown`

    * `normal`

    * `rectangular`

* `value` - A percentage indicating the confidence.<br>

##### format


* `civicAddress` - The 'location\_info' parameter must contain a comma separated list of IANA codes or synonyms describing the civicAddress of this location. The IANA codes and synonyms can be obtained by executing the CLI command 'geoloc show civicAddr\_mapping'.<br>

* `GML` - The 'location\_info' parameter must contain a comma separated list valid GML elements describing this location.<br>

* `URI` - The 'location\_info' parameter must contain a single URI parameter which contains an external URI describing this location.<br>

##### location_info

The contents of this parameter are specific to the location 'format'.<br>


* `civicAddress` - location\_info = country=US,A1="New York",city\_district=Manhattan, A3="New York", house\_number=1633, street=46th, street\_suffix = Street, postal\_code=10222,floor=20,room=20A2<br>

* `GML` - location\_info = Shape=Sphere, pos3d="39.12345 -105.98766 1920", radius=200<br>

* `URI` - location\_info = URI=https:/something.com?exten=$\{EXTEN\}<br>

##### location_source

This parameter isn't required but if provided, RFC8787 says it MUST be a fully qualified host name. IP addresses are specifically NOT allowed. The value will be placed in a 'loc-src' parameter appended to the URI in the ' Geolocation' header.<br>


##### method

This is a rarely used field in the specification that would indicate the method used to determine the location. Its usage and values should be pre-negotiated with any recipients.<br>


* `GPS`

* `A-GPS`

* `Manual`

* `DHCP`

* `Triangulation`

* `Cell`

* `802.11`

##### notes

The specification of this parameter will cause a '<note-well>' element to be added to the outgoing PIDF-LO document. Its usage should be pre-negotiated with any recipients.<br>


##### pidf_element


* `tuple`

* `device`

* `person`
Based on RFC5491 (see below) the recommended and default element is 'device'.<br>


##### profile_precedence


* `prefer_incoming` - Use the incoming profile if it exists and has location information, otherwise use the configured profile if it exists and has location information. If neither profile has location information, nothing is sent.<br>

* `prefer_config` - Use the configured profile if it exists and has location information, otherwise use the incoming profile if it exists and has location information. If neither profile has location information, nothing is sent.<br>

* `discard_incoming` - Discard any incoming profile and use the configured profile if it exists and it has location information. If the configured profile doesn't exist or has no location information, nothing is sent.<br>

* `discard_config` - Discard any configured profile and use the incoming profile if it exists and it has location information. If the incoming profile doesn't exist or has no location information, nothing is sent.<br>

##### usage_rules

xxxx<br>



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 