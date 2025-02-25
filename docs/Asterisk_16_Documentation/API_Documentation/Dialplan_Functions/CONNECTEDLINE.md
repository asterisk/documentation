---
search:
  boost: 0.5
title: CONNECTEDLINE
---

# CONNECTEDLINE()

### Synopsis

Gets or sets Connected Line data on the channel.

### Description

Gets or sets Connected Line data on the channel.<br>

The _pres_ field gets/sets a combined value for _name-pres_ and _num-pres_.<br>

The allowable values for the _name-charset_ field are the following:<br>


* `unknown` - Unknown<br>

* `iso8859-1` - ISO8859-1<br>

* `withdrawn` - Withdrawn<br>

* `iso8859-2` - ISO8859-2<br>

* `iso8859-3` - ISO8859-3<br>

* `iso8859-4` - ISO8859-4<br>

* `iso8859-5` - ISO8859-5<br>

* `iso8859-7` - ISO8859-7<br>

* `bmp` - ISO10646 Bmp String<br>

* `utf8` - ISO10646 UTF-8 String<br>

### Syntax


```

CONNECTEDLINE(datatype,i)
```
##### Arguments


* `datatype` - The allowable datatypes are:<br>

    * `all`

    * `name`

    * `name-valid`

    * `name-charset`

    * `name-pres`

    * `num`

    * `num-valid`

    * `num-plan`

    * `num-pres`

    * `pres`

    * `subaddr`

    * `subaddr-valid`

    * `subaddr-type`

    * `subaddr-odd`

    * `tag`

    * `priv-all`

    * `priv-name`

    * `priv-name-valid`

    * `priv-name-charset`

    * `priv-name-pres`

    * `priv-num`

    * `priv-num-valid`

    * `priv-num-plan`

    * `priv-num-pres`

    * `priv-subaddr`

    * `priv-subaddr-valid`

    * `priv-subaddr-type`

    * `priv-subaddr-odd`

    * `priv-tag`

* `i` - If set, this will prevent the channel from sending out protocol messages because of the value being set<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 