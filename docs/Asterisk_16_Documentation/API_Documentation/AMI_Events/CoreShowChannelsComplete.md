---
search:
  boost: 0.5
title: CoreShowChannelsComplete
---

# CoreShowChannelsComplete

### Synopsis

Raised at the end of the CoreShowChannel list produced by the CoreShowChannels command.

### Syntax


```


    Event: CoreShowChannelsComplete
    ActionID: <value>
    EventList: <value>
    ListItems: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `EventList` - Conveys the status of the command reponse list<br>

* `ListItems` - The total number of list items produced<br>

### Class

CALL
### See Also

* [AMI Actions CoreShowChannels](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/CoreShowChannels)
* [AMI Events CoreShowChannel](/Asterisk_16_Documentation/API_Documentation/AMI_Events/CoreShowChannel)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 