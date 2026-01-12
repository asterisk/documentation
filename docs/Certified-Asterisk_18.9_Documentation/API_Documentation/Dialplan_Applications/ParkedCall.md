---
search:
  boost: 0.5
title: ParkedCall
---

# ParkedCall()

### Synopsis

Retrieve a parked call.

### Description

Used to retrieve a parked call from a parking lot.<br>


/// note
If a parking lot's parkext option is set, then Parking lots will automatically create and manage dialplan extensions in the parking lot context. If that is the case then you will not need to manage parking extensions yourself, just include the parking context of the parking lot.
///


### Syntax


```

ParkedCall([parking_lot_name,[parking_space]])
```
##### Arguments


* `parking_lot_name` - Specify from which parking lot to retrieve a parked call.<br>
The parking lot used is selected in the following order:<br>
1) parking\_lot\_name option<br>
2) **PARKINGLOT** variable<br>
3) 'CHANNEL(parkinglot)' function (Possibly preset by the channel driver.)<br>
4) Default parking lot.<br>

* `parking_space` - Parking space to retrieve a parked call from. If not provided then the first available parked call in the parking lot will be retrieved.<br>

### See Also

* [Dialplan Applications Park](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Park)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 