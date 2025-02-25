---
search:
  boost: 0.5
title: FEATUREMAP
---

# FEATUREMAP()

### Synopsis

Get or set a feature map to a given value on a specific channel.

### Description

When this function is used as a read, it will get the current digit sequence mapped to the specified feature for this channel. This value will be the one configured in features.conf if a channel specific value has not been set. This function can also be used to set a channel specific value for a feature mapping.<br>


### Syntax


```

FEATUREMAP(feature_name)
```
##### Arguments


* `feature_name` - The allowed values are:<br>

    * `atxfer` - Attended Transfer<br>

    * `blindxfer` - Blind Transfer<br>

    * `automon` - Auto Monitor<br>

    * `disconnect` - Call Disconnect<br>

    * `parkcall` - Park Call<br>

    * `automixmon` - Auto MixMonitor<br>

### See Also

* [Dialplan Functions FEATURE](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/FEATURE)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 