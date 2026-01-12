---
search:
  boost: 0.5
title: CALLERID
---

# CALLERID()

### Synopsis

Gets or sets Caller*ID data on the channel.

### Description

Gets or sets Caller*ID data on the channel. Uses channel callerid by default or optional callerid, if specified.<br>

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
The allowable values for the _num-pres_, _name-pres_, and _pres_ fields are the following:<br>


* `allowed_not_screened` - Presentation Allowed, Not Screened.<br>

* `allowed_passed_screen` - Presentation Allowed, Passed Screen.<br>

* `allowed_failed_screen` - Presentation Allowed, Failed Screen.<br>

* `allowed` - Presentation Allowed, Network Number.<br>

* `prohib_not_screened` - Presentation Prohibited, Not Screened.<br>

* `prohib_passed_screen` - Presentation Prohibited, Passed Screen.<br>

* `prohib_failed_screen` - Presentation Prohibited, Failed Screen.<br>

* `prohib` - Presentation Prohibited, Network Number.<br>

* `unavailable` - Number Unavailable.<br>

* `CALL_QUALIFIER` - This is a special Caller ID-related variable that can be used to enable sending the Call Qualifier parameter in MDMF (Multiple Data Message Format) Caller ID spills.<br>
This variable is not automatically set by Asterisk. You are responsible for setting it if/when needed.<br>
Supporting Caller ID units will display the LDC (Long Distance Call) indicator when they receive this parameter.<br>
For incoming calls on FXO ports, if the Call Qualifier parameter is received, this variable will also be set to 1.<br>
This option must be used with a channel driver that allows Asterisk to generate the Caller ID spill, which currently only includes 'chan\_dahdi'.<br>

### Syntax


```

CALLERID(datatype,CID)
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

    * `ANI-all`

    * `ANI-name`

    * `ANI-name-valid`

    * `ANI-name-charset`

    * `ANI-name-pres`

    * `ANI-num`

    * `ANI-num-valid`

    * `ANI-num-plan`

    * `ANI-num-pres`

    * `ANI-tag`

    * `RDNIS`

    * `DNID`

    * `dnid-num-plan`

    * `dnid-subaddr`

    * `dnid-subaddr-valid`

    * `dnid-subaddr-type`

    * `dnid-subaddr-odd`

* `CID` - Optional Caller*ID to parse instead of using the Caller*ID from the channel. This parameter is only optional when reading the Caller*ID.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 