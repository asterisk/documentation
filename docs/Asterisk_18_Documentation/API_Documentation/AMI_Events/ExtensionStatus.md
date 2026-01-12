---
search:
  boost: 0.5
title: ExtensionStatus
---

# ExtensionStatus

### Synopsis

Raised when a hint changes due to a device state change.

### Syntax


```


Event: ExtensionStatus
Exten: <value>
Context: <value>
Hint: <value>
Status: <value>
StatusText: <value>

```
##### Arguments


* `Exten` - Name of the extension.<br>

* `Context` - Context that owns the extension.<br>

* `Hint` - Hint set for the extension<br>

* `Status` - Numerical value of the extension status. Extension status is determined by the combined device state of all items contained in the hint.<br>

    * `-2` - The extension was removed from the dialplan.<br>

    * `-1` - The extension's hint was removed from the dialplan.<br>

    * `0` - Idle - Related device(s) are in an idle state.<br>

    * `1` - InUse - Related device(s) are in active calls but may take more calls.<br>

    * `2` - Busy - Related device(s) are in active calls and may not take any more calls.<br>

    * `4` - Unavailable - Related device(s) are not reachable.<br>

    * `8` - Ringing - Related device(s) are currently ringing.<br>

    * `9` - InUse&Ringing - Related device(s) are currently ringing and in active calls.<br>

    * `16` - Hold - Related device(s) are currently on hold.<br>

    * `17` - InUse&Hold - Related device(s) are currently on hold and in active calls.<br>

* `StatusText` - Text representation of 'Status'.<br>

    * `Idle`

    * `InUse`

    * `Busy`

    * `Unavailable`

    * `Ringing`

    * `InUse&Ringing`

    * `Hold`

    * `InUse&Hold`

    * `Unknown` - Status does not match any of the above values.<br>

### Class

CALL
### See Also

* [AMI Actions ExtensionState](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/ExtensionState)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 