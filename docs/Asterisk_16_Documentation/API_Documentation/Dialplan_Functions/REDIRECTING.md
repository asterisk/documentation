---
search:
  boost: 0.5
title: REDIRECTING
---

# REDIRECTING()

### Synopsis

Gets or sets Redirecting data on the channel.

### Description

Gets or sets Redirecting data on the channel.<br>

The _orig-pres_, _from-pres_ and _to-pres_ fields get/set a combined value for the corresponding _...-name-pres_ and _...-num-pres_ fields.<br>

The recognized values for the _reason_ and _orig-reason_ fields are the following:<br>


* `away` - Callee is Away<br>

* `cf_dte` - Call Forwarding By The Called DTE<br>

* `cfb` - Call Forwarding Busy<br>

* `cfnr` - Call Forwarding No Reply<br>

* `cfu` - Call Forwarding Unconditional<br>

* `deflection` - Call Deflection<br>

* `dnd` - Do Not Disturb<br>

* `follow_me` - Follow Me<br>

* `out_of_order` - Called DTE Out-Of-Order<br>

* `send_to_vm` - Send the call to voicemail<br>

* `time_of_day` - Time of Day<br>

* `unavailable` - Callee is Unavailable<br>

* `unknown` - Unknown<br>

/// note
You can set a user defined reason string that SIP can send/receive instead. The user defined reason string my need to be quoted depending upon SIP or the peer's requirements. These strings are treated as unknown by the non-SIP channel drivers.
///

The allowable values for the _xxx-name-charset_ field are the following:<br>


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

REDIRECTING(datatype,i)
```
##### Arguments


* `datatype` - The allowable datatypes are:<br>

    * `orig-all`

    * `orig-name`

    * `orig-name-valid`

    * `orig-name-charset`

    * `orig-name-pres`

    * `orig-num`

    * `orig-num-valid`

    * `orig-num-plan`

    * `orig-num-pres`

    * `orig-pres`

    * `orig-subaddr`

    * `orig-subaddr-valid`

    * `orig-subaddr-type`

    * `orig-subaddr-odd`

    * `orig-tag`

    * `orig-reason`

    * `from-all`

    * `from-name`

    * `from-name-valid`

    * `from-name-charset`

    * `from-name-pres`

    * `from-num`

    * `from-num-valid`

    * `from-num-plan`

    * `from-num-pres`

    * `from-pres`

    * `from-subaddr`

    * `from-subaddr-valid`

    * `from-subaddr-type`

    * `from-subaddr-odd`

    * `from-tag`

    * `to-all`

    * `to-name`

    * `to-name-valid`

    * `to-name-charset`

    * `to-name-pres`

    * `to-num`

    * `to-num-valid`

    * `to-num-plan`

    * `to-num-pres`

    * `to-pres`

    * `to-subaddr`

    * `to-subaddr-valid`

    * `to-subaddr-type`

    * `to-subaddr-odd`

    * `to-tag`

    * `priv-orig-all`

    * `priv-orig-name`

    * `priv-orig-name-valid`

    * `priv-orig-name-charset`

    * `priv-orig-name-pres`

    * `priv-orig-num`

    * `priv-orig-num-valid`

    * `priv-orig-num-plan`

    * `priv-orig-num-pres`

    * `priv-orig-subaddr`

    * `priv-orig-subaddr-valid`

    * `priv-orig-subaddr-type`

    * `priv-orig-subaddr-odd`

    * `priv-orig-tag`

    * `priv-from-all`

    * `priv-from-name`

    * `priv-from-name-valid`

    * `priv-from-name-charset`

    * `priv-from-name-pres`

    * `priv-from-num`

    * `priv-from-num-valid`

    * `priv-from-num-plan`

    * `priv-from-num-pres`

    * `priv-from-subaddr`

    * `priv-from-subaddr-valid`

    * `priv-from-subaddr-type`

    * `priv-from-subaddr-odd`

    * `priv-from-tag`

    * `priv-to-all`

    * `priv-to-name`

    * `priv-to-name-valid`

    * `priv-to-name-charset`

    * `priv-to-name-pres`

    * `priv-to-num`

    * `priv-to-num-valid`

    * `priv-to-num-plan`

    * `priv-to-num-pres`

    * `priv-to-subaddr`

    * `priv-to-subaddr-valid`

    * `priv-to-subaddr-type`

    * `priv-to-subaddr-odd`

    * `priv-to-tag`

    * `reason`

    * `count`

* `i` - If set, this will prevent the channel from sending out protocol messages because of the value being set<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 