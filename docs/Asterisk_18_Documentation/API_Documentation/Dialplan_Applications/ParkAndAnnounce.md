---
search:
  boost: 0.5
title: ParkAndAnnounce
---

# ParkAndAnnounce()

### Synopsis

Park and Announce.

### Description

Park a call into the parkinglot and announce the call to another channel.<br>

The variable **PARKEDAT** will contain the parking extension into which the call was placed. Use with the Local channel to allow the dialplan to make use of this information.<br>


### Syntax


```

ParkAndAnnounce([parking_lot_name,[options,announce:[announce1[:...]],]]dial)
```
##### Arguments


* `parking_lot_name` - Specify in which parking lot to park a call.<br>
The parking lot used is selected in the following order:<br>
1) parking\_lot\_name option to this application<br>
2) **PARKINGLOT** variable<br>
3) 'CHANNEL(parkinglot)' function (Possibly preset by the channel driver.)<br>
4) Default parking lot.<br>

* `options` - A list of options for this parked call.<br>

    * `r` - Send ringing instead of MOH to the parked call.<br>


    * `R` - Randomize the selection of a parking space.<br>


    * `c(context,extension,priority)` - If the parking times out, go to this place in the dialplan instead of where the parking lot defines the call should go.<br>

        * `context`

        * `extension`

        * `priority` **required**


    * `t(duration)` - Use a timeout of 'duration' seconds instead of the timeout specified by the parking lot.<br>

        * `duration` **required**


* `announce_template`

    * `announce` **required** - Colon-separated list of files to announce. The word 'PARKED' will be replaced by a say\_digits of the extension in which the call is parked.<br>

    * `announce1[,announce1...]`

* `dial` - The app\_dial style resource to call to make the announcement. Console/dsp calls the console.<br>

### See Also

* [Dialplan Applications Park](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Park)
* [Dialplan Applications ParkedCall](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/ParkedCall)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 