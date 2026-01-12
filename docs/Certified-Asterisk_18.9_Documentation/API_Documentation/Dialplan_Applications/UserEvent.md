---
search:
  boost: 0.5
title: UserEvent
---

# UserEvent()

### Synopsis

Send an arbitrary user-defined event to parties interested in a channel (AMI users and relevant res_stasis applications).

### Description

Sends an arbitrary event to interested parties, with an optional _body_ representing additional arguments. The _body_ may be specified as a ',' delimited list of key:value pairs.<br>

For AMI, each additional argument will be placed on a new line in the event and the format of the event will be:<br>

Event: UserEvent<br>

UserEvent: <specified event name><br>

\[body\]<br>

If no _body_ is specified, only Event and UserEvent headers will be present.<br>

For res\_stasis applications, the event will be provided as a JSON blob with additional arguments appearing as keys in the object and the _eventname_ under the _eventname_ key.<br>


### Syntax


```

UserEvent(eventname,[body])
```
##### Arguments


* `eventname`

* `body`

### See Also

* [AMI Actions UserEvent](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Actions/UserEvent)
* [AMI Events UserEvent](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/UserEvent)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 