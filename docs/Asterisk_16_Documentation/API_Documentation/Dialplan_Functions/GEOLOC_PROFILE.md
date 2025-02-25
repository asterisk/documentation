---
search:
  boost: 0.5
title: GEOLOC_PROFILE
---

# GEOLOC_PROFILE()

### Synopsis

Get or Set a field in a geolocation profile

### Description

When used to set a parameter on a profile, if the profile doesn't already exist, a new one will be created automatically.<br>

The '$\{GEOLOCPROFILESTATUS\}' channel variable will be set with a return code indicating the result of the operation. Possible values are:<br>


* `0` - Success<br>

* `-1` - No or not enough parameters were supplied<br>

* `-2` - There was an internal error finding or creating a profile<br>

* `-3` - There was an issue specific to the parameter specified (value not valid or parameter name not found, etc.)<br>

### Syntax


```

GEOLOC_PROFILE(parameter[,options])
```
##### Arguments


* `parameter` - The profile parameter to operate on. The following fields from the Location and Profile objects are supported.<br>

    * `id`

    * `location_reference`

    * `method`

    * `allow_routing_use`

    * `profile_precedence`

    * `format`

    * `pidf_element`

    * `location_source`

    * `notes`

    * `location_info`

    * `location_info_refinement`

    * `location_variables`

    * `effective_location`

    * `usage_rules`

    * `confidence`
Additionally, the 'inheritable' field may be set to 'true' or 'false' to control whether the profile will be passed to the outgoing channel.<br>
<br>

* `options`

    * `a` - Append provided value to the specified parameter instead of replacing the existing value. This only applies to variable list parameters like 'location\_info\_refinement'.<br>


    * `r` - Before reading or after writing the specified parameter, re-resolve the 'effective\_location' and 'usage\_rules' parameters using the 'location\_variables' parameter and the variables set on the channel in effect at the time this function is called.<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 