---
search:
  boost: 0.5
title: OSPAuth
---

# OSPAuth()

### Synopsis

OSP Authentication.

### Description

Authenticate a call by OSP.<br>

Input variables:<br>


* `OSPINPEERIP` - The last hop IP address.<br>

* `OSPINTOKEN` - The inbound OSP token.<br>
Output variables:<br>


* `OSPINHANDLE` - The inbound call OSP transaction handle.<br>

* `OSPINTIMELIMIT` - The inbound call duration limit in seconds.<br>
This application sets the following channel variable upon completion:<br>


* `OSPAUTHSTATUS` - The status of OSPAuth attempt as a text string, one of<br>

    * `SUCCESS`

    * `FAILED`

    * `ERROR`

### Syntax


```

OSPAuth([provider,[options]])
```
##### Arguments


* `provider` - The name of the provider that authenticates the call.<br>

* `options` - Reserverd.<br>

### See Also

* [Dialplan Applications OSPLookup](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/OSPLookup)
* [Dialplan Applications OSPNext](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/OSPNext)
* [Dialplan Applications OSPFinish](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/OSPFinish)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 