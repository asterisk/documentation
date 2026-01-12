---
search:
  boost: 0.5
title: OSPFinish
---

# OSPFinish()

### Synopsis

Report OSP entry.

### Description

Report call state.<br>

Input variables:<br>


* `OSPINHANDLE` - The inbound call OSP transaction handle.<br>

* `OSPOUTHANDLE` - The outbound call OSP transaction handle.<br>

* `OSPAUTHSTATUS` - The OSPAuth status.<br>

* `OSPLOOKUPSTATUS` - The OSPLookup status.<br>

* `OSPNEXTSTATUS` - The OSPNext status.<br>

* `OSPINAUDIOQOS` - The inbound call leg audio QoS string.<br>

* `OSPOUTAUDIOQOS` - The outbound call leg audio QoS string.<br>
This application sets the following channel variable upon completion:<br>


* `OSPFINISHSTATUS` - The status of the OSPFinish attempt as a text string, one of<br>

    * `SUCCESS`

    * `FAILED`

    * `ERROR`

### Syntax


```

OSPFinish([cause,[options]])
```
##### Arguments


* `cause` - Hangup cause.<br>

* `options` - Reserved.<br>

### See Also

* [Dialplan Applications OSPAuth](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/OSPAuth)
* [Dialplan Applications OSPLookup](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/OSPLookup)
* [Dialplan Applications OSPNext](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/OSPNext)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 